"""Offline regression suite. Ordinary profiles disable AI; provider tests bind mocks; graph fixtures never touch root."""
import copy;
import json;
import os;
import time;
import threading;
import from contextvars { ContextVar }
import from unittest.mock { patch, Mock }
import from contextlib { AbstractContextManager }
import from services.engine {
    _load_catalogue, _validate_profile, _requirements, _cashflow, _candidate, _stress, _sort_candidates,
    BranchSearchWalker, Catalogue, Offering, ProgressesTo
}
import from services.planner { _planning_session, _safe_model_call, PlannerDecision }
import from services.compat { _UniPathPageCompatibility, _UniPathAPIServer }
import from services.gemini { BoundedGeminiModel }
import from byllm.lib { Model, MTRuntime }

def profile(overrides: dict | None = None) -> dict {
    raw = {"catalogue_mode": "demo", "enable_ai": False, "al_passes": 3,
        "has_maths_credit": False, "can_relocate": True};
    if overrides is not None { raw.update(overrides); }
    return _validate_profile(raw);
}

def fixture(offering_id: str) -> dict {
    for row in (_load_catalogue("demo").data["offerings"] as list[dict]) {
        if row["id"] == offering_id { return copy.deepcopy(row) as dict; }
    }
    raise ValueError("Missing fixture");
}

def isolated_graph(records: list[dict], transitions: list[dict]) -> Catalogue {
    graph = Catalogue(mode="demo", version="isolated-test", data={"offerings": records, "transitions": transitions});
    nodes: dict[str, Offering] = {};
    for record in records { nodes[str(record["id"])] = (graph ++> Offering(record=record))[0] as Offering; }
    for transition in transitions {
        nodes[str(transition["from_id"])] +>: ProgressesTo(record=transition) :+> nodes[str(transition["to_id"])];
    }
    return graph;
}

def stage(name: str, requirements: dict | None = None, terminal: bool = True) -> dict {
    row = fixture("DEMO-FOUNDATION");
    row.update({"id": name, "award_id": "QUAL-" + name, "title": name, "requirements": requirements if requirements is not None else {}, "terminal": terminal});
    return row;
}

def link(source: str, target: str, requirements: dict | None = None, evidence: str = "fixture") -> dict {
    return {"from_id": source, "to_id": target, "requirements": requirements if requirements is not None else {},
        "claims": [{"id": "EDGE-" + source + "-" + target, "status": evidence}]};
}

def rejects(raw: dict) {
    try { _validate_profile(raw); assert False, "invalid input was accepted"; }
    except ValueError { assert True; }
}

test "T01 real catalogue covers twelve fields with official sources" {
    catalogue = _load_catalogue("real");
    domains = catalogue.data["domains"] as list[dict];
    assert len(domains) == 12;
    for domain in domains {
        rows = [o for o in (catalogue.data["offerings"] as list[dict]) if domain["id"] in o["domain_ids"]];
        assert len(rows) >= 2, "insufficient programmes for " + str(domain["id"]);
        for row in rows {
            assert not str(row["id"]).startswith("DEMO-");
            assert row["claims"], "missing evidence claims";
            assert any([str(c["source_url"]).startswith("https://") for c in (row["claims"] as list[dict])]);
        }
    }
}

test "T02 non computing student goal remains in selected field" {
    result = _planning_session(profile({"catalogue_mode": "real", "domain_id": "law", "career_goal": "Lawyer"}));
    assert result["domain_id"] == "law";
    assert result["candidates"], "law lookup returned no exploratory routes";
    for route in (result["candidates"] as list[dict]) {
        for row in (route["steps"] as list[dict]) { assert "law" in row["domain_ids"]; }
    }
}

