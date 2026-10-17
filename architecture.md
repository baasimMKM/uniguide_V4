# UniPath LK architecture

## Runtime and boundaries

One Jac 0.16.7 application on Python 3.12 with byLLM 0.6.19. The native Jac client compiles through the compiler's own frontend toolchain. No handwritten JavaScript recommendation engine, separate Python business service, FastAPI application or LangChain orchestration is introduced.

`main.jac` registers six public walkers and mounts the client. Server-only modules contain catalogue loading, graph/rules/cash-flow logic, model decisions and local settings. UI components import public walkers through Jac server stubs. Credentials stay in server configuration.

## Catalogue and graph

Two same-schema catalogues: real institutional research and visibly fictional verification examples. In-memory Catalogue and Offering nodes connect through typed ProgressesTo edges carrying source claims and transition requirements. Graphs are loaded once per process under a lock and are immutable through the public API. There is no public loader, catalogue-write endpoint or model catalogue mutation.

BranchSearchWalker performs bounded breadth-first exploration of actual graph neighbours: maximum four stages, 100 expanded states and 20 candidates. Each branch copies its path, transitions and accumulated qualifications. A blocked edge or target records an actual pruning/backtracking event. Repeated nodes terminate the branch. A truncated search is never described as exhaustive.

LensWalker instances visit offerings for Aspiration, Fiscal and Gatekeeper observations; a request's Bridge finding identifies catalogue progression participation. Findings and planning state live on request-owned walker objects, never shared course records. Initial node eligibility is distinct from eligibility after completing preceding route stages.

## Deterministic authority

Requirements support nested all/any and pass/fail/unknown. Whole-route evaluation includes transitions, future completion conditions, study preferences and independent evidence statuses. Known hard failure is ranked separately from uncertain or conditional options. AI cannot promote a hard failure into an eligible route.

Cash flow subtracts the upfront payment at each stage start and then applies monthly contributions and recurring expenses. Minimum balance determines extra initial savings needed. Unknown essential costs or duration make the ledger incomplete; null never means free. Known programme duration is separate from ledger completeness. Stress recomputes the same profile and catalogue routes under explicitly named changes.

## Bounded planner

Typed `PlannerDecision` is produced by a real Jac `by _llm` call. Observations contain allowed actions, progress, unknown fields, student-goal text and catalogue candidate summaries. Student text is untrusted data. Actions invoke graph search, evaluation, a supported clarification, or finish with optional validated route ordering.

At most four actions and a 15-second session deadline. The outer future waits for min(10 seconds, remaining deadline); the SDK adapter sets an eight-second transport timeout and zero SDK retries. Stream/output retry limits are zero. A two-worker pool and nonblocking slots bound concurrent model calls; a process-local 30-call/minute budget limits public AI spend. These controls assume one process/replica. Provider timeout, quota, missing key, malformed action or unknown ID triggers deterministic recovery. Labels: live_ai, rules_fallback or mixed; internal scripted tests use test_stub. Only operational decisions, not private chain-of-thought, are displayed.

## Public contract

All application operations use Jac's normal response envelope; read `data.reports` for raw HTTP consumers. The native client reads spawned walker's reports.

| Walker | Request | Report |
| --- | --- | --- |
| get_app_info | Empty | Domains, catalogue version, programme count, selectable qualifications |
| plan_pathways | profile dictionary | Validated route candidates, blocked candidates, question, graph projection, events and profile revision |
| run_stress_test | Same complete profile and scenario | Stable route IDs and absolute scenario deltas or explicit incomplete-cost result |
| get_catalogue_projection | catalogue_mode | Read-only offering and progression records |
| get_evidence | catalogue_mode, optional offering_id | Independently labelled programme and transition claims |
| health | Empty | Catalogue readiness and version/counts, without credentials |

Malformed business input returns `status=invalid_input`; transport/envelope failures must be handled separately. Client-computed eligibility or totals are never accepted. Unknown profile keys are rejected. Stable route IDs derive from catalogue mode and ordered offering IDs; revision prevents stale UI responses replacing current results.

## Publication and operations

The selected Downloads folder is the authoritative checkout. Original input and full development logs are backed up outside it. The local `.env`, `.venv`, `.jac`, generated client bundles, caches and reference materials are ignored by Git. Project-local .env contains allowlisted server settings and overrides process settings only for that local process; JacHammer uses server variables with no .env in source.

Local acceptance precedes JacHammer publication. Verify host compiler/model compatibility and anonymous source-to-result journey after deployment. A development server, passing fixture or polished screen alone does not establish long-term production readiness.


## Increment: editorial goal alignment and study fit

