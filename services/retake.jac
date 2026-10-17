"""A decision aid for another A/L sitting, not a forecast or admission decision."""
import json;
import os;
import from .engine { _base_dir, _validate_profile, _cashflow }
import from .planner { _planning_session }

def _retake_sources() -> dict {
    with open(os.path.join(_base_dir, "data", "real", "retake_guidance.json"), "r", encoding="utf-8") as source {
        return json.load(source) as dict;
    }
}

def _validate_retake(raw: dict) -> dict {
    if type(raw) != dict { raise ValueError("Retake preferences must be an object."); }
    result: dict = {"attempts_completed": None, "preparation_months": None,
        "monthly_cost_lkr": None, "one_off_cost_lkr": None,
        "monthly_income_forgone_lkr": None, "weekly_study_hours": None,
        "support_available": "unknown", "main_goal": "undecided"};
    for key in raw {
        if key not in result { raise ValueError("Unsupported retake field."); }
        result[key] = raw[key];
    }
    for key in ["attempts_completed", "preparation_months", "monthly_cost_lkr", "one_off_cost_lkr", "monthly_income_forgone_lkr", "weekly_study_hours"] {
        value = result[key];
        maximum = 10 if key == "attempts_completed" else (36 if key == "preparation_months" else (100 if key == "weekly_study_hours" else 100000000));
        minimum = 1 if key == "preparation_months" else 0;
        if value is not None and (type(value) != int or value < minimum or value > maximum) {
            raise ValueError("Retake numbers must be whole numbers in the supported range, or left unknown.");
        }
    }
    if result["support_available"] not in ["yes", "no", "unknown"] { raise ValueError("Choose yes, no or unknown for study support."); }
    if result["main_goal"] not in ["state_university", "any_higher_education", "undecided"] { raise ValueError("Choose a supported retake goal."); }
    return result;
}

def _evaluate_retake(raw_profile: dict, raw_retake: dict) -> dict {
    profile = _validate_profile(raw_profile);
    retake = _validate_retake(raw_retake);
    guidance = _retake_sources();
    months = retake["preparation_months"];
    recurring = retake["monthly_cost_lkr"];
    upfront = retake["one_off_cost_lkr"];
    forgone = retake["monthly_income_forgone_lkr"];
    ledger = _cashflow([{"duration_months": months, "upfront_cost_lkr": upfront,
        "monthly_cost_lkr": recurring, "travel_monthly_lkr": 0}], profile);
    opportunity: int | None = None;
    if months is not None and forgone is not None { opportunity = int(months) * int(forgone); }
    considerations: list[str] = [];
    steps: list[str] = [];
    attempts = retake["attempts_completed"];
    if attempts is None {
        considerations.append("Check how many A/L occasions you have already sat before relying on an internal state-university route.");
    } elif int(attempts) >= 3 {
        considerations.append("You report at least three completed sittings. The cited UGC 2025/2026 handbook limits internal admission to three A/L occasions. Another sitting and UGC selection are different questions: confirm your exact position with UGC before registering or relying on earlier results.");
    } else {
        considerations.append("A further sitting is an option to investigate, not a promise of a better result or a university place. Confirm current Department of Examinations registration rules and the handbook for your intended admission year.");
    }
    if profile["al_passes"] is not None and int(profile["al_passes"]) < 3 {
        considerations.append("Improving A/L subject results may open routes with higher entry requirements. The next grades, subject combination and selection outcome remain unknown.");
    } elif profile["al_passes"] == 3 {
        considerations.append("Three subject passes alone do not establish state-university selection. Compare your actual subject combination and published selection rules with routes already open to you.");
    }
    if retake["main_goal"] == "state_university" {
        considerations.append("Do not estimate an admission probability from your Z-score. Use the correct academic-year rules, district/course information and official selection process.");
    }
    if retake["weekly_study_hours"] == 0 {
        considerations.append("No weekly preparation time is available in this estimate. Make a realistic study/work schedule before committing to another sitting.");
    } elif retake["weekly_study_hours"] is None {
        steps.append("Estimate the hours you can actually study each week after work, travel and home responsibilities.");
    }
    if retake["support_available"] != "yes" {
        steps.append("Discuss a workable plan with a trusted teacher or family member, including affordable study materials, transport, work and support.");
    }
    if not ledger["cost_complete"] {
        considerations.append("Preparation cost is incomplete. Unknown tuition, exam, materials or travel costs have not been treated as free. Include them in your own monthly and one-off estimates.");
    } elif int(ledger["shortfall_lkr"]) > 0 {
        considerations.append("The supplied preparation estimate exceeds the stated cash-flow resources. Adjust costs, study/work timing or support before committing.");
    }
    if forgone is None {
        considerations.append("Possible income forgone while preparing is unknown and is separate from course or tuition expenses.");
    }
    if profile["can_relocate"] is False {
        steps.append("Prioritise nearby, distance or part-time alternatives and confirm the actual campus and timetable.");
    }
    steps.extend(["Ask a teacher which specific subject gaps to address and how progress will be checked; do not rely on predicted grades.",
        "Compare another sitting with a current course or vocational option, including waiting time, travel, total costs and the qualification required for your goal.",
        "Verify the next examination application notice and dates on the official Department of Examinations site. No future sitting date is assumed here."]);
    rule_profile = {**profile, "enable_ai": False};
    current = _planning_session(rule_profile);
    routes = [{"route_id": route["route_id"], "title": route["title"], "route_status": route["route_status"],
        "duration_months": route.get("duration_months"), "total_cost_lkr": (route["cashflow"] as dict)["total_cost_lkr"]}
        for route in (current["candidates"] as list[dict])];
    return {"status": "ready", "profile_revision": profile["profile_revision"],
        "heading": "Another A/L sitting, or a route you can explore now?",
        "summary": "Compare the trade-offs with your teacher and family. These are your preparation estimates, not official fees, predicted grades or an admission decision.",
        "readiness": "needs_information" if attempts is None or not ledger["cost_complete"] else "tradeoffs_to_review",
        "estimates": {"preparation_months": months, "total_cost_lkr": ledger["total_cost_lkr"],
            "initial_shortfall_lkr": ledger["shortfall_lkr"], "monthly_income_forgone_lkr": forgone,
            "opportunity_cost_lkr": opportunity},
        "considerations": considerations, "next_steps": steps,
        "sources": guidance.get("sources", []), "policy_notes": guidance.get("policy_notes", []),
        "current_routes": routes, "catalogue_mode": profile["catalogue_mode"],
        "search_truncated": current["search_truncated"]};
}
