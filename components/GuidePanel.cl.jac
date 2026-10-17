sv import from ..services.api { ask_guide }

def:pub GuidePanel(profile: dict, profileRevision: int, isOpen: bool, onClose: Callable[[], None]) -> JsxElement {
    has draft: str = "";
    has allow_ai: bool = False;
    has messages: list[dict] = [];
    has response: dict = {};
    has response_revision: int = -1;
    has loading: bool = False;
    has error: str = "";
    has panel: Ref[any] = Ref();
    has request: Ref[int] = Ref(0);
    has latest_profile: Ref[int] = Ref(profileRevision);
    latest_profile.current = profileRevision;

    can with [isOpen] entry {
        if panel.current {
            if isOpen and not panel.current.open { panel.current.showModal(); }
            elif not isOpen and panel.current.open { panel.current.close(); }
        }
    }
    can with [profileRevision] entry {
        request.current = request.current + 1;
        loading = False;
    }
    def close(e: MouseEvent) -> None { onClose(); }
    def cancel(e: Event) -> None { e.preventDefault(); onClose(); }
    def change_draft(e: ChangeEvent) -> None {
        draft = e.target.value;
        request.current = request.current + 1;
        loading = False;
        error = "";
    }
    def change_consent(e: ChangeEvent) -> None {
        allow_ai = e.target.checked;
        request.current = request.current + 1;
        loading = False;
    }
    async def send(e: FormEvent) -> None {
        e.preventDefault();
        if loading { return; }
        message = draft.strip();
        if not message or len(message) > 800 { error = "Write a question of 1–800 characters."; return; }
        request.current = request.current + 1;
        ticket = request.current;
        submitted_revision = profileRevision;
        history = [{"role": item["role"], "content": str(item["content"])[:600]} for item in messages[-4:]];
        loading = True;
        error = "";
        try {
            result = root spawn ask_guide(profile=profile, message=message, history=history, allow_ai=allow_ai);
            if ticket != request.current or submitted_revision != latest_profile.current { return; }
            if not result.reports or len(result.reports) == 0 { error = "No answer was received. Your question is kept here; try again."; }
            elif result.reports[0].get("status") != "ready" { error = str(result.reports[0].get("message", "Check your profile and question, then try again.")); }
            else {
                answer = result.reports[0] as dict;
                response = answer;
                response_revision = profileRevision;
                messages = messages[-10:] + [{"role": "user", "content": message}, {"role": "assistant", "content": answer.get("answer", "")}];
                draft = "";
            }
        } except Exception {
            if ticket == request.current and submitted_revision == latest_profile.current { error = "We could not reach the study guide. Your question has been kept. Try again."; }
        } finally { if ticket == request.current { loading = False; } }
    }
    return <dialog id="guide-dialog" ref={panel} className="guide-panel" onCancel={cancel} aria-labelledby="guide-title"><header className="guide-heading"><div><p className="eyebrow">Gemini · optional assistance</p><h2 id="guide-title">Your study guide</h2></div><button type="button" className="quiet-button" onClick={close} aria-label="Close study guide">Close ×</button></header><p className="guide-intro">Ask about programmes, entry information or your next step. Answers use the catalogue and linked institutional sources.</p>
    {if bool(response) and response_revision != profileRevision { <p className="notice">Your profile has changed. Ask again for guidance matched to your current field.</p> }}
    <section className="guide-conversation" aria-label="Conversation in this session" aria-live="polite">{if len(messages) == 0 { <div className="guide-empty"><h3>Start with a question.</h3><p>For example: “What should I check before choosing an accounting programme?”</p><small>No account or saved conversation. If you enable Gemini, your question is also processed by the provider.</small></div> }}{for (index, item) in enumerate(messages) { <article key={str(index)} className={"guide-message user-message" if item["role"] == "user" else "guide-message assistant-message"}><strong>{"You" if item["role"] == "user" else "Study guide"}</strong><p>{item["content"]}</p></article> }}{if loading { <p className="guide-loading" role="status">Checking your question against the programme catalogue…</p> }}</section>
    {if bool(response) { <section className="guide-references"><div className="row spread"><span className="status">{"Gemini assisted" if response.get("mode") == "live_ai" else "Curated guidance"}</span><small>Confirm details with the institution.</small></div>{if response.get("fallback_reason") and allow_ai { <p className="field-note">{response["fallback_reason"]}</p> }}{if len(response.get("tips", []) as list) > 0 { <ul>{for tip in (response.get("tips", []) as list[str]) { <li key={tip}>{tip}</li> }}</ul> }}{if response.get("follow_up") { <p className="guide-follow-up">{response["follow_up"]}</p> }}<details><summary>Programme references & sources</summary><ul>{for programme in (response.get("programmes", []) as list[dict]) { <li key={programme["id"]}><strong>{programme["title"]}</strong><p>{programme["institution"]}</p><small>{"Duration: " + ("Not confirmed" if programme.get("duration_months", None) is None else str(programme["duration_months"]) + " months") + " · Fees: " + str(programme.get("fees_status", "not confirmed")).replace("_", " ")}</small></li> }}</ul><ul className="guide-source-list">{for source in (response.get("sources", []) as list[dict]) { <li key={source["id"]}><a href={source["url"]} target="_blank" rel="noopener noreferrer">{source["title"]} ↗</a></li> }}</ul></details></section> }}
    <form onSubmit={send} className="guide-form"><div className="field"><label htmlFor="guide-question">Your question</label><textarea id="guide-question" value={draft} onChange={change_draft} maxLength={800} rows={3} aria-describedby="guide-question-hint" /><small id="guide-question-hint">{str(len(draft)) + "/800 characters. Recent user questions provide context."}</small></div><label className="check-row"><input type="checkbox" checked={allow_ai} onChange={change_consent} /><span>Use Gemini for this question<small>Your question, recent user questions and selected field are sent to Gemini when enabled. Profile grades and budget are not automatically sent. Avoid private identifiers.</small></span></label>{if error { <p className="error" role="alert">{error}</p> }}<button type="submit" className="primary-button" disabled={loading or not draft.strip()}>{"Checking…" if loading else "Ask the study guide"}<span aria-hidden="true">→</span></button></form></dialog>;
}
