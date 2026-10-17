# Current verification record

2026-10-17, Asia/Colombo. Authoritative local project uses Python 3.12, Jac 0.16.7 and byLLM 0.6.19.

| Scope | Observed result |
| --- | --- |
| Authored-module checker | 18/18 passed, 40.31s; final chat-icon App check also passed, 6.02s. |
| Native regression suite | 54/54 passed, 0.917s. Overlapping council cases were consolidated from 71; distinct boundaries retained. |
| Explicit HTTP helper | Ten groups passed against authoritative port 8000 after guide-classification fix. |
| Native client | Local build passed. |
| Real Gemini guide | live_ai, three allowlisted programme IDs/three official sources, 2.05s. A single observation, not an SLA. |
| Owner manual UI | Retake tab and study-guide panel open. |
| Agent browser review | Blocked by Work browser setting; current mobile/keyboard/focus/clock/comparison interaction checks not verified. |
| Hosted Linux CI | Current source 92b9d31 passed [run 39018179217](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39018179217): clean dependency install, authored-module checker, native suite and clean-server HTTP regression. |
| Hosting/submission | Deferred / not performed. |

Native coverage includes all-field matching, direct/multistage routes, transition prerequisites, unknown costs, cycle/search caps, request isolation, cash-flow fixtures (84,000/22,000 and 54,000/0), stress unknowns, planner action effects and failure modes, typed guide decisions, invented IDs, privacy context, retake validation/immutability, partial grades and nested-input rejection.

HTTP groups: H01 health/info/unique qualification IDs; H02 cash flow/full profile; H03 domains/goals; H04 stress/unknowns; H05 invalid inputs; H06 evidence; H07 tampering/error redaction; H08 retake; H09 guide/history/partial grades; H10 account denial/static traversal/body cap/security headers.

Reproduce in the pinned environment: `jac test -d tests -v`, then start the server and explicitly run `jac run tests/http_regression.jac`. HTTP helpers deliberately discover zero automatic tests; the named entry point is required. Run `jac run scripts/audit_source.jac` for source proportions. Do not infer national admissions, complete browser coverage or a security certification from these checks.


## Public-image regression increment

Owner screenshots showed a broken PNG despite a valid asset path. Direct GET reproduced 500: Jac 0.16.7's binary-static hook is unimplemented. Project-local allowlisted binary serving fixes this without changing installed packages. H11 verifies all five owner PNGs through actual HTTP: 200, image/png, correct Content-Length, PNG signature and byte-for-byte equality with source assets; nonexistent image 404. Existing H10 traversal/account/body/header checks still pass.

After this increment: five changed Jac modules check; 54 native cases pass in 0.318s; **11 HTTP groups pass** against the rebuilt authoritative server. Previous 10-group and hosted runs above refer to the preceding release. Updated hosted verification is tracked in tasks/memory. Current agent browser review remains blocked; successful HTTP delivery is not a visual-layout claim.

Image-fix source `2248e2ac21e457cdf64a20d9d2316fc22a8df0a4` passed [Linux CI run 39019439501](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39019439501): clean install, all authored Jac checks, native tests and eleven actual HTTP groups. Local app remains on port 8000; current post-fix visual browser review remains unverified.


## Agentic-depth increment (branch `agentic-depth`, 2026-10-17)

Local Windows run in a fresh project `.venv` (Python 3.12.14, Jac 0.16.7, byLLM 0.6.19), provider keys blank:

| Scope | Observed result |
| --- | --- |
| Authored-module checker | 18/18 `jac check --nowarn` passed. |
| Native regression suite | 64/64 passed (54 prior unchanged in assertions + T55–T64). The shared guide helper now also binds the new review boundary so no case reaches a provider. |
| HTTP regression | 12 groups passed against a clean `--no_client` server on port 8010 (H12: intents, impact question, signed plan-state resume, forgery and type rejection, guide evidence steps). |
| Native client | `jac start` installed dependencies and built the client bundle on port 8011. |
| Agent browser check | Built-in browser: impact-ranked question shown; answering resumed the plan at turn 2 with the next-highest-impact question; intent labels rendered; guide showed server-rendered "What to check first" items. Desktop width only; mobile/keyboard not rechecked. |
| Live Gemini | Not exercised (no key in this environment). Live multi-step behaviour is covered only by mocked-provider cases T61/T63. |

New cases: T55 scripted deep loop and verified self-check; T56 invented targets, wrong intents, cost-unknown stress, false critique reasons, same-field and unknown variants rejected; T57 preconditions; T58 what-ifs isolated and capped; T59 impact ranking; T60 signed state resume, three-question cap, tampering/domain/expiry rejection, no finances in token; T61 mocked live loop observes tool results and never receives savings/budget/district; T62 action budget termination; T63 live evidence review renders catalogue claim text; T64 invalid/failed review falls back to evidence-ranked rules.
