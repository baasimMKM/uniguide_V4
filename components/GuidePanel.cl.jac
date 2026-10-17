sv import from ..services.api { ask_guide }

# One conversation thread. Every fact, check and link in an agent message is server-authored.
glob action_labels: dict = {
    "compare_pathways": "Check my pathways",
    "stress_test": "Test my budget",
    "retake_view": "Open the retake planner"
};
glob starter_prompts: list = [
    "Which courses fit my field?",
    "What should I check before choosing a course?",
    "What fees and costs should I ask about?",
    "Should I sit my A/Ls again?"
];

def group_checks(checks: list[dict]) -> list[dict] {
    groups: list[dict] = [];
    for check in checks {
        verified = str(check["status"]).startswith("Verified");
        found = [group for group in groups if group["check"] == check["check"]];
        if len(found) > 0 {
            found[0]["programmes"] = found[0]["programmes"] + [str(check["programme"])];
            if not verified { found[0]["verified"] = False; }
        } else {
            groups.append({"check": check["check"], "programmes": [str(check["programme"])], "verified": verified});
        }
    }
    return groups;
}

def:pub GuidePanel(profile: dict, profileRevision: int, isOpen: bool, onClose: Callable[[], None], onAction: Callable[[str], None]) -> JsxElement {
    has draft: str = "";
    has allow_ai: bool = False;
    has messages: list[dict] = [];
    has asked_revision: int = -1;
    has loading: bool = False;
    has error: str = "";
    has panel: Ref[any] = Ref();
    has thread: Ref[any] = Ref();
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
    can with [messages, loading] entry {
        if thread.current { thread.current.scrollTop = thread.current.scrollHeight; }
    }
    def close(e: MouseEvent) -> None { onClose(); }
    def cancel(e: Event) -> None { e.preventDefault(); onClose(); }
    def new_chat(e: MouseEvent) -> None {
        request.current = request.current + 1;
        messages = [];
        draft = "";
        error = "";
        loading = False;
    }
    def change_draft(e: ChangeEvent) -> None {
        draft = e.target.value;
        error = "";
    }
    def change_consent(e: ChangeEvent) -> None {
        allow_ai = e.target.checked;
        request.current = request.current + 1;
        loading = False;
    }
    def run_action(e: MouseEvent) -> None { onAction(str(e.currentTarget.dataset["action"])); }
    async def ask(message: str) -> None {
        if loading { return; }
        if not message or len(message) > 800 { error = "Write a question of 1–800 characters."; return; }
        request.current = request.current + 1;
        ticket = request.current;
        submitted_revision = profileRevision;
        history = [{"role": item["role"], "content": str(item["content"])[:600]} for item in messages[-4:]];
        conversation = messages[-10:] + [{"role": "user", "content": message, "data": {}}];
        messages = conversation;
        draft = "";
        loading = True;
        error = "";
        try {
            result = root spawn ask_guide(profile=profile, message=message, history=history, allow_ai=allow_ai);
            if ticket != request.current or submitted_revision != latest_profile.current { return; }
            if not result.reports or len(result.reports) == 0 { error = "No answer was received. Try again."; draft = message; messages = conversation[:-1]; }
            elif result.reports[0].get("status") != "ready" { error = str(result.reports[0].get("message", "Check your profile and question, then try again.")); draft = message; messages = conversation[:-1]; }
            else {
                answer = result.reports[0] as dict;
                asked_revision = profileRevision;
                messages = conversation + [{"role": "assistant", "content": answer.get("answer", ""), "data": answer}];
            }
        } except Exception {
            if ticket == request.current and submitted_revision == latest_profile.current { error = "We could not reach the assistant. Your question is back in the box. Try again."; draft = message; messages = conversation[:-1]; }
        } finally { if ticket == request.current { loading = False; } }
    }
    async def send(e: FormEvent) -> None {
        e.preventDefault();
        await ask(draft.strip());
    }
    async def ask_starter(e: MouseEvent) -> None { await ask(str(e.currentTarget.dataset["prompt"])); }
    async def key_down(e: KeyboardEvent) -> None {
        if e.key == "Enter" and not e.shiftKey {
            e.preventDefault();
            await ask(draft.strip());
        }
    }
    return <dialog id="guide-dialog" ref={panel} className="chat-panel" onCancel={cancel} aria-labelledby="guide-title">
        <header className="chat-header">
            <span className="chat-avatar" aria-hidden="true">AI</span>
            <div className="chat-title">
                <h2 id="guide-title">UniPath AI agent</h2>
                <small>{"Gemini on · facts from the catalogue" if allow_ai else "Catalogue answers · Gemini off"}</small>
            </div>
            {if len(messages) > 0 { <button type="button" className="chat-icon-button" onClick={new_chat}>New chat</button> }}
            <button type="button" className="chat-icon-button" onClick={close} aria-label="Close AI agent">×</button>
        </header>
        <section ref={thread} className="chat-thread" aria-label="Conversation" aria-live="polite">
            {if len(messages) == 0 {
                <div className="chat-welcome">
                    <h3>How can I help with your next step?</h3>
                    <p>I search the programme catalogue, read the evidence for each course and point you to what still needs confirming. I never decide admission.</p>
                    <div className="chat-starters">
                        {for prompt in starter_prompts { <button key={prompt} type="button" className="chat-chip" data-prompt={prompt} onClick={ask_starter}>{prompt}</button> }}
                    </div>
                </div>
            }}
            {if len(messages) > 0 and asked_revision != -1 and asked_revision != profileRevision {
                <p className="chat-divider">Your profile changed. New answers use the updated profile.</p>
            }}
            {for (index, item) in enumerate(messages) {
                if item["role"] == "user" {
                    <div key={str(index)} className="chat-row user"><p className="chat-bubble user">{item["content"]}</p></div>
                } else {
                    <article key={str(index)} className="chat-row agent">
                        <div className="chat-bubble agent">
                            <span className={"chat-badge live" if item["data"].get("mode") == "live_ai" else "chat-badge"}>{"Gemini assisted" if item["data"].get("mode") == "live_ai" else "From the catalogue"}</span>
                            <p>{item["content"]}</p>
                            {if len(item["data"].get("tips", []) as list) > 0 {
                                <ul className="chat-tips">{for tip in (item["data"].get("tips", []) as list[str]) { <li key={tip}>{tip}</li> }}</ul>
                            }}
                            {if len(item["data"].get("checks", []) as list) > 0 {
                                <div className="chat-checks">
                                    <h4>Check first</h4>
                                    <ul>{for group in group_checks(item["data"].get("checks", []) as list[dict]) {
                                        <li key={str(group["check"])}>
                                            <span className={"chat-dot ok" if group["verified"] else "chat-dot warn"} aria-hidden="true"></span>
                                            <span><strong>{group["check"]}</strong><small>{(str(group["programmes"][0]) if len(group["programmes"] as list) == 1 else str(len(group["programmes"] as list)) + " programmes") + " · " + ("verified" if group["verified"] else "confirm with the institution")}</small></span>
                                        </li>
                                    }}</ul>
                                </div>
                            }}
                            {if len(item["data"].get("sources", []) as list) > 0 or len(item["data"].get("programmes", []) as list) > 0 {
                                <details className="chat-sources">
                                    <summary>{"Details & sources (" + str(len(item["data"].get("sources", []) as list)) + ")"}</summary>
                                    <ul>
                                        {for programme in (item["data"].get("programmes", []) as list[dict]) {
                                            <li key={"p-" + str(programme["id"])}><strong>{programme["title"]}</strong><small>{str(programme["institution"]) + " · " + ("duration not confirmed" if programme.get("duration_months", None) is None else str(programme["duration_months"]) + " months") + " · " + str(programme.get("fees_status", "fees not confirmed"))}</small></li>
                                        }}
                                        {for (check_index, check) in enumerate(item["data"].get("checks", []) as list[dict]) {
                                            if check.get("note") { <li key={"n-" + str(check_index)}><small>{str(check["programme"]) + " · " + str(check["check"]) + ": " + str(check["note"])}</small></li> }
                                        }}
                                        {for source in (item["data"].get("sources", []) as list[dict]) {
                                            <li key={"s-" + str(source["id"])}><a href={source["url"]} target="_blank" rel="noopener noreferrer">{source["title"]} ↗</a></li>
                                        }}
                                    </ul>
                                </details>
                            }}
                            {if item["data"].get("next_step_code", "") in action_labels {
                                <button type="button" className="chat-action" data-action={item["data"]["next_step_code"]} onClick={run_action}>{action_labels[item["data"]["next_step_code"]]} <span aria-hidden="true">→</span></button>
                            } elif item["data"].get("next_step") {
                                <p className="chat-next">{item["data"]["next_step"]}</p>
                            }}
                        </div>
                        {if allow_ai and item["data"].get("mode") != "live_ai" and item["data"].get("fallback_reason") {
                            <small className="chat-footnote">{item["data"]["fallback_reason"]}</small>
                        }}
                    </article>
                }
            }}
            {if loading { <div className="chat-row agent"><p className="chat-bubble agent chat-typing" role="status"><span></span><span></span><span></span><em>Checking the catalogue…</em></p></div> }}
        </section>
        <form onSubmit={send} className="chat-composer">
            {if error { <p className="error" role="alert">{error}</p> }}
            <div className="chat-input">
                <label htmlFor="guide-question" className="visually-hidden">Message the AI agent</label>
                <textarea id="guide-question" value={draft} onChange={change_draft} onKeyDown={key_down} maxLength={800} rows={1} placeholder="Ask about courses, entry rules, costs or retakes…" />
                <button type="submit" className="chat-send" disabled={loading or not draft.strip()} aria-label="Send message">↑</button>
            </div>
            <label className="chat-consent">
                <input type="checkbox" checked={allow_ai} onChange={change_consent} />
                <span>Use Gemini AI. Your message and selected field are sent to Google; grades and budget are not. Avoid personal identifiers.</span>
            </label>
        </form>
    </dialog>;
}
