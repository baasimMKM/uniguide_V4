# Verification matrix

Executed on 17 October 2026 using the project-local Python 3.12 environment,
Jac 0.16.7 and byLLM 0.6.19. All valid HTTP planning profiles and ordinary native cases set `enable_ai=False`;
scripted planner choices report `test_stub`. Controlled provider-boundary cases temporarily
enable AI only after asserting that the provider helper is a bound mock.
Automated cases make no model inference requests, print no credentials, write no
student file and attach no fixture nodes to `root`. Earlier HTTP checks used a clean source copy without `.env`; final checks target the authoritative server on port 8000. Ordinary application imports can load local settings.

Native suite: **35 passed** (0.792 seconds), including SDK forwarding and truthful fallback labels. Native Jac HTTP suite: **7 groups passed**
against the final authoritative server on port 8000, including unique qualification-selector IDs and canonical-response
traceback suppression. An intentionally unreachable local URL returned exit 1;
the successful HTTP suite returned exit 0. The Jac checker passed both test files with
zero errors; loose JSON dictionary and inferred-value warnings remain. These are
behavioral regression results, not a statement of complete test coverage.

The final seven-group run returned exit 0 after preserving/quarantining the stale Jac IR cache and restarting from current source. Earlier runs also passed on the SDK server (port 8004) and the key-free clean-source server (port 8002).

| Tests | Scenario and observed assertion | Result |
| --- | --- | --- |
| T01, H01, H03 | Exactly 12 fields; each has at least two real catalogue programmes with HTTPS evidence; every field is discoverable through the public API; demo qualification-selector IDs are unique. Known unmet rules may produce blocked results. | Pass |
| T02, H03 | Law and other selected fields remain selected when the goal is outside computing; candidate stages belong to that field. | Pass |
| T03, H02 | Direct fixture: total LKR 84,000, minimum balance −22,000, initial shortfall 22,000 at savings 2,000/budget 5,000. Savings 24,000 removes the initial shortfall. | Pass |
| T04, H02 | Foundation → Diploma → Top-Up: total 54,000, minimum 0, shortfall 0, 12 months; unknown relocation needs confirmation; relocation true yields conditional. | Pass |
| T05, H04 | Named travel/delay scenario, direct route: cost increases 40,800; duration increases 6 months. Complete profile and revision sent again. | Pass |
| T06, H04 | Unknown fee schedules retain null totals/deltas and do not crash baseline or stress arithmetic. | Pass |
| T07 | Unknown requirements and institution confirmation remain unknown; explicit false relocation fails. | Pass |
| T08 | Actual incoming graph edge does not satisfy a missing AND maths prerequisite; false blocks and true admits the progression. | Pass |
| T09 | A qualification earned on a sibling branch does not leak into another branch. | Pass |
| T10 | Actual two-node cycle terminates, emits two cycle-pruning events, and never repeats a stage inside a route. | Pass |
| T11 | Actual transition requirement failure and rejected evidence separately block progression; stale edge evidence needs confirmation. | Pass |
| T12, H02 | Route IDs stable over repeated calls; revisions and budgets influence their own requests; original input and cached catalogue unchanged; no nodes attached to root. | Pass |
| T13, T14, T19 | 20-candidate cap, 4-stage default, 100-state default, and explicit smaller state budget terminate and identify truncation. Exactly 100 nonterminal starting states completes; 101 truncates. | Pass |
| T15, H05 | Unsupported catalogue/domain/mode/traversal, negative/fractional/boolean money, invalid grades, grade/pass mismatch, invented qualifications and client-computed results rejected. | Pass |
| T16 | Disabled AI reports rules fallback, truthful reason, at most four decisions, and a relevant missing-field question. | Pass |
| T17, T18 | Scripted invented route/skipped action rejected; search/evaluation still run. Scripted ranking cannot promote an infeasible direct route over a feasible conditional route. | Pass |
| T20–T22 | Missing key never invokes the provider boundary; injected timeout and outage invoke it once, preserve rule search/evaluation, report rules fallback and complete in less than one second. | Pass |
| T23, H05 | Null/list/non-object profiles, blank or duplicate normalized subject names and contradictory known maths credit are rejected; normalized accepted subjects leave the original nested input unchanged. | Pass |
| H06, H07 | Catalogue/evidence operations agree; internal loader is inaccessible; unexpected outer fields are rejected without public traceback content or fields. | Pass |
| T24–T28, H03 | Accountant goals rank related accounting programmes first; unmatched doctor/business goal remains not established; known mode outranks unknown; model order respects lowest cost and only breaks real ties. | Pass |
| T29–T30, T32 | Legacy sanitizer removes private errors without I/O. Canonical handler factory sanitizes then delegates exactly once; success/error=None envelopes are unchanged. HTTP H07 confirms the actual transport path. | Pass |
| T31, T35 | Mocked malformed object and rejected typed invented-route proposal report exactly `rules_fallback`; no invented route/claim is returned and the hand-calculated 54,000 cost remains authoritative. | Pass |
| T34 | Real pinned byLLM parameter builder drops configured nonstreaming timeout/retries. The application adapter supplies SDK timeout 8 seconds/retries 0, preserving model, schema-hinted messages, response schema, temperature, token budget and all remaining base parameters. No inference runs. | Pass |
| T33 | Real thread helper carries the caller ContextVar into a mocked provider, returns its typed decision, releases the isolated slot and restores caller context. No provider call occurs. | Pass |

T08–T11 construct independent `Catalogue`/`Offering` nodes from copied fixture
records and connect real `ProgressesTo` edges. They do not modify the shared
cached catalogue. Monetary expected values are fixed hand-calculated oracles.
Both regression files are native Jac. Standard-library HTTP/JSON and mock interoperability
does not implement eligibility, graph search, ranking or finance.

## Reproduce

From the project directory with its existing isolated environment:

```powershell
.venv/Scripts/jac.exe check tests/engine_tests.jac tests/http_regression.jac
.venv/Scripts/jac.exe test tests/engine_tests.jac -v
# Start the application using its documented server command in another terminal.
.venv/Scripts/jac.exe run tests/http_regression.jac
```

The Jac HTTP helper runs only through its named main entry; ordinary `jac test`
does not contact a server. It understands the installed Jac `data.reports` envelope.
Set `UNIPATH_TEST_BASE_URL` to target another local server URL. Jac may
return HTTP 200 with `data.error` for an unexpected walker constructor argument;
H07 treats that structured error as rejection and additionally requires no public traceback.
The project server-factory adapter sanitizes canonical responses before HTTPTransport
serializes them. The legacy JSON hook alone does not intercept that path. Internal-helper access currently
returns HTTP 401. The helper prints test names/results rather than student bodies.

## Limits and unrun checks

- Missing-key, injected provider failure and injected timeout are tested at the planner boundary. T34 additionally proves SDK parameter forwarding; these checks do not prove the actual network timer, semaphore saturation, or rate-budget enforcement.
- Provider tests restore the process environment and patched helper on exit. Their dummy key is not a credential. No key value is printed or loaded from a settings file by these tests.
- Live model quality and live request latency are outside these offline suites.
- UI interaction, browser accessibility, responsive layout and visual review are not covered by these files.
- Source URLs and catalogue structure are checked, but tests do not prove institutional admission, current fee completeness, professional recognition or transfer acceptance.
- Root and input/catalogue immutability assertions establish the tested in-memory behavior, not a forensic disk/database audit.
