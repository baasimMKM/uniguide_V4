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

Native Jac and Jac HTTP regression suites have passed locally. Current confirmed counts and any SDK-adapter follow-up checks belong in the test matrix. The checker passed the two test files with zero errors; warnings remain. The matrix records the actual assertions and caveats. These checks do not prove admissions, complete catalogue coverage, professional recognition or production readiness.

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
2. Run a reproducible Jac source audit with a stated denominator and exclusions. The ≥80% requirement is a target pending audit; do not claim 95% or compliance before counting.
3. Prepare deployment using the pinned runtime and external server-side configuration. Verify startup, all six operations, the client and fallback behavior at the deployed URL. A local server is not a deployed submission.
4. Review the prepared silent 2:30 captured-view walkthrough and six-slide PDF/PPTX deck. The video is assembled from actual captures rather than continuous recording; upload/link verification and submission are still required. Clearly identify the fictional financial segment and the incomplete real fees. Rehearse from `DEMO_VIDEO_SCRIPT.md`.
5. Add actual repository/deployment/video/deck links, verify their access, review event submission requirements and submit through the required workflow. Do not mark stars, deployment, recordings or uploads complete without evidence.

`tasks.md` owns the live checklist and final verification. Preserve the current catalogue unless a separately sourced correction is authorised. No synthetic accreditation, automatic loan award, job guarantee or inferred transfer is required for the current product.