test "T03 direct fixture cash oracle" {
    direct = fixture("DEMO-DIRECT-DEG");
    cash = _cashflow([direct], profile());
    assert cash["total_cost_lkr"] == 84000;
    assert cash["minimum_balance_lkr"] == -22000;
    assert cash["shortfall_lkr"] == 22000;
    assert cash["duration_months"] == 12;
    assert cash["status"] == "shortfall";
    assert _cashflow([direct], profile({"savings_lkr": 24000}))["shortfall_lkr"] == 0;
}

test "T04 three step fixture cash and relocation oracle" {
    path = [fixture("DEMO-FOUNDATION"), fixture("DEMO-DIPLOMA"), fixture("DEMO-TOPUP")];
    edges = _load_catalogue("demo").data["transitions"] as list[dict];
    cash = _cashflow(path, profile());
    assert cash["total_cost_lkr"] == 54000;
    assert cash["minimum_balance_lkr"] == 0;
    assert cash["shortfall_lkr"] == 0;
    assert cash["duration_months"] == 12;
    assert _candidate(path, edges[:2], profile({"can_relocate": None}))["route_status"] == "needs_confirmation";
    assert _candidate(path, edges[:2], profile())["route_status"] == "conditional";
}

test "T05 direct stress independently calculated oracle" {
    p = profile({"savings_lkr": 24000});
    result = _stress(p, "travel_plus_40_and_delay_6m");
    search = _load_catalogue("demo") spawn BranchSearchWalker(profile=p);
    direct = [c for c in search.candidates if c["step_ids"] == ["DEMO-DIRECT-DEG"]][0];
    delta = [d for d in (result["deltas"] as list[dict]) if d["route_id"] == direct["route_id"]][0];
    assert delta["delta_total_cost_lkr"] == 40800;
    assert delta["delta_duration_months"] == 6;
    assert result["profile_revision"] == p["profile_revision"];
}

test "T06 null fee schedules stay unknown in baseline and stress" {
    row = fixture("DEMO-DIRECT-DEG");
    row["upfront_cost_lkr"] = None;
    for scenario in ["baseline", "travel_plus_40_and_delay_6m"] {
        cash = _cashflow([row], profile(), scenario);
        assert cash["status"] == "unknown_cost";
        assert cash["total_cost_lkr"] is None;
        assert cash["shortfall_lkr"] is None;
    }
    real = _stress(profile({"catalogue_mode": "real"}), "travel_plus_40_and_delay_6m");
    assert real["deltas"];
    for delta in (real["deltas"] as list[dict]) {
        if not delta["available"] { assert delta["delta_total_cost_lkr"] is None; }
    }
}

test "T07 unknown requirement differs from known failure" {
    condition = {"field": "can_relocate", "cmp": "==", "value": True};
    assert _requirements(condition, profile({"can_relocate": None}), [])["verdict"] == "unknown";
    assert _requirements(condition, profile({"can_relocate": False}), [])["verdict"] == "fail";
    assert _requirements({"field": "institution_confirmation", "value": True}, profile(), [])["verdict"] == "unknown";
}

test "T08 incoming edge never bypasses missing AND prerequisite" {
    source = stage("SOURCE", {}, False);
    target = stage("TARGET", {"op": "all", "conditions": [
        {"field": "qualification", "value": "QUAL-SOURCE"},
        {"field": "has_maths_credit", "cmp": "==", "value": True}]});
    graph = isolated_graph([source, target], [link("SOURCE", "TARGET")]);
    result = graph spawn BranchSearchWalker(profile=profile({"has_maths_credit": False}));
    assert result.candidates == [];
    assert any([r["offering_id"] == "TARGET" for r in result.blocked]);
    assert any([e["action"] == "backtrack" for e in result.events]);
    allowed = graph spawn BranchSearchWalker(profile=profile({"has_maths_credit": True}));
    assert any([r["step_ids"] == ["SOURCE", "TARGET"] for r in allowed.candidates]);
}

