"""Run against an existing local server: jac run tests/http_regression.jac.
Offline AI in every request; no .env access, student files or server management.
Set UNIPATH_TEST_BASE_URL only when testing a different local server URL.
"""
import copy;
import json;
import os;
import sys;
import from urllib.request { Request, urlopen }
import from urllib.error { HTTPError }
import from http.client { HTTPResponse }

glob _base_url: str = os.environ.get("UNIPATH_TEST_BASE_URL", "http://127.0.0.1:8000").rstrip("/");
glob _scenario: str = "travel_plus_40_and_delay_6m";

def _profile(changes: dict | None = None) -> dict {
    p = {
        "catalogue_mode": "demo", "domain_id": "it", "career_goal": "Software engineer",
        "al_stream": "physical_science", "al_year": 2025,
        "al_subjects": [{"name": "Combined Mathematics", "grade": "C"},
            {"name": "Physics", "grade": "S"}, {"name": "Chemistry", "grade": "S"}],
        "al_passes": 3, "ol_maths_grade": "F", "ol_english_grade": "S", "z_score": 0.7,
        "savings_lkr": 2000, "monthly_budget_lkr": 5000, "home_district": "Galle",
        "study_mode": "any", "can_relocate": True, "existing_qualifications": [],
        "has_maths_credit": False, "preference": "lowest_cost", "profile_revision": 17,
        "enable_ai": False
    };
    if changes is not None { p.update(changes); }
    return p;
}

def _request(walker_name: str, payload: dict) -> dict {
    request = Request(_base_url + "/walker/" + walker_name,
        data=json.dumps(payload).encode(), headers={"Content-Type": "application/json"}, method="POST");
    with (urlopen(request, timeout=30) as HTTPResponse) as response {
        return json.load(response) as dict;
    }
}

def _post(walker_name: str, payload: dict) -> dict {
    body = _request(walker_name, payload);
    data = body.get("data", {}) as dict;
    reports = body.get("reports", data.get("reports")) as list[dict];
    assert isinstance(reports, list) and reports, "Expected nonempty Jac reports";
    return reports[0];
}

def _h01() {
    health = _post("health", {});
    assert health["ok"] and health["real_programmes"] >= 24;
    info = _post("get_app_info", {});
    assert len(info["domains"] as list) == 12 and info["jac_version"] == "0.16.7";
    demo_awards = [str(row["id"]) for row in (info["demo_qualifications"] as list[dict])];
    assert demo_awards and len(demo_awards) == len(set(demo_awards)), "qualification selector IDs must be unique";
}

def _h02() {
    p = _profile();
    before = copy.deepcopy(p);
    first = _post("plan_pathways", {"profile": p});
    assert first["status"] == "ready" and first["planner_mode"] == "rules_fallback";
    assert first["profile_revision"] == 17 and first["domain_id"] == "it" and first["catalogue_mode"] == "demo";
    bridge = [c for c in (first["candidates"] as list[dict]) if c["step_ids"] == ["DEMO-FOUNDATION", "DEMO-DIPLOMA", "DEMO-TOPUP"]][0];
    cash = bridge["cashflow"] as dict;
    assert bridge["route_status"] == "conditional" and cash["total_cost_lkr"] == 54000 and cash["shortfall_lkr"] == 0;
    direct = [c for c in (first["blocked_candidates"] as list[dict]) if c["step_ids"] == ["DEMO-DIRECT-DEG"]][0];
    assert (direct["cashflow"] as dict)["shortfall_lkr"] == 22000;
    unknown = _post("plan_pathways", {"profile": _profile({"can_relocate": None, "profile_revision": 18})});
    unknown_bridge = [c for c in (unknown["candidates"] as list[dict]) if c["route_id"] == bridge["route_id"]][0];
    assert unknown_bridge["route_status"] == "needs_confirmation" and unknown["profile_revision"] == 18;
    funded = _post("plan_pathways", {"profile": _profile({"savings_lkr": 24000, "profile_revision": 19})});
    funded_direct = [c for c in (funded["candidates"] as list[dict]) if c["route_id"] == direct["route_id"]][0];
    assert (funded_direct["cashflow"] as dict)["shortfall_lkr"] == 0;
    again = _post("plan_pathways", {"profile": p});
    assert [c["route_id"] for c in (first["candidates"] as list[dict])] == [c["route_id"] for c in (again["candidates"] as list[dict])];
    assert p == before;
}

def _h03() {
    domains = _post("get_app_info", {})["domains"] as list[dict];
    for domain in domains {
        result = _post("plan_pathways", {"profile": _profile({"catalogue_mode": "real", "domain_id": domain["id"],
            "career_goal": "Explore " + str(domain["label"]), "al_passes": None, "al_subjects": [],
            "al_stream": "unknown", "can_relocate": None, "has_maths_credit": None})});
        assert result["status"] == "ready" and result["domain_id"] == domain["id"];
        projection = result["graph_projection"] as dict;
        assert len(projection["nodes"] as list) >= 2;
        assert result["candidates"] or result["blocked_candidates"] or result["blocked_transitions"];
        for route in (result["candidates"] as list[dict]) {
            for step in (route["steps"] as list[dict]) { assert domain["id"] in step["domain_ids"]; }
        }
    }
}

