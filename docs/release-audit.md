# Independent release audit

Audited on 17 October 2026 after the root engineer declared the source freeze.
Runtime: project-local Python 3.12, Jac 0.16.7 and byLLM 0.6.19. Application source
fixes belong to the root/UI engineers; the test engineer owns the regression
files and this audit. The final staged and authoritative Downloads handwritten-source fingerprints match after the clean-checker repair. Composition and credential scans describe that authoritative source/build snapshot; its post-sync seven-group HTTP suite passes.

## Language proportion

The shipped native Jac audit (`jac run scripts/audit_source.jac`) and a separate
read-only counter agree. All 16 handwritten source files are included: Jac
application/services/components, both regression files and the audit itself,
plus CSS, HTML, PowerShell and the batch launcher. Comments are included.
Generated files, dependencies, reference material, data, documentation and
non-code configuration are excluded consistently across languages. No vendoring
classification, padding or formatting change was used to obtain these results.

| Measure | Jac | All handwritten source | Jac share |
| --- | ---: | ---: | ---: |
| Nonblank lines | 2,853 | 3,914 | 72.892% |
| UTF-8 bytes after removing Unicode whitespace | 98,916 | 114,764 | 86.191% |

The byte measure exceeds 80%; the line measure does not. Publish both values and
the counting scope. This is a composition measurement, not a guarantee of the
competition's interpretation of its language requirement.

Source snapshot SHA-256, over sorted relative paths and their source bytes:
`052aca08faf4cc06c2c1b1c56beb620c0676eb70d34c4fd849938142ede31462`.
The native Jac audit and independent counter agree on this revision; both completed all reads without errors.

## Credential scan

One configured provider-secret value was read into a local read-only scanner and
compared byte-for-byte. Only counts/file names were emitted; no secret value,
environment line or matched content was printed. The frozen snapshot had:

| Scope | Files scanned | Matching files | Occurrences |
| --- | ---: | ---: | ---: |
| Handwritten source | 16 | 0 | 0 |
| Publishable files, including source/docs/config/examples/data | 62 | 0 | 0 |
| Generated browser assets, including compiled files/bundles/maps | 15 | 0 | 0 |

The local `.env` is intentionally excluded from leak findings. Filename-only Git
checks showed no tracked local secret `.env` at audit time; `.env`, `.venv` and
`.jac` matched ignore rules. `.env` was never copied to the smoke project.

This exact raw-byte comparison is not a general secret scanner or a review of
Git history, logs, third-party services, compressed document contents, or
arbitrary encoded/transformed versions of a key. A later build/source change
requires another scan of the affected artifacts.

## Clean-source startup and regressions

An explicit source/configuration/catalogue set was copied to a new workspace
folder without `.env`, `.venv`, `.jac`, `.git`, reference material or original
caches. The existing pinned Python/Jac environment was reused. Its initial
startup installed a separate Bun/client dependency tree, compiled the client
and reached server readiness on port 8002. Both provider-key environment
variables were unset for that process. A subsequent 22-file refresh rebuilt
that copy's client independently of the original project's generated files.

Direct Windows startup initially hit an encoding error while processing a route
arrow. Setting `PYTHONIOENCODING=utf-8`, as already done by the documented
PowerShell launcher, resolved it. The HTML compatibility adapter initially
exposed a native Jac `super()` syntax mistake; startup then passed after the
responsible engineer changed it to the supported native syntax.

Earlier backend checks used refreshed services in the key-free smoke copy, started with `--no_client`. Final HTTP checks target the authoritative Downloads server on port 8000 with every planning request disabling AI. This audit did not rebuild that server's client.

- The exact CI discovery command `jac test -d tests -v` passed all 35 native tests (0.246 seconds), including safe provider failure,
  malformed-object, rejected-proposal labels and real thread/context propagation regressions. The real SDK parameter builder now proves an eight-second timeout and zero retries reach the request while retaining its typed payload. Discovery found zero automatic tests in the named-main HTTP helper.