test "T09 sibling branches do not share earned qualifications" {
    shared = stage("START", {}, False);
    left = stage("LEFT", {"field": "qualification", "value": "QUAL-START"}, False);
    right = stage("RIGHT", {"field": "qualification", "value": "QUAL-LEFT"});
    graph = isolated_graph([shared, left, right], [link("START", "LEFT"), link("START", "RIGHT")]);
    result = graph spawn BranchSearchWalker(profile=profile());
    assert not any(["RIGHT" in r["step_ids"] for r in result.candidates]);
    assert any([r["offering_id"] == "RIGHT" for r in result.blocked]);
}

test "T10 actual cyclic graph terminates without repeated stage" {
    a = stage("A"); b = stage("B");
    graph = isolated_graph([a, b], [link("A", "B"), link("B", "A")]);
    result = graph spawn BranchSearchWalker(profile=profile());
    assert len(result.candidates) == 4;
    assert len([e for e in result.events if e["action"] == "cycle_pruned"]) == 2;
    for route in result.candidates { assert len(route["step_ids"] as list) == len(set(route["step_ids"] as list)); }
}

test "T11 transition rules and rejected evidence prevent progression" {
    a = stage("A", {}, False);
    b = stage("B", {"field": "qualification", "value": "QUAL-A"});
    for transition in [link("A", "B", {"field": "can_relocate", "value": True}), link("A", "B", {}, "rejected")] {
        graph = isolated_graph([copy.deepcopy(a) as dict, copy.deepcopy(b) as dict], [transition]);
        result = graph spawn BranchSearchWalker(profile=profile({"can_relocate": False}));
        assert result.candidates == [];
        assert any([e["action"] == "backtrack" for e in result.events]);
    }
    stale = _candidate([a, b], [link("A", "B", {}, "stale")], profile());
    assert stale["evidence_status"] == "stale";
    assert stale["route_status"] == "needs_confirmation";
}

test "T12 route identifiers stable and profiles remain isolated" {
    root_count_before = len([root -->]);
    raw = {"catalogue_mode": "demo", "enable_ai": False, "al_passes": 3, "can_relocate": True, "has_maths_credit": False};
    snapshot = json.dumps(raw, sort_keys=True);
    catalogue = _load_catalogue("demo");
    before = json.dumps(catalogue.data, sort_keys=True);
    first = _planning_session(_validate_profile(raw));
    second = _planning_session(profile({"profile_revision": 99, "savings_lkr": 24000}));
    again = _planning_session(_validate_profile(raw));
    assert first["profile_revision"] == 1 and second["profile_revision"] == 99;
    assert [c["route_id"] for c in (first["candidates"] as list[dict])] == [c["route_id"] for c in (again["candidates"] as list[dict])];
    assert json.dumps(raw, sort_keys=True) == snapshot;
    assert json.dumps(catalogue.data, sort_keys=True) == before;
    assert len([root -->]) == root_count_before, "student data must not attach to root";
}

test "T13 hard candidate cap marks truncation" {
    rows: list[dict] = [stage("CAP-" + str(i)) for i in range(25)];
    graph = isolated_graph(rows, []);
    result = graph spawn BranchSearchWalker(profile=profile());
    assert len(result.candidates) == 20;
    assert result.truncated;
}

test "T14 default step limit and state budget terminate exploration" {
    rows: list[dict] = [stage("CHAIN-" + str(i), {}, i == 5) for i in range(6)];
    edges: list[dict] = [link("CHAIN-" + str(i), "CHAIN-" + str(i + 1)) for i in range(5)];
    for i in range(1, 6) { rows[i]["requirements"] = {"field": "qualification", "value": "QUAL-CHAIN-" + str(i - 1)}; }
    graph = isolated_graph(rows, edges);
    result = graph spawn BranchSearchWalker(profile=profile());
    assert result.max_states == 100 and result.max_steps == 4 and result.max_candidates == 20;
    assert result.candidates == [] and result.truncated;
    state_limited = graph spawn BranchSearchWalker(profile=profile(), max_states=2, max_steps=10);
    assert state_limited.truncated and state_limited.candidates == [];
}

