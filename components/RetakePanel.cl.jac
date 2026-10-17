sv import from ..services.api { evaluate_retake }

def retake_amount(value: any) -> str { return "Not confirmed" if value is None or str(value) == "undefined" else "LKR " + str(value); }

def:pub RetakeInput(name: str, label: str, value: any, onChange: Callable[[ChangeEvent], None], maximum: str = "100000000", minimum: str = "0") -> JsxElement {
    return <div className="field"><label htmlFor={"retake-" + name}>{label}</label><input id={"retake-" + name} name={name} value={value} onChange={onChange} type="number" min={minimum} max={maximum} step="1" /></div>;
}

def:pub RetakePanel(profile: dict, profileRevision: int) -> JsxElement {
    has inputs: dict = {"attempts_completed": "", "preparation_months": "", "monthly_cost_lkr": "", "one_off_cost_lkr": "", "monthly_income_forgone_lkr": "", "weekly_study_hours": "", "support_available": "unknown", "main_goal": "undecided"};
    has result: dict = {};
    has loading: bool = False;
    has stale: bool = False;
    has error: str = "";
    has request: Ref[int] = Ref(0);
    has latest_profile: Ref[int] = Ref(profileRevision);
    latest_profile.current = profileRevision;
    can with [profileRevision] entry {
        request.current = request.current + 1;
        loading = False;
        stale = bool(result);
    }
    def change(e: ChangeEvent) -> None {
        updated: dict = {**inputs};
        updated[e.target.name] = e.target.value;
        inputs = updated;
        request.current = request.current + 1;
        loading = False;
        stale = bool(result);
        error = "";
    }
    async def evaluate(e: FormEvent) -> None {
        e.preventDefault();
        if loading { return; }
        retake: dict = {"support_available": inputs["support_available"], "main_goal": inputs["main_goal"]};
        for key in ["attempts_completed", "preparation_months", "monthly_cost_lkr", "one_off_cost_lkr", "monthly_income_forgone_lkr", "weekly_study_hours"] {
            retake[key] = int(inputs[key]) if inputs[key] != "" else None;
        }
        request.current = request.current + 1;
        ticket = request.current;
        submitted_revision = profileRevision;
        loading = True;
        error = "";
        try {
            response = root spawn evaluate_retake(profile=profile, retake=retake);
            if ticket != request.current or submitted_revision != latest_profile.current { return; }
            if not response.reports or len(response.reports) == 0 { error = "No comparison was received. Your details are kept here; try again."; }
            elif response.reports[0].get("status") != "ready" { error = str(response.reports[0].get("message", "Check your profile and retake details, then try again.")); }
            else { result = response.reports[0] as dict; stale = False; }
        } except Exception {
            if ticket == request.current and submitted_revision == latest_profile.current { error = "We could not compare this scenario. Your details are kept here. Check your connection and try again."; }
        } finally { if ticket == request.current { loading = False; } }
    }
    estimates = result.get("estimates", {}) as dict;
    return <section className="retake-panel"><div className="retake-intro"><img className="retake-illustration" src="/static/pathway-steps.png" alt="" loading="lazy" width={180} height={132} /><h3>Would another A/L attempt make sense?</h3><p>Compare the preparation time, money and support you can commit. This scenario cannot predict your future grades or admission.</p></div><form onSubmit={evaluate}><fieldset><legend>Your retake scenario</legend><p className="field-note">Leave uncertain numbers blank. They remain unknown in the comparison.</p><div className="retake-input-grid"><RetakeInput name="attempts_completed" label="A/L attempts completed" value={inputs["attempts_completed"]} maximum="10" onChange={change} /><RetakeInput name="preparation_months" label="Preparation time (months)" value={inputs["preparation_months"]} minimum="1" maximum="36" onChange={change} /><RetakeInput name="weekly_study_hours" label="Study time (hours per week)" value={inputs["weekly_study_hours"]} maximum="100" onChange={change} /><RetakeInput name="monthly_cost_lkr" label="Preparation costs per month (LKR)" value={inputs["monthly_cost_lkr"]} onChange={change} /><RetakeInput name="one_off_cost_lkr" label="One-off preparation costs (LKR)" value={inputs["one_off_cost_lkr"]} onChange={change} /><RetakeInput name="monthly_income_forgone_lkr" label="Monthly income given up (LKR)" value={inputs["monthly_income_forgone_lkr"]} onChange={change} /><div className="field"><label htmlFor="retake-support">Do you have support for another attempt?</label><select id="retake-support" name="support_available" value={inputs["support_available"]} onChange={change}><option value="unknown">Not sure yet</option><option value="yes">Yes</option><option value="no">No</option></select></div><div className="field"><label htmlFor="retake-goal">Your main reason for retaking</label><select id="retake-goal" name="main_goal" value={inputs["main_goal"]} onChange={change}><option value="undecided">Still deciding</option><option value="state_university">State university entry</option><option value="any_higher_education">More higher education options</option></select></div></div></fieldset>{if error { <p className="error" role="alert">{error}</p> }}<button type="submit" className="secondary-button" disabled={loading}>{"Comparing your scenario…" if loading else "Compare this retake scenario"}</button></form>
    <div aria-live="polite" aria-busy={loading}>{if stale { <p className="notice">Your profile or scenario has changed. Compare again to use the latest details.</p> }}{if bool(result) { <section className="retake-result"><h3>{result.get("heading", "Your retake comparison")}</h3><p>{result.get("summary", "")}</p>{if result.get("readiness") { <p className="notice">{"More information needed" if result["readiness"] == "needs_information" else "Trade-offs to review"}</p> }}<dl className="route-facts"><div><dt>Preparation time</dt><dd>{"Not confirmed" if estimates.get("preparation_months", None) is None else str(estimates["preparation_months"]) + " months"}</dd></div><div><dt>Preparation cost</dt><dd>{retake_amount(estimates.get("total_cost_lkr", None))}</dd></div><div><dt>Extra initial savings needed</dt><dd>{retake_amount(estimates.get("initial_shortfall_lkr", None))}</dd></div><div><dt>Income forgone per month</dt><dd>{retake_amount(estimates.get("monthly_income_forgone_lkr", None))}</dd></div><div><dt>Total opportunity cost</dt><dd>{retake_amount(estimates.get("opportunity_cost_lkr", None))}</dd></div></dl><h4>Consider before deciding</h4><ul>{for item in (result.get("considerations", []) as list[str]) { <li key={item}>{item}</li> }}</ul><h4>Next steps</h4><ol>{for step in (result.get("next_steps", []) as list[str]) { <li key={step}>{step}</li> }}</ol><details><summary>Current study routes to compare</summary>{if len(result.get("current_routes", []) as list) == 0 { <p>No current routes were returned for this profile.</p> }}<ul>{for route in (result.get("current_routes", []) as list[dict]) { <li key={route["route_id"]}><strong>{route["title"]}</strong><p>{str(route.get("route_status", "needs_confirmation")).replace("_", " ")}</p><small>{("Duration not confirmed" if route.get("duration_months", None) is None else str(route["duration_months"]) + " months") + " · " + retake_amount(route.get("total_cost_lkr", None))}</small></li> }}</ul></details><details><summary>Policy notes & sources</summary><ul>{for note in (result.get("policy_notes", []) as list[str]) { <li key={note}>{note}</li> }}</ul><ul>{for source in (result.get("sources", []) as list[dict]) { <li key={source["id"]}><a href={source["url"]} target="_blank" rel="noopener noreferrer">{source["title"]} ↗</a><small>{source.get("scope", "")}</small></li> }}</ul></details></section> }}</div></section>;
}
