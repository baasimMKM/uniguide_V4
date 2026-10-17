# UniPath LK — current implementation memory

Updated 17 October 2026. Preserve the working implementation and its evidence boundaries.

## Runtime and entry

- Python 3.12; `jaclang==0.16.7`; `byllm==0.6.19`.
- Use the project-local `.venv\Scripts\jac.exe` rather than an unrelated global installation.
- On Windows set `$env:PYTHONIOENCODING = "utf-8"`, then start `.venv\Scripts\jac.exe start main.jac --port 8000`. The launcher already sets the encoding.
- `main.jac` imports six public API walkers and mounts the native Jac client. Primary files are `services/engine.jac`, `services/planner.jac`, `services/api.jac`, `components/App.cl.jac` and `styles/global.css`.
- Local settings allow only server-side Gemini keys and the model setting. Never expose credentials in browser payloads, source, tool output or recordings.

## Facts that can be stated

The real catalogue has 31 programmes, 12 fields and five institutions. It includes one evidenced OUSL English diploma → BA application edge. Source claims distinguish programme identity, admissions, complete fees, recognition, progression, duration, delivery and current intake. All real cash-flow cost fields remain null. An official programme page does not establish an open intake or professional registration.

Nursing, Special Needs Education, Drama and Theatre, and Zoology Honours have prior-qualification/study gates. MLS has a direct science A/L route including Chemistry; its professional diploma concerns exemptions. Psychology and Colombo MBBS provide additional direct post-A/L discovery records. Minimum rules never guarantee UGC or institutional selection.

`BranchSearchWalker` uses isolated branch state, actual Jac nodes/edges, cycle pruning, four-stage/100-state/20-candidate bounds and explicit truncation. Entry checks are three-valued. Unknown costs stay unknown. The model chooses bounded planning actions through typed byLLM output; it has no authority to invent facts or override deterministic results.

The named stress scenario adds 40% to the recorded travel component and six months to the first stage. Display absolute deltas and retain unknown values. No survival probability, inflation prediction, internship income or loan award is calculated.

## Goal discovery and runtime compatibility

Goal text is matched against editorial subject-exploration tags on the terminal programme in a route. Matching is case-insensitive, ignores punctuation and requires a complete normalised tag phrase in the supplied goal; it is not semantic career counselling. A match is labelled `related_subject_terms`; an unmatched goal is `not_established` and does not invent or remove routes. An empty goal is `not_supplied`. These search associations do not establish professional qualification, registration, admission or employment.

Deterministic ordering keeps route status first, then related subject terms, then the selected cost/duration/study preference. With `study_fit`, explicitly matching delivery-mode stages rank ahead of unknown modes; an unknown mode is not counted as a confirmed match. Field selection still defines the discovery scope, including general or unmatched goals. No goal term or study preference can override a failed prerequisite, cash-flow condition or evidence gate.

The project-local `services/compat.jac` hook is restricted to Jac 0.16.7. Its render hook calls the core renderer, repairs the React root ID, includes the extracted stylesheet and adds viewport metadata for this app. It registers through the runtime hook API rather than editing installed packages or generated bundles. Its JSON hook and project-local API-server handler factory replace framework error text with a generic rejection message and remove structured error tracebacks before normal serialization. The handler boundary also covers canonical TransportResponse objects that bypass send_json in this release; it delegates the response exactly once. Successful application reports are left intact. This is a narrow compatibility and error-envelope measure, not a claim that every possible log or exception channel has been audited.

## Provider transport boundary

The native Jac BoundedGeminiModel subclass uses byLLM 0.6.19’s public make_model_params extension point to set an eight-second SDK transport timeout and zero SDK retries. This is necessary because that release’s nonstreaming parameter construction does not forward timeout/num_retries from call_params. The outer future waits for min(10 seconds, remaining session budget), with a 15-second planning deadline; stream_num_retries and max_output_retries are zero. Installed packages and byLLM’s prompt/schema/response handling remain unchanged.

## Verification state

- The preserved-cache-quarantine baseline passed **35 native Jac tests and seven authoritative HTTP checks**. The subsequent planner type-narrowing fix passed the clean checker and all **35 native tests**. All seven authoritative HTTP checks also passed on the latest typing-fix revision (exit 0, `ci-final-http-authoritative.log`). The clean 12-file checker and exact CI-discovery run of 35 native tests passed locally; hosted CI is awaiting confirmation. Use `docs/test-matrix.md` for the latest confirmed result.
- The current local browser journey also showed genuine AI-assisted planning through search, evaluation and a relevant O/L English question, with no fallback label on that captured request. An earlier genuine Gemini smoke request took 4.89 seconds; that separate observation is not a response-time or quality guarantee.
- Core browser QA is complete for the tested local journeys: business/accounting discovery, mobile hospitality layout, dark theme and keyboard interaction, evidence links, the O/L English follow-up and F-grade re-evaluation, unknown-cost stress, fictional financial oracles, and network-error/retry handling. This is a scoped local check, not a claim of every browser, device or accessibility condition. Hosting is deferred by the user until local review; final event submission remains pending; measured language figures are recorded below with the counting-method qualification. The silent 2:30 captioned walkthrough is prepared from real captured app views, not continuous recording. The repository and presentation files are published on GitHub; event submission is pending. Six-slide PDF/PPTX pitch artifacts and their PDF-derived preview are prepared under docs/.
- The suite tests missing keys and injected provider failures/timeouts using mocks; it does not establish real network timing, limiter saturation, full accessibility or production robustness.

Reproduction:

```powershell
.venv\Scripts\jac.exe check tests/engine_tests.jac tests/http_regression.jac
.venv\Scripts\jac.exe test tests/engine_tests.jac -v
# Against a running local server:
.venv\Scripts\jac.exe run tests/http_regression.jac
```

## Demonstration oracle and language

Use professional English. Begin real discovery with a non-IT goal such as business/accounting. Explicitly switch to fictional demo fixtures for the financial calculation: savings 2,000/monthly budget 5,000; direct total 84,000/gap 22,000; three-stage total 54,000/gap zero/12 months with relocation true. Unknown relocation retains confirmation; relocation false blocks the relevant stage. These are test examples, never real tuition or transfer claims.

Older aspirational documents mentioned a nine-walker council, synthetic accredited bridges, IFSLS awards, guaranteed jobs and resilience percentages. Those are superseded concepts and must not be presented as implemented. Follow `tasks.md` for the remaining work; update evidence only after the corresponding check succeeds.

## Publication and source measurement snapshot — 17 October 2026

The [public repository](https://github.com/madukamalruk/unipathlk-v2) was published with initial commit [`d2f41e8`](https://github.com/madukamalruk/unipathlk-v2/commit/d2f41e823edb7f940b32d0d3de24ab5d6290fb46). This is the initial publication snapshot; a subsequent planner control-flow fix passed clean checking and 35 native tests, and all seven authoritative HTTP checks on the latest typing-fix revision. Hosting is deferred by the user until local review; final event submission remains pending.

The recorded source snapshot reports Jac **86.191% of nonwhitespace UTF-8 bytes** and **72.892% of nonblank lines** under `scripts/audit_source.jac`. The observed GitHub Languages display reports **Jac 88.3%, CSS 11.0%, Other 0.7%**. These use different denominators. The organiser’s counting method is unconfirmed, so these measurements do not establish unconditional compliance with the ≥80% requirement. Rerun the source audit after code changes.