test "T15 rejects malformed profiles and client calculated results" {
    for raw in [{"catalogue_mode": "invented"}, {"domain_id": "invented"}, {"study_mode": "telepathy"},
        {"traversal": "unsafe"}, {"savings_lkr": -1}, {"savings_lkr": True}, {"monthly_budget_lkr": False},
        {"monthly_budget_lkr": 1.5}, {"al_passes": True}, {"al_passes": 4}, {"enable_ai": "false"},
        {"route_status": "feasible"}, {"candidates": []}, {"total_cost_lkr": 0},
        {"existing_qualifications": ["INVENTED"]}, {"ol_maths_grade": "D"},
        {"al_subjects": [{"name": "Physics", "grade": "D"}]}] {
        rejects(raw);
    }
    rejects({"al_passes": 3, "al_subjects": [{"name": "A", "grade": "A"}, {"name": "B", "grade": "S"}, {"name": "C", "grade": "F"}]});
    assert _validate_profile({"enable_ai": False, "al_subjects": [{"name": "A", "grade": "A"}, {"name": "B", "grade": "S"}, {"name": "C", "grade": "F"}]})["al_passes"] == 2;
    try { _stress(profile(), "invented"); assert False; } except ValueError { assert True; }
}

test "T16 offline fallback labelled and bounded" {
    result = _planning_session(profile({"can_relocate": None}));
    assert result["planner_mode"] == "rules_fallback";
    assert "switched off" in result["fallback_reason"];
    assert len(result["decision_events"] as list) <= 4;
    assert result["pending_question"]["field"] == "can_relocate";
}

test "T17 invented model route and skipped action rejected offline" {
    result = _planning_session(profile(), [{"action": "finish", "route_ids": ["invented"]}]);
    assert result["planner_mode"] == "test_stub";
    assert "rejected" in result["fallback_reason"];
    assert result["candidates"], "required search and evaluation must still occur";
    assert len(result["decision_events"] as list) <= 4;
    assert all([c["route_id"] != "invented" for c in (result["candidates"] as list[dict])]);
}

test "T18 scripted ranking cannot promote infeasible direct route" {
    p = profile();
    search = _load_catalogue("demo") spawn BranchSearchWalker(profile=p);
    direct = [c for c in search.candidates if c["step_ids"] == ["DEMO-DIRECT-DEG"]][0];
    bridge = [c for c in search.candidates if c["step_ids"] == ["DEMO-FOUNDATION", "DEMO-DIPLOMA", "DEMO-TOPUP"]][0];
    result = _planning_session(p, [{"action": "search_alternatives"}, {"action": "evaluate_candidates"},
        {"action": "finish", "route_ids": [direct["route_id"], bridge["route_id"]], "explanation": "UNTRUSTED CLAIM: admission guaranteed"}]);
    assert result["planner_mode"] == "test_stub";
    assert result["candidates"][0]["route_id"] == bridge["route_id"];
    assert result["blocked_candidates"][0]["route_id"] == direct["route_id"];
    assert result["blocked_candidates"][0]["cashflow"]["shortfall_lkr"] == 22000;
    assert "UNTRUSTED CLAIM: admission guaranteed" not in json.dumps(result);
}


test "T19 default one hundred state limit applies without terminal candidates" {
    rows: list[dict] = [stage("STATE-" + str(i), {}, False) for i in range(101)];
    at_limit = isolated_graph(rows[:100], []) spawn BranchSearchWalker(profile=profile());
    assert not at_limit.truncated and at_limit.candidates == [];
    over_limit = isolated_graph(rows, []) spawn BranchSearchWalker(profile=profile());
    assert over_limit.truncated and over_limit.candidates == [];
}



def _assert_fallback_actions(result: dict) {
    actions = [event["action"] for event in (result["decision_events"] as list[dict])];
    assert "search_alternatives" in actions and "evaluate_candidates" in actions;
    assert len(actions) <= 4 and result["planner_mode"] == "rules_fallback";
    assert result["candidates"], "rule evaluation must survive provider failure";
}

