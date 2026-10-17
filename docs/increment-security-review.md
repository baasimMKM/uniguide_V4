# Increment security and edge-case review

17 October 2026. Scope: the anonymous UniPath planner, proposed bounded catalogue
chat and A/L retake decision aid. This is a focused source/design review and test
plan, not a penetration test, production certification or legal assessment.
The existing 35 native cases and seven HTTP groups are baseline evidence only;
new increment checks remain unrun until its contracts and implementation exist.

The supplied `production_webapp_research_2026-10-17.md` informed this selection:
server validation, untrusted AI inputs, abuse limits, secrets, data minimization,
output encoding, failure recovery and reproducible release gates. Account,
payment, upload, tenancy and transactional-finance checklists are outside the
product's current scope. Framework account routes still require explicit closure.
No new framework, security-skill collection or package was installed. Runtime
observations refer to installed Jac 0.16.7/byLLM 0.6.19 source.

## Data flow and trust boundaries

Browser-supplied profiles/messages are untrusted. Jac validates them and computes
catalogue eligibility/cash flow. Gemini may explain or select only within a
server-built context; it cannot establish admission, recognition, future grades,
fees or retake outcomes. The browser renders plain text and server-owned source
links. Neither client state, chat history nor model output grants authority over
requirements or money. No account/payment identity is needed for this flow.

Profile results currently include no student persistence operation. Proposed
chat must remain request-scoped, use bounded in-memory history and disclose that
submitted chat content may reach Gemini when enabled. Avoid collecting names,
contacts, identity numbers, schools or documents. Logs should retain outcome,
latency and error class rather than grades, budgets, prompts or provider output.
The app cannot promise a provider retention policy without verified vendor facts.

## Prioritized findings and proposed checks

| Priority / status | Source observation or design risk | Required bounded check |
| --- | --- | --- |
| P1 / source-confirmed, integration unrun | Jac's default `/user/register` and `/user/login` routes exist despite the product having no accounts. Registration writes a user/root into `.jac/data/main.db`. | Project handler denies unused user routes before body parsing; a synthetic HTTP denial test must create no account or durable record. Do not modify the installed framework or implement a new authentication system. |
| P2 / source-confirmed | Pinned handler reads declared `Content-Length` without a limit before JSON validation. Subject rows also retain arbitrary extra nested keys. | Cap request bytes and body-read time before decode; reject unsupported content framing/types cleanly. Reject unknown nested keys or reconstruct only `name`/`grade`. A one-byte-over-limit fixture must be rejected without provider invocation. No slow-request load attack is authorized by this review. |
| P2 / source-confirmed | `al_passes` consistency is checked only when exactly three known grades are supplied. Partial known failures can contradict a claimed three passes. | Require the count to lie between known passes and the maximum still possible from unknown/unsupplied subjects. Cover one/two known failures, unknown grades, complete results and truly unknown counts before retake calculations. |
| P2 / design gate | An anonymous chat endpoint could multiply model calls or bypass planner limits. CORS is `*` in pinned transport; it is not a spending-control boundary. | Share one provider semaphore/rate budget across planner/chat; bound question/history/context/output, retry count and deadline. Missing/disabled key, busy, exhausted budget, malformed output and timeout must produce truthful bounded fallback. Per-client/shared ingress limits remain a deployment requirement. |
| P2 / design gate | Student text, supplied history and model prose can contain instructions, invented routes, links or fees. | Reject browser-supplied system roles/context/results; build catalogue context server-side. Injection fixtures request secret disclosure, invented IDs and impossible admission/cost changes. Returned IDs/source links must belong to the supplied context; canonical finance/requirements must remain unchanged. Model prose alone is never a verified fact. |
| P2 / design gate | Retake optimism could turn hypothetical future passes into established eligibility or hide opportunity cost. | Keep baseline and hypothetical profiles separate. Label the retake output a decision aid. Test zero passes, all passes, unknown grades, future/unknown dates, no matching route, unknown/zero costs, zero savings/surplus and infeasible living costs. Unknown values remain unknown; unavailable break-even is not zero. Never fabricate admission probability or salary. |
| P3 / design gate | HTML/link injection, stale requests and profile edits can make an answer misleading. | Render chat as text; use server-owned HTTPS evidence links. Test `<script>`/HTML as inert text, no model-created clickable URL, editing during a request, clearing history and out-of-order replies. An old response must not overwrite the current profile/revision. |
| P3 / verified baseline, new endpoints unrun | Canonical Jac errors previously exposed tracebacks and returned HTTP 200 envelopes. Existing project adapter sanitizes them. | Apply the same envelope checks to new endpoints and malformed bodies; require no traceback/provider detail, one response and preserved successful data. Test result semantics as well as transport status. |

Source locations: `services/engine.jac:_validate_profile`,
`services/planner.jac:_safe_model_call`, `services/compat.jac`; installed
`jaclang/runtimelib/impl/server.impl.jac` (user manager, body reader, user routes)
and `impl/transport.impl.jac` (CORS headers). Route/body observations are from
source; no live account creation, slow-request attack or provider call was run.

## Retake acceptance examples for the contract

- A hypothetical improved pass count may open a catalogue rule conditionally; it
  must not rewrite the baseline grades, create a qualification or promise entry.
- A/L retake spending includes only explicit supplied/known costs. Unknown tuition,
  exam fees, travel, duration or lost income cannot silently become zero.
- Compare available catalogue routes with and without retaking under the same
  budget. No route is a valid result. Cost/time trade-offs and unknowns remain
  visible; preference ordering cannot bypass eligibility or cash constraints.
- Grade/count contradictions reject before advice. Booleans, negatives, fractions,
  non-finite numbers, overlong lists/text, null and wrong containers must follow
  the agreed schema. Date-dependent calculations need an explicit reference date.
- Both evaluations preserve the original profile/catalogue, stable route IDs and
  the existing uncertainty/evidence labels. The aid is separate from admission.

## Evidence to collect before local review

After API contracts arrive: native Jac validation/immutability and failure tests;
HTTP schema/error/abuse-boundary checks with AI disabled; mocked provider
injection/timeout/output tests with the binding asserted before execution; UI
checks for plain-text output, disclosure and stale responses by the UI engineer.
Then preserve/quarantine stale IR caches, clean-check every authored Jac file,
run `jac test -d tests -v`, run the named-main HTTP helper, and refresh the truthful
source proportions and exact-secret scan. Hosted CI, browser and deployment
results must be reported separately. Rate/load saturation, encoded/history-wide
secret discovery and vendor retention remain unverified unless actually tested.

## Integrated acceptance update — 2026-10-17

Implemented and verified: 18 checked Jac modules, 54 consolidated native cases, ten actual HTTP groups and native client build. Concrete account/path/body/input/model-output boundaries pass; shared AI limits are process-local. Real guide call returned live_ai in 2.05s with three known programmes and official sources. Owner confirms retake/guide panels open. Independent current browser review remains blocked; mobile, keyboard, focus, Escape, clock ticks and comparison interactions are not certified. Hosting remains deferred. See tasks.md and docs/test-matrix.md for current evidence; earlier planning sections are historical.
