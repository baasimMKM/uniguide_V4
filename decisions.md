# Architecture decisions

Date: 2026-10-17. The received older decision log is preserved in the external backup. This release supersedes its incompatible shared-blackboard, synthetic-transfer and resilience-score proposals.

| ID | Accepted decision | Reason and trade-off |
| --- | --- | --- |
| ADR-01 | Post-A/L students across all fields | Owner corrected the earlier IT-only scope; catalogue coverage is broad but deliberately small. |
| ADR-02 | Jac 0.16.7 / Python 3.12 / byLLM 0.6.19 in project .venv | Global PATH selected a conflicting Python 3.14 installation without byLLM. Use explicit local executable; do not mix source-main migrations. |
| ADR-03 | Native Jac client and one server authority | Remove the duplicate JavaScript planner and misleading silent browser fallback; keep the business logic in native Jac and report both composition measures without assuming event compliance. |
| ADR-04 | In-memory immutable catalogue graph and request-local findings | Avoid shared student evaluations and student-profile persistence. Restart reloads institutional data from source files. |
| ADR-05 | Facts and evidence are independent per claim | Programme existence does not verify tuition, admission, intake or professional recognition. Unknown costs stay null. |
| ADR-06 | Only sourced real progression edges | Add a bridge only when the institution supports it; fictional tests are visibly separate. No AI-created educational facts. |
| ADR-07 | Deterministic hard gates before preference/AI ordering | A low price or model suggestion must not override a missing prerequisite or failed cash flow. |
| ADR-08 | Real Gemini typed decisions with bounded recovery | Key presence is not a live model call. Restrict actions/IDs, time, retries and concurrent calls; label fallback honestly. |
| ADR-09 | Restrained, task-first premium UI | Owner's rulebook and premium-human-ui-ux skill take precedence over generic design-generator suggestions. Use ui-ux-pro-max selectively, not its default framework. |
| ADR-10 | Verify locally before publishing through JacHammer | Owner explicitly requires local verification first and final JacHammer hosting; GitHub source target is unipathlk-v2. |
| ADR-11 | No guarantee of admission, employment or error-free production | Report tested behaviour and remaining uncertainty with evidence; avoid claims beyond the source and actual checks. |

Revisit a decision when a verified requirement or runtime constraint changes. Preserve the original event timestamps; never backdate or force-push to conceal preparation.


## Incremental decisions — goal discovery and Jac 0.16.7 compatibility

| ID | Accepted decision | Reason and trade-off |
| --- | --- | --- |
| ADR-12 | Editorial goal tags on the terminal programme provide subject-term alignment only | Normalise case/punctuation and require complete tag phrases. Mark matched terms as related_subject_terms; otherwise not_established (or not_supplied for an empty goal). Do not infer professional pathways, licences or employment. |
| ADR-13 | Preserve hard status before goal relation and preference ordering | Related subject terms may affect deterministic ranking only after hard route status. Under study_fit, explicitly matching delivery-mode stages count ahead of unknown modes. Unmatched goals keep field discovery available. |
| ADR-14 | Use a project-local render hook for the pinned Jac 0.16.7 HTML boundary | Repair the root ID, link the extracted stylesheet and add viewport metadata after core rendering. Scope registration to the pinned version, replace the previous project hook on reload, and do not patch installed packages/generated bundles. |
| ADR-15 | Redact framework error envelopes before normal JSON serialization | Replace error text and remove exposed tracebacks at top-level/nested error boundaries. Return through the normal serializer once; successful reports stay unchanged. This does not claim comprehensive logging redaction. |
| ADR-16 | Set UTF-8 for raw Windows launch commands | The framework can print Unicode. Set PYTHONIOENCODING=utf-8 before starting Jac; the supplied launcher already does so. |

Confirmed test counts and the latest SDK-adapter follow-up checks belong in docs/test-matrix.md. Core browser QA is complete for the tested local journeys; hosting is deferred by the user until local review.


## Provider adapter and browser acceptance increment

| ID | Accepted decision | Reason and trade-off |
| --- | --- | --- |
| ADR-17 | Native Jac Model subclass at public make_model_params extension point | byLLM 0.6.19 nonstreaming parameters ignore timeout/num_retries passed through call_params. Set SDK timeout to eight seconds and retries to zero without editing installed packages or replacing typed generation. |
| ADR-18 | Independent outer future wait and session deadline | Wait for min(10 seconds, remaining 15-second session budget); stream_num_retries/max_output_retries are zero. Preserve worker context and eventual slot release. No measured global response-time guarantee is inferred. |
| ADR-19 | Preserve observed live/fallback labels in captured-view presentation | The replacement browser capture reports genuine AI-assisted search, evaluation and a missing-English question. The silent walkthrough uses this actual view and is disclosed as assembled captures, not continuous recording. |

Core browser QA is complete for the tested local journeys: business/accounting discovery, mobile hospitality layout, dark theme and keyboard interaction, evidence links, the O/L English follow-up and F-grade re-evaluation, unknown-cost stress, fictional financial oracles, and network-error/retry handling. This is a scoped local check, not a claim of every browser, device or accessibility condition.

Hosting is deferred by the user until local review; final event submission remains pending. Source composition has been measured; the organiser’s counting method remains unconfirmed. The planner control-flow fix passed clean checking and 35 native tests; all seven authoritative HTTP checks passed on the latest typing-fix revision; hosted Linux CI [run #2](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39014838908) passed for source commit `a5ff6d5`.

## Publication and source measurement snapshot — 17 October 2026

The [public repository](https://github.com/madukamalruk/unipathlk-v2) was published with initial commit [`d2f41e8`](https://github.com/madukamalruk/unipathlk-v2/commit/d2f41e823edb7f940b32d0d3de24ab5d6290fb46). This is the initial publication snapshot; a subsequent planner control-flow fix passed clean checking and 35 native tests, and all seven authoritative HTTP checks on the latest typing-fix revision. Hosting is deferred by the user until local review; final event submission remains pending.

The recorded source snapshot reports Jac **86.191% of nonwhitespace UTF-8 bytes** and **72.892% of nonblank lines** under `scripts/audit_source.jac`. The observed GitHub Languages display reports **Jac 88.3%, CSS 11.0%, Other 0.7%**. These use different denominators. The organiser’s counting method is unconfirmed, so these measurements do not establish unconditional compliance with the ≥80% requirement. Rerun the source audit after code changes.

The preserved-cache-quarantine baseline passed **35 native Jac tests and seven authoritative HTTP checks**. The subsequent planner type-narrowing fix passed the clean checker and all **35 native tests**. All seven authoritative HTTP checks also passed on the latest typing-fix revision (exit 0, `ci-final-http-authoritative.log`). The clean 12-file checker and exact CI-discovery run of 35 native tests passed locally; hosted Linux CI [run #2](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39014838908) passed for source commit `a5ff6d5`. Use `docs/test-matrix.md` for the latest confirmed result.