test "T20 missing provider key falls back without calling provider" {
    with patch("services.planner._safe_model_call", side_effect=AssertionError("provider must not be called")) as mocked {
        assert getattr(_planning_session, "__globals__")["_safe_model_call"] is mocked, "provider boundary patch did not bind";
        with (patch.dict(os.environ, {}, clear=True) as AbstractContextManager[object]) {
            started = time.monotonic();
            result = _planning_session(profile({"enable_ai": True}));
            elapsed = time.monotonic() - started;
        }
        assert mocked.call_count == 0;
    }
    _assert_fallback_actions(result);
    assert "No server-side Gemini key" in result["fallback_reason"];
    assert elapsed < 1.0;
}

test "T21 injected provider timeout safely falls back immediately" {
    with patch("services.planner._safe_model_call", side_effect=TimeoutError("injected timeout")) as mocked {
        assert getattr(_planning_session, "__globals__")["_safe_model_call"] is mocked, "provider boundary patch did not bind";
        with (patch.dict(os.environ, {"GOOGLE_API_KEY": "test-only", "GEMINI_API_KEY": ""}, clear=False) as AbstractContextManager[object]) {
            started = time.monotonic();
            result = _planning_session(profile({"enable_ai": True}));
            elapsed = time.monotonic() - started;
        }
        assert mocked.call_count == 1;
    }
    _assert_fallback_actions(result);
    assert "provider or time budget" in result["fallback_reason"];
    assert elapsed < 1.0;
}

test "T22 injected provider outage safely falls back immediately" {
    with patch("services.planner._safe_model_call", side_effect=RuntimeError("injected outage")) as mocked {
        assert getattr(_planning_session, "__globals__")["_safe_model_call"] is mocked, "provider boundary patch did not bind";
        with (patch.dict(os.environ, {"GOOGLE_API_KEY": "test-only", "GEMINI_API_KEY": ""}, clear=False) as AbstractContextManager[object]) {
            started = time.monotonic();
            result = _planning_session(profile({"enable_ai": True}));
            elapsed = time.monotonic() - started;
        }
        assert mocked.call_count == 1;
    }
    _assert_fallback_actions(result);
    assert "Rule-based evaluation continued" in result["fallback_reason"];
    assert elapsed < 1.0;
}


test "T23 rejects malformed profile containers and contradictory academic facts" {
    rejects(None as dict);
    rejects([] as dict);
    rejects([{}] as dict);
    rejects({"al_subjects": [{"name": "   ", "grade": "A"}]});
    rejects({"al_subjects": [{"name": "Physics", "grade": "A"}, {"name": " physics ", "grade": "B"}]});
    rejects({"ol_maths_grade": "F", "has_maths_credit": True});
    rejects({"ol_maths_grade": "C", "has_maths_credit": False});
    raw = {"enable_ai": False, "ol_maths_grade": "C", "has_maths_credit": True,
        "al_subjects": [{"name": " Physics ", "grade": "S"}]};
    snapshot = json.dumps(raw, sort_keys=True);
    accepted = _validate_profile(raw);
    assert json.dumps(raw, sort_keys=True) == snapshot;
    assert accepted["has_maths_credit"];
    assert accepted["al_subjects"][0]["name"] == "Physics";
}




test "T24 accountant goal ranks related business programmes first" {
    result = _planning_session(profile({"catalogue_mode": "real", "domain_id": "business", "career_goal": "I want to become an accountant", "al_stream": "commerce"}));
    routes = result["candidates"] as list[dict];
    assert routes;
    assert (routes[0]["goal_alignment"] as dict)["status"] == "related_subject_terms";
    assert (routes[0]["step_ids"] as list)[-1] in ["LK-BUSINESS-10", "LK-BUSINESS-26"];
    assert "accountant" in (routes[0]["goal_alignment"] as dict)["matched_terms"];
}

