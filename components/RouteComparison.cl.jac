def comparison_amount(value: any) -> str {
    return "Not confirmed" if value is None or str(value) == "undefined" else "LKR " + str(value);
}
def comparison_has_source(value: any) -> bool {
    url = str(value);
    return url[:8] == "https://" or url[:7] == "http://";
}

def comparison_status(value: any) -> str {
    if value == "needs_confirmation" { return "Needs confirmation"; }
    if value == "conditional" { return "Conditional"; }
    if value == "not_feasible_under_current_inputs" { return "Does not fit current inputs"; }
    return "Fits stated assumptions";
}

def:pub RouteComparison(routes: list[dict]) -> JsxElement {
    return <section className="comparison-view"><h3>Compare your pathways</h3><p className="muted">The same server-checked routes, side by side. An unknown fee is not a free course.</p>
    {if len(routes) < 2 { <p className="notice">A comparison is available when at least two routes are returned. You can explore another field or update your profile.</p> } else {
        <div className="table-scroll" role="region" aria-label="Pathway comparison" tabIndex={0}><table className="comparison-table"><caption>Up to three routes in the planner's returned order</caption><thead><tr><th scope="col">Compare</th>{for (index, route) in enumerate(routes) { <th key={route["route_id"]} scope="col"><span>{"Pathway " + str(index + 1)}</span>{route["title"]}</th> }}</tr></thead><tbody>
        <tr><th scope="row">Current status</th>{for route in routes { <td key={route["route_id"]}><span className={"status " + str(route["route_status"])}>{comparison_status(route["route_status"])}</span></td> }}</tr>
        <tr><th scope="row">Institution</th>{for route in routes { <td key={route["route_id"]}>{for step in (route.get("steps", []) as list[dict]) { <p key={step["id"]}>{step["institution"]}</p> }}</td> }}</tr>
        <tr><th scope="row">Study stages</th>{for route in routes { <td key={route["route_id"]}>{len(route.get("steps", []) as list)}</td> }}</tr>
        <tr><th scope="row">Published duration</th>{for route in routes { <td key={route["route_id"]}>{"Not confirmed" if route.get("duration_months", None) is None else str(route["duration_months"]) + " months"}</td> }}</tr>
        <tr><th scope="row">Estimated total cost</th>{for route in routes { <td key={route["route_id"]}>{comparison_amount((route.get("cashflow", {}) as dict).get("total_cost_lkr", None))}</td> }}</tr>
        <tr><th scope="row">Initial savings gap</th>{for route in routes { <td key={route["route_id"]}>{comparison_amount((route.get("cashflow", {}) as dict).get("shortfall_lkr", None))}</td> }}</tr>
        <tr><th scope="row">What to check</th>{for route in routes { <td key={route["route_id"]}>{route.get("explanation", "Confirm entry, costs and progression with the institution.")}</td> }}</tr>
        <tr><th scope="row">Institution source</th>{for route in routes { <td key={route["route_id"]}>{for step in (route.get("steps", []) as list[dict]) { if comparison_has_source(step.get("source_url", "")) { <a key={step["id"]} href={step["source_url"]} target="_blank" rel="noopener noreferrer">{step["institution"]}<span aria-hidden="true"> ↗</span></a> } else { <span key={step["id"]}>Fictional fixture · no external source</span> } }}</td> }}</tr>
        </tbody></table></div><p className="field-note">Read the claim-by-claim sources in Pathways before deciding. A matching route does not guarantee admission or a career.</p>
    }}</section>;
}