Goal text is matched against editorial subject-exploration tags on the terminal programme in a route. Matching is case-insensitive, ignores punctuation and requires a complete normalised tag phrase in the supplied goal; it is not semantic career counselling. A match is labelled `related_subject_terms`; an unmatched goal is `not_established` and does not invent or remove routes. An empty goal is `not_supplied`. These search associations do not establish professional qualification, registration, admission or employment.

Deterministic ordering keeps route status first, then related subject terms, then the selected cost/duration/study preference. With `study_fit`, explicitly matching delivery-mode stages rank ahead of unknown modes; an unknown mode is not counted as a confirmed match. Field selection still defines the discovery scope, including general or unmatched goals. No goal term or study preference can override a failed prerequisite, cash-flow condition or evidence gate.

The graph projection may carry the same editorial tags. The matched-terms marker is derived from catalogue data on the server; it is not an LLM-created equivalence or admission rule. A predecessor’s subject tags do not establish alignment for the terminal award.

## Increment: pinned-runtime render and error hooks

The project-local `services/compat.jac` hook is restricted to Jac 0.16.7. Its render hook calls the core renderer, repairs the React root ID, includes the extracted stylesheet and adds viewport metadata for this app. It registers through the runtime hook API rather than editing installed packages or generated bundles. Its JSON hook and project-local API-server handler factory replace framework error text with a generic rejection message and remove structured error tracebacks before normal serialization. The handler boundary also covers canonical TransportResponse objects that bypass send_json in this release; it delegates the response exactly once. Successful application reports are left intact. This is a narrow compatibility and error-envelope measure, not a claim that every possible log or exception channel has been audited.

Raw Windows startup uses:

```powershell
$env:PYTHONIOENCODING = "utf-8"
.venv\Scripts\jac.exe start main.jac --port 8000
```

The launcher sets the encoding already. Core browser QA is complete for the tested local journeys; hosting is deferred by the user until local review; check the final test matrix for the latest confirmed regression count.


## Increment: bounded nonstreaming provider transport and completed core browser QA

The native Jac BoundedGeminiModel subclass uses byLLM 0.6.19’s public make_model_params extension point to set an eight-second SDK transport timeout and zero SDK retries. This is necessary because that release’s nonstreaming parameter construction does not forward timeout/num_retries from call_params. The outer future waits for min(10 seconds, remaining session budget), with a 15-second planning deadline; stream_num_retries and max_output_retries are zero. Installed packages and byLLM’s prompt/schema/response handling remain unchanged.

The worker preserves the caller’s Jac/byLLM context and releases its slot after completion. Deadline return and transport settings are separate boundaries; no global latency SLA is asserted.

Core browser QA is complete for the tested local journeys: business/accounting discovery, mobile hospitality layout, dark theme and keyboard interaction, evidence links, the O/L English follow-up and F-grade re-evaluation, unknown-cost stress, fictional financial oracles, and network-error/retry handling. This is a scoped local check, not a claim of every browser, device or accessibility condition.

The current local browser journey also showed genuine AI-assisted planning through search, evaluation and a relevant O/L English question, with no fallback label on that captured request. An earlier genuine Gemini smoke request took 4.89 seconds; that separate observation is not a response-time or quality guarantee.

## Publication and source measurement snapshot — 17 October 2026

The [public repository](https://github.com/madukamalruk/unipathlk-v2) was published with initial commit [`d2f41e8`](https://github.com/madukamalruk/unipathlk-v2/commit/d2f41e823edb7f940b32d0d3de24ab5d6290fb46). This is the initial publication snapshot; a subsequent planner control-flow fix passed clean checking and 35 native tests, and all seven authoritative HTTP checks on the latest typing-fix revision. Hosting is deferred by the user until local review; final event submission remains pending.

The recorded source snapshot reports Jac **86.191% of nonwhitespace UTF-8 bytes** and **72.892% of nonblank lines** under `scripts/audit_source.jac`. The observed GitHub Languages display reports **Jac 88.3%, CSS 11.0%, Other 0.7%**. These use different denominators. The organiser’s counting method is unconfirmed, so these measurements do not establish unconditional compliance with the ≥80% requirement. Rerun the source audit after code changes.

The preserved-cache-quarantine baseline passed **35 native Jac tests and seven authoritative HTTP checks**. The subsequent planner type-narrowing fix passed the clean checker and all **35 native tests**. All seven authoritative HTTP checks also passed on the latest typing-fix revision (exit 0, `ci-final-http-authoritative.log`). The clean 12-file checker and exact CI-discovery run of 35 native tests passed locally; hosted CI is awaiting confirmation. Use `docs/test-matrix.md` for the latest confirmed result.