test "T25 unmatched doctor goal never fabricates a business qualification" {
    catalogue = _load_catalogue("real");
    original = json.dumps(catalogue.data, sort_keys=True);
    result = _planning_session(profile({"catalogue_mode": "real", "domain_id": "business", "career_goal": "Become a doctor"}));
    assert result["candidates"];
    for route in (result["candidates"] as list[dict]) {
        assert (route["goal_alignment"] as dict)["status"] == "not_established";
        assert (route["goal_alignment"] as dict)["matched_terms"] == [];
        for step_id in (route["step_ids"] as list[str]) { assert step_id in ["LK-BUSINESS-09", "LK-BUSINESS-10", "LK-BUSINESS-26"]; }
    }
    assert json.dumps(catalogue.data, sort_keys=True) == original;
}

test "T26 study fit ranks confirmed mode above unknown without bypassing cash gate" {
    known = stage("KNOWN-MODE"); known["delivery_mode"] = "part_time";
    unknown = stage("UNKNOWN-MODE"); unknown["delivery_mode"] = "unknown";
    unaffordable = stage("UNAFFORDABLE"); unaffordable["delivery_mode"] = "part_time";
    unaffordable["upfront_cost_lkr"] = 24000;
    p = profile({"study_mode": "part_time", "preference": "study_fit"});
    known_route = _candidate([known], [], p);
    unknown_route = _candidate([unknown], [], p);
    blocked_route = _candidate([unaffordable], [], p);
    assert known_route["study_fit_score"] == 1 and unknown_route["study_fit_score"] == 0;
    ranked = _sort_candidates([blocked_route, unknown_route, known_route], "study_fit");
    assert ranked[0]["step_ids"] == ["KNOWN-MODE"];
    assert ranked[1]["step_ids"] == ["UNKNOWN-MODE"];
    assert ranked[2]["step_ids"] == ["UNAFFORDABLE"];
    assert ranked[2]["route_status"] == "not_feasible_under_current_inputs";
}

test "T27 model ordering cannot undo the selected lowest cost preference" {
    cheap = stage("CHEAP");
    expensive = stage("EXPENSIVE"); expensive["upfront_cost_lkr"] = 3000;
    graph = isolated_graph([cheap, expensive], []);
    p = profile({"savings_lkr": 100000, "preference": "lowest_cost"});
    cheap_id = _candidate([cheap], [], p)["route_id"];
    expensive_id = _candidate([expensive], [], p)["route_id"];
    with patch("services.planner._load_catalogue", return_value=graph) as mocked {
        assert getattr(_planning_session, "__globals__")["_load_catalogue"] is mocked;
        result = _planning_session(p, [{"action": "search_alternatives"}, {"action": "evaluate_candidates"},
            {"action": "finish", "route_ids": [expensive_id, cheap_id]}]);
    }
    assert result["planner_mode"] == "test_stub";
    assert [r["route_id"] for r in (result["candidates"] as list[dict])] == [cheap_id, expensive_id];
}

test "T28 valid model ordering may break an actual preference tie" {
    graph = isolated_graph([stage("TIE-A"), stage("TIE-B")], []);
    p = profile({"savings_lkr": 100000});
    search = graph spawn BranchSearchWalker(profile=p);
    baseline = [c["route_id"] for c in _sort_candidates(search.candidates, "lowest_cost")];
    desired = list(reversed(baseline));
    with patch("services.planner._load_catalogue", return_value=graph) as mocked {
        assert getattr(_planning_session, "__globals__")["_load_catalogue"] is mocked;
        result = _planning_session(p, [{"action": "search_alternatives"}, {"action": "evaluate_candidates"},
            {"action": "finish", "route_ids": desired}]);
    }
    actual = [r["route_id"] for r in (result["candidates"] as list[dict])];
    assert actual == desired and actual != baseline;
}


