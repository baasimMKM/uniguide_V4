# UniPath LK — implementation status and remaining plan

This document describes the current prototype on 17 October 2026. It replaces the earlier speculative build plan. Runtime: Python 3.12, Jac 0.16.7 and byLLM 0.6.19.

## Implemented

| Area | Current behavior | Evidence or limit |
| --- | --- | --- |
| Catalogue | 31 real programmes across 12 fields; five institutions | `docs/catalogue-evidence.md`; scoped discovery sample |
| Graph | `Catalogue`/`Offering` nodes, typed `ProgressesTo` edges, branch search | Native graph regression cases cover AND rules, siblings, cycles and backtracking |
| Goal alignment | Terminal-stage editorial tag phrases; goal marker and matched terms | Search associations only; unknown goals remain not_established |
| Study fit | Confirmed delivery-mode matches sort ahead of unknown modes after status and goal relation | No assumed match for an unknown mode |
| Compatibility | Jac 0.16.7 render-root, stylesheet/viewport and generic framework-error hooks | Project-local runtime hooks; no package edits |
| Entry and evidence | Three-valued requirements, explicit prior credentials, individual claim provenance | Unknown conditions remain confirmation states |
| Finance | Whole-route monthly ledger, initial savings gap and named travel/delay stress scenario | Hand-calculated fictional oracles; all real fee schedules remain incomplete |
| Real progression | OUSL English diploma → BA English and ELT application route | Named institutional admission category; no automatic admission or credit reduction |
| AI | Typed byLLM next-action decisions, action/route validation and deterministic fallback | Live browser search/evaluate/question verified; earlier 4.89-second smoke remains a single observation |
| API | Six public Jac walkers, validated profiles, server recomputation | HTTP regression baseline passed locally; confirmed counts and latest SDK-adapter rerun recorded in the test matrix |
| Client | Native Jac client with profile, pathways, sources, connections and activity views | Core browser QA complete for the tested journeys |

## Verification already recorded

The preserved-cache-quarantine baseline passed **35 native Jac tests and seven authoritative HTTP checks**. The subsequent planner type-narrowing fix passed the clean checker and all **35 native tests**. All seven authoritative HTTP checks also passed on the latest typing-fix revision (exit 0, `ci-final-http-authoritative.log`). The clean 12-file checker and exact CI-discovery run of 35 native tests passed locally; hosted Linux CI [run #2](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39014838908) passed for source commit `a5ff6d5`. Use `docs/test-matrix.md` for the latest confirmed result. The checker passed the two test files with zero errors; warnings remain. The matrix records the actual assertions and caveats. These checks do not prove admissions, complete catalogue coverage, professional recognition or production readiness.

```powershell
.venv\Scripts\jac.exe check tests/engine_tests.jac tests/http_regression.jac
.venv\Scripts\jac.exe test tests/engine_tests.jac -v
# Start in another terminal:
$env:PYTHONIOENCODING = "utf-8"
.venv\Scripts\jac.exe start main.jac --port 8000
# Run against that server:
.venv\Scripts\jac.exe run tests/http_regression.jac
```

## Browser and provider verification scope

Core browser QA is complete for the tested local journeys: business/accounting discovery, mobile hospitality layout, dark theme and keyboard interaction, evidence links, the O/L English follow-up and F-grade re-evaluation, unknown-cost stress, fictional financial oracles, and network-error/retry handling. This is a scoped local check, not a claim of every browser, device or accessibility condition.

The current local browser journey also showed genuine AI-assisted planning through search, evaluation and a relevant O/L English question, with no fallback label on that captured request. An earlier genuine Gemini smoke request took 4.89 seconds; that separate observation is not a response-time or quality guarantee.

The native Jac BoundedGeminiModel subclass uses byLLM 0.6.19’s public make_model_params extension point to set an eight-second SDK transport timeout and zero SDK retries. This is necessary because that release’s nonstreaming parameter construction does not forward timeout/num_retries from call_params. The outer future waits for min(10 seconds, remaining session budget), with a 15-second planning deadline; stream_num_retries and max_output_retries are zero. Installed packages and byLLM’s prompt/schema/response handling remain unchanged.

## Current ranking boundary

Goal text is matched against editorial subject-exploration tags on the terminal programme in a route. Matching is case-insensitive, ignores punctuation and requires a complete normalised tag phrase in the supplied goal; it is not semantic career counselling. A match is labelled `related_subject_terms`; an unmatched goal is `not_established` and does not invent or remove routes. An empty goal is `not_supplied`. These search associations do not establish professional qualification, registration, admission or employment.

Deterministic ordering keeps route status first, then related subject terms, then the selected cost/duration/study preference. With `study_fit`, explicitly matching delivery-mode stages rank ahead of unknown modes; an unknown mode is not counted as a confirmed match. Field selection still defines the discovery scope, including general or unmatched goals. No goal term or study preference can override a failed prerequisite, cash-flow condition or evidence gate.

## Work still required

1. Preserve the completed core browser QA evidence. Recheck affected journeys if the final source revision changes; do not generalise the scoped checks to all browsers/devices.
2. Preserve the final local evidence: clean 12-file checking, exact CI-discovery 35 native tests and seven authoritative HTTP checks passed after the planner typing fix. GitHub Linux CI [run #2](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39014838908) passed. Preserve the measured source snapshot below and reconcile the organiser’s counting method; rerun the audit after final code changes. Do not turn a measured percentage into an unqualified eligibility claim.
3. Support the user’s local application review. Hosting is deferred by the user until that review. Keep future deployment work dormant until requested; then verify the pinned runtime, six operations, client and fallback at the real hosted URL.
4. Review the prepared silent 2:30 captured-view walkthrough and six-slide PDF/PPTX deck. The video is assembled from actual captures rather than continuous recording; the files are now published on GitHub, while the event’s video-hosting requirements and final submission still need confirmation. Clearly identify the fictional financial segment and the incomplete real fees. Rehearse from `DEMO_VIDEO_SCRIPT.md`.
5. Preserve the public repository and artifact links below. Hosting is deferred until the user’s local review. Verify event-specific video/link requirements, then submit through the required workflow. The repository star requirement and event submission need separate evidence.

`tasks.md` owns the live checklist and final verification. Preserve the current catalogue unless a separately sourced correction is authorised. No synthetic accreditation, automatic loan award, job guarantee or inferred transfer is required for the current product.

## Publication and source measurement snapshot — 17 October 2026

The [public repository](https://github.com/madukamalruk/unipathlk-v2) was published with initial commit [`d2f41e8`](https://github.com/madukamalruk/unipathlk-v2/commit/d2f41e823edb7f940b32d0d3de24ab5d6290fb46). This is the initial publication snapshot; a subsequent planner control-flow fix passed clean checking and 35 native tests, and all seven authoritative HTTP checks on the latest typing-fix revision. Hosting is deferred by the user until local review; final event submission remains pending.

The recorded source snapshot reports Jac **86.191% of nonwhitespace UTF-8 bytes** and **72.892% of nonblank lines** under `scripts/audit_source.jac`. The observed GitHub Languages display reports **Jac 88.3%, CSS 11.0%, Other 0.7%**. These use different denominators. The organiser’s counting method is unconfirmed, so these measurements do not establish unconditional compliance with the ≥80% requirement. Rerun the source audit after code changes.