def _goal_http_checks() {
    accounting = _post("plan_pathways", {"profile": _profile({"catalogue_mode": "real", "domain_id": "business", "career_goal": "Become an accountant", "al_stream": "commerce"})});
    top = (accounting["candidates"] as list[dict])[0];
    assert (top["goal_alignment"] as dict)["status"] == "related_subject_terms";
    assert (top["step_ids"] as list)[-1] in ["LK-BUSINESS-10", "LK-BUSINESS-26"];
    unmatched = _post("plan_pathways", {"profile": _profile({"catalogue_mode": "real", "domain_id": "business", "career_goal": "Become a doctor"})});
    assert unmatched["candidates"];
    for route in (unmatched["candidates"] as list[dict]) {
        assert (route["goal_alignment"] as dict)["status"] == "not_established";
        for step_id in (route["step_ids"] as list[str]) { assert step_id in ["LK-BUSINESS-09", "LK-BUSINESS-10", "LK-BUSINESS-26"]; }
    }
}
def _h04() {
    p = _profile({"savings_lkr": 24000});
    plan = _post("plan_pathways", {"profile": p});
    direct = [c for c in (plan["candidates"] as list[dict]) if c["step_ids"] == ["DEMO-DIRECT-DEG"]][0];
    stress = _post("run_stress_test", {"profile": p, "scenario": _scenario});
    assert stress["profile_revision"] == 17;
    delta = [d for d in (stress["deltas"] as list[dict]) if d["route_id"] == direct["route_id"]][0];
    assert delta["delta_total_cost_lkr"] == 40800 and delta["delta_duration_months"] == 6;
    assert _post("run_stress_test", {"profile": p, "scenario": "invented"})["status"] == "invalid_input";
    real = _post("run_stress_test", {"profile": _profile({"catalogue_mode": "real"}), "scenario": _scenario});
    assert real["status"] == "ready" and real["deltas"];
    for delta in (real["deltas"] as list[dict]) {
        if not delta["available"] { assert delta["delta_total_cost_lkr"] is None and delta["delta_duration_months"] is None; }
    }
}

def _h05() {
    invalid: list[dict] = [{"catalogue_mode": "invented"}, {"study_mode": "invented"}, {"domain_id": "invented"},
        {"traversal": "dfs"}, {"savings_lkr": -1}, {"savings_lkr": True}, {"monthly_budget_lkr": False},
        {"monthly_budget_lkr": 1.5}, {"al_passes": True}, {"ol_maths_grade": "D"}, {"candidates": []},
        {"route_status": "feasible"}, {"total_cost_lkr": 0}, {"existing_qualifications": ["INVENTED"]},
        {"al_passes": 2}, {"enable_ai": "false"},
        {"al_subjects": [{"name": "   ", "grade": "A"}]},
        {"al_subjects": [{"name": "Physics", "grade": "A"}, {"name": " physics ", "grade": "B"}]},
        {"ol_maths_grade": "F", "has_maths_credit": True}, {"ol_maths_grade": "C", "has_maths_credit": False}];
    for raw in [None, [], [{}], "not a profile"] {
        assert _post("plan_pathways", {"profile": raw})["status"] == "invalid_input";
    }
    for changes in invalid {
        result = _post("plan_pathways", {"profile": _profile(changes)});
        assert result["status"] == "invalid_input", "Invalid profile accepted";
    }
}

def _h06() {
    projection = _post("get_catalogue_projection", {"catalogue_mode": "real"});
    assert projection["status"] == "ready" and len(projection["offerings"] as list) >= 24;
    offering = (projection["offerings"] as list[dict])[0];
    evidence = _post("get_evidence", {"catalogue_mode": "real", "offering_id": offering["id"]});
    assert evidence["status"] == "ready" and evidence["claims"];
    actual = [c["id"] for c in (evidence["claims"] as list[dict])];
    assert all([c["id"] in actual for c in (offering["claims"] as list[dict])]);
    assert _post("get_catalogue_projection", {"catalogue_mode": "invented"})["status"] == "invalid_input";
}

def _h07() {
    cases: list[dict] = [
        {"walker": "_load_catalogue", "payload": {"mode": "real"}},
        {"walker": "plan_pathways", "payload": {"profile": _profile(), "candidates": []}},
        {"walker": "plan_pathways", "payload": {"profile": _profile(), "traversal": "dfs"}},
        {"walker": "run_stress_test", "payload": {"profile": _profile(), "scenario": _scenario, "baseline_total_cost_lkr": 0}}
    ];
    for row in cases {
        try {
            body = _request(str(row["walker"]), row["payload"] as dict);
        } except HTTPError as error {
            assert error.code in [400, 401, 403, 404, 422];
            public_error = (error.read() as bytes).decode("utf-8", errors="replace");
            assert "Traceback (most recent call last)" not in public_error;
            continue;
        }
        data = body.get("data", {}) as dict;
        reports = body.get("reports", data.get("reports", [])) as list[dict];
        assert not data.get("traceback") and not body.get("traceback");
        assert "Traceback (most recent call last)" not in json.dumps(body);
        rejected = bool(body.get("error") or data.get("error")) or (bool(reports) and reports[0].get("status") == "invalid_input");
        assert rejected, "Unexpected request fields must not produce accepted results";
    }
}

with entry:__main__ {
    group = "H01";
    try {
        _h01(); print("H01 health and app info PASS");
        group = "H02"; _h02(); print("H02 full profile, cash, relocation, stable IDs PASS");
        group = "H03"; _h03(); _goal_http_checks(); print("H03 all twelve fields and non-IT goals PASS");
        group = "H04"; _h04(); print("H04 stress oracle and unknown costs PASS");
        group = "H05"; _h05(); print("H05 invalid inputs rejected PASS");
        group = "H06"; _h06(); print("H06 projection and evidence PASS");
        group = "H07"; _h07(); print("H07 internal helper and outer tampering rejected PASS");
        print("7 HTTP regression groups passed. Every planning request disables AI.");
    } except Exception as error {
        print(group + " FAIL (" + str(`type(error).__name__) + ")");
        sys.exit(1);
    }
}