test "T29 public error sanitization removes details without sending a second response" {
    payload = {"error": "PRIVATE INTERNAL DETAIL", "traceback": "PRIVATE STACK",
        "data": {"error": "PRIVATE NESTED DETAIL", "traceback": "PRIVATE NESTED STACK"}};
    handler = Mock();
    outcome = _UniPathPageCompatibility.send_json(handler, 500, payload);
    assert outcome is None;
    assert handler.mock_calls == [], "sanitizer must leave response sending to the core hook";
    assert str(payload["error"]).startswith("Request rejected");
    assert str((payload["data"] as dict)["error"]).startswith("Request rejected");
    assert "traceback" not in payload and "traceback" not in (payload["data"] as dict);
    assert "PRIVATE" not in json.dumps(payload);
}

test "T30 successful report and success envelope are not altered by sanitizer" {
    successes: list[dict] = [
        {"reports": [{"status": "ready", "message": "Valid result"}]},
        {"ok": True, "type": "response", "data": {"reports": [{"status": "ready"}]}, "error": None}
    ];
    for payload in successes {
        snapshot = copy.deepcopy(payload);
        handler = Mock();
        outcome = _UniPathPageCompatibility.send_json(handler, 200, payload);
        assert outcome is None and handler.mock_calls == [];
        assert payload == snapshot, "successful response must remain unchanged";
    }
}

test "T31 malformed provider object falls back without inventing facts" {
    invalid = {"action": "finish", "route_ids": ["INVENTED-ROUTE"], "total_cost_lkr": 1,
        "explanation": "UNTRUSTED MALFORMED FACT"};
    with patch("services.planner._safe_model_call", return_value=invalid) as mocked {
        assert getattr(_planning_session, "__globals__")["_safe_model_call"] is mocked;
        with (patch.dict(os.environ, {"GOOGLE_API_KEY": "test-only", "GEMINI_API_KEY": ""}, clear=False) as AbstractContextManager[object]) {
            started = time.monotonic();
            result = _planning_session(profile({"enable_ai": True}));
            elapsed = time.monotonic() - started;
        }
        assert mocked.call_count == 1;
    }
    assert result["planner_mode"] == "rules_fallback";
    assert "invalid decision structure" in result["fallback_reason"];
    actions = [event["action"] for event in (result["decision_events"] as list[dict])];
    assert "search_alternatives" in actions and "evaluate_candidates" in actions and len(actions) <= 4;
    bridge = [r for r in (result["candidates"] as list[dict]) if r["step_ids"] == ["DEMO-FOUNDATION", "DEMO-DIPLOMA", "DEMO-TOPUP"]][0];
    assert (bridge["cashflow"] as dict)["total_cost_lkr"] == 54000;
    assert "INVENTED-ROUTE" not in json.dumps(result) and "UNTRUSTED MALFORMED FACT" not in json.dumps(result);
    assert elapsed < 1.0;
}