- A preserved/quarantined staged IR cache forced a clean check of all 12 authored Jac files; all passed in 48.98 seconds with zero errors. JSON-boundary/deprecation warnings remain.
- All seven native Jac HTTP groups passed on the final authoritative server on port 8000, including unique qualification-selector IDs and canonical errors without
  tracebacks, all twelve fields, goal/preference ordering, invalid profiles,
  cash/stress oracles and rejection of client-computed results.
- The HTTP helper returned exit 1 for an intentionally unreachable local URL and
  exit 0 for the successful smoke suite. It prints group/result/type only.
- Canonical handler tests prove sanitization delegates exactly once and leaves
  successful data unchanged; live HTTP parsing confirms one complete envelope.

These checks establish source/cache independence and backend behavior. A separate fresh Python environment was installed offline from the local package cache, matched all 57 locked distributions, passed dependency consistency and ran the then-current 33 tests (0.596 seconds). It reused no original environment; an uncached network installation remains unverified. A cold build/render of the final UI revision was not independently established by this audit. The root/UI engineers own final
browser journeys, live-model checks and deployment verification. Only the
tracked smoke process is managed by this audit; the main server is untouched.

## Remaining findings and limits

1. **Release interpretation:** byte and line measures disagree on the 80%
   threshold. Retain both measures and avoid an unconditional compliance claim.
2. **P2, anonymous AI fairness:** the two-call semaphore and 30-call/minute
   budget are per process, not per client or across replicas. One caller can
   consume the allowance and force others to rules fallback; replicas multiply
   aggregate spend. Broader public deployment needs an ingress/shared client
   rate limit and operator budget.
3. **P3, framework transport status:** rejected unexpected outer arguments use
   HTTP 200 with a generic structured error in this pinned runtime. Consumers
   and monitoring must inspect the envelope rather than treating every HTTP 200
   as a successful plan. The body rejects tampering and no longer exposes a
   traceback.
4. **Verification scope:** mocked provider-boundary failures prove deterministic
   recovery, not real network timeout timing, load saturation, distributed rate
   enforcement, current institutional admission, or transfer/recognition claims.

The audit reproduced and the responsible engineers corrected non-object
profiles accepted as defaults, duplicate/blank subjects counting as passes,
contradictory maths credit, mutation during subject normalization, unchecked
model prose/ordering, malformed model structures, incorrect fallback labels, dropped SDK timeout/retry options, lost worker context and public
framework tracebacks. The regressions exercise those concrete cases. No audited
native or final HTTP assertion remains failed on the latest planner revision.



The final transport check reproduced a release-cache problem: source copies had
preserved older modification times, so Jac's IR cache fast path served old API
code and data (37 programmes and repeated selector IDs) despite the source having
31 programmes and deduplicated IDs. The root engineer preserved/quarantined the
old IR cache, changed synchronization to refresh copy modification times, and
restarted from current source. The unchanged seven-group suite then passed,
including the new unique-selector-ID assertion. A server-ready log alone was
insufficient; actual listener and response checks established readiness. The
owned clean smoke server on port 8002 was stopped after checking its recorded
PID/command/port; the authoritative and SDK servers were left to their owner.
The first clean CI run exposed a planner type-checking error hidden by prior
cache reuse: assigning None inside a narrowed PlannerDecision branch was
rejected. The responsible engineer removed that assignment and used an elif
validation branch, preserving fallback behavior. A clean-cache check of all
12 authored Jac files and the unchanged 35 native cases pass on this revision.
Initial public GitHub commit `d2f41e8` triggered a first hosted CI run that
exposed the planner type-checking issue above. Its correction now passes a
clean local checker, the exact CI discovery command and the authoritative HTTP
suite. Hosted Linux CI [run #2](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39014838908) passed for source `a5ff6d5`, including fresh dependency installation, checking, native tests and HTTP regressions. Jac Hammer deployment is deferred until after local review
at the user's request.