test "T32 canonical handler factory sanitizes then delegates exactly once" {
    original_send = Mock();
    fake_base = `type("FixtureResponseHandler", (), {"_send_response": original_send});
    shell = object.__new__(_UniPathAPIServer) as _UniPathAPIServer;
    with patch("jaclang.runtimelib.server.JacAPIServer.create_handler", return_value=fake_base) as factory {
        handler_class = shell.create_handler();
        assert factory.call_count == 1;
    }
    handler = handler_class();
    response = Mock(data={"error": "PRIVATE CANONICAL ERROR", "traceback": "PRIVATE STACK"}, body=None);
    send = getattr(handler_class, "_send_response");
    send(handler, response);
    original_send.assert_called_once_with(handler, response);
    assert "traceback" not in (response.data as dict);
    assert "PRIVATE" not in json.dumps(response.data);
    original_send.reset_mock();
    good_data = {"reports": [{"status": "ready", "value": 54000}]};
    success = Mock(data=copy.deepcopy(good_data), body=None);
    send(handler, success);
    original_send.assert_called_once_with(handler, success);
    assert success.data == good_data;
}



glob _context_probe: ContextVar[str] = ContextVar("unipath-test-context", default="unset");

def _context_decision(observation: str) -> PlannerDecision {
    assert observation == "context-probe";
    assert _context_probe.get() == "caller-value", "worker lost the caller context";
    return PlannerDecision(action="search_alternatives");
}

test "T33 provider thread preserves caller context and releases its slot" {
    slots = threading.BoundedSemaphore(1);
    with patch("services.planner._choose_action", side_effect=_context_decision) as mocked {
        assert getattr(_safe_model_call, "__globals__")["_choose_action"] is mocked;
        with patch("services.planner._slots", slots) {
            with patch("services.planner._call_times", []) {
                token = _context_probe.set("caller-value");
                try { decision = _safe_model_call("context-probe", 2.0); }
                finally { _context_probe.reset(token); }
                assert isinstance(decision, PlannerDecision) and decision.action == "search_alternatives";
                assert mocked.call_count == 1;
                assert slots.acquire(timeout=1.0), "completed provider work did not release its slot";
                slots.release();
            }
        }
    }
    assert _context_probe.get() == "unset";
}

test "T34 actual SDK parameters retain typed request and enforce timeout without retries" {
    messages = [{"role": "user", "content": "offline parameter probe"}];
    schema = {"type": "json_schema", "json_schema": {"name": "FixtureDecision", "schema": {"type": "object", "properties": {"action": {"type": "string"}}}}};
    runtime = MTRuntime(messages=[], resp_type=PlannerDecision, stream=False, tools=[], call_params={"parallelize": False});
    config = {"temperature": 0.1, "max_tokens": 600, "timeout": 99.0, "num_retries": 7};
    base = Model(model_name="gemini/offline-fixture", api_key="test-only", call_params=copy.deepcopy(config));
    bounded = BoundedGeminiModel(model_name="gemini/offline-fixture", api_key="test-only", call_params=copy.deepcopy(config));
    with patch.object(MTRuntime, "get_msg_list", return_value=messages) as message_reader {
        with patch.object(MTRuntime, "get_tool_list", return_value=[]) {
            with patch.object(MTRuntime, "get_output_schema", return_value=schema) {
                # Both real parameter builders execute; no invoke/dispatch/inference is called.
                original = base.make_model_params(runtime);
                actual = bounded.make_model_params(runtime);
            }
        }
        assert message_reader.call_count == 2;
    }
    assert "timeout" not in original and "num_retries" not in original, "pinned byLLM silently drops nonstreaming call options";
    assert actual["timeout"] == 8.0 and actual["num_retries"] == 0;
    assert actual["model"] == "gemini/offline-fixture";
    assert actual["messages"] == [{"role": "user", "content": "offline parameter probe\n\nSchema requirements:\n- action (string)"}];
    assert actual["response_format"] == schema, json.dumps(actual["response_format"]);
    assert actual["temperature"] == 0.1 and actual["max_tokens"] == 600;
    assert {key: value for (key, value) in actual.items() if key not in ["timeout", "num_retries"]} == original;
}

test "T35 rejected typed provider proposal is honestly labelled fallback" {
    invalid = PlannerDecision(action="search_alternatives", route_ids=["INVENTED-ROUTE"]);
    with patch("services.planner._safe_model_call", return_value=invalid) as mocked {
        assert getattr(_planning_session, "__globals__")["_safe_model_call"] is mocked;
        with (patch.dict(os.environ, {"GOOGLE_API_KEY": "test-only", "GEMINI_API_KEY": ""}, clear=False) as AbstractContextManager[object]) {
            result = _planning_session(profile({"enable_ai": True}));
        }
        assert mocked.call_count == 1;
    }
    assert result["planner_mode"] == "rules_fallback";
    assert "proposal was rejected" in result["fallback_reason"];
    actions = [event["action"] for event in (result["decision_events"] as list[dict])];
    assert "search_alternatives" in actions and "evaluate_candidates" in actions;
    assert "INVENTED-ROUTE" not in json.dumps(result);
}