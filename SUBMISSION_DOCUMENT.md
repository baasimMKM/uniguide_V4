# UniPath LK — submission draft

**Post-A/L education pathways with visible conditions, sources and uncertainty.**

This draft reflects the local prototype on 17 October 2026. The public repository and presentation files are published on GitHub. The planner fix passed clean checking and 35 native tests; all seven authoritative HTTP checks passed on the latest typing-fix revision; hosted CI is awaiting confirmation. Hosting is deferred by the user until local review and event submission remains pending; the language measurements below retain their method qualification. The six-slide pitch PDF/PPTX and a silent 2:30 captioned walkthrough assembled from real captured app views are prepared. The walkthrough is not a continuous screen recording.

## Problem and intended users

Sri Lankan students choosing a route after A/Ls must connect academic prerequisites, prior qualifications, location and family cash flow. A programme title or a plausible chatbot answer does not tell a family whether admission, fees or a transfer route has actually been checked. UniPath LK makes those distinctions visible across fields, including students interested in business, law, health, arts and education.

## Working product

A student selects a field and supplies a goal, academic results, budget and study preferences. Native Jac graph search explores programme stages, checks requirements and records blocked branches. Deterministic code evaluates the complete route before ranking. Each result exposes individual claim sources and unknowns. A relevant missing detail can trigger a follow-up question; the new profile is evaluated again on the server.

The real discovery catalogue has 31 programmes across 12 fields and five institutions. It contains one explicitly supported OUSL English diploma → BA application route. It remains a small curated sample with incomplete current-intake, professional-recognition and full cost information. The app does not establish admissions, professional registration or employment outcomes.

A separate fictional catalogue demonstrates the financial and multi-stage mechanics with fixed expected values: at LKR 2,000 initial savings and LKR 5,000 monthly budget, a direct route costs LKR 84,000 with a LKR 22,000 initial gap; a three-stage route costs LKR 54,000 with zero gap over 12 months when the relocation condition is met. These figures are test fixtures, not real fee quotations.

Goal text receives a visible subject-term alignment marker based on the final programme’s editorial tags. Normalised whole tag phrases may improve ranking after hard route status; an unmatched goal remains not_established. Confirmed study-mode matches can improve study-fit ordering, while unknown modes stay unconfirmed. These are discovery signals, not professional or employment assurances.

## How Jac and byLLM are used

`Catalogue` and `Offering` are native Jac nodes; `ProgressesTo` is a typed edge. `BranchSearchWalker` traverses actual graph connections with isolated earned qualifications, prerequisite checks, cycle pruning and explicit search limits. Six public Jac walkers serve the native Jac client. The browser submits profile data; server-side code owns graph search, evidence status and financial calculations.

The typed `PlannerDecision` and semantic instructions drive a genuine `by _llm(...)` decision function. The planner chooses among search, evaluate, ask and finish. Proposed actions, fields and route IDs are validated. A missing key, timeout, provider failure or invalid proposal leaves deterministic planning available and reports its mode truthfully. The model cannot fabricate an accredited bridge or override a failed rule.

The pinned Jac 0.16.7 runtime uses a project-local hook to repair the client mount ID, stylesheet inclusion and viewport metadata. A JSON hook and canonical API response-handler adapter remove framework error tracebacks and return a generic rejection message while leaving successful application reports intact and sending each response once. These compatibility measures are covered by the current validation work.

The native Jac BoundedGeminiModel subclass uses byLLM 0.6.19’s public make_model_params extension point to set an eight-second SDK transport timeout and zero SDK retries. This is necessary because that release’s nonstreaming parameter construction does not forward timeout/num_retries from call_params. The outer future waits for min(10 seconds, remaining session budget), with a 15-second planning deadline; stream_num_retries and max_output_retries are zero. Installed packages and byLLM’s prompt/schema/response handling remain unchanged.

## Evidence of execution

- Python 3.12, Jac 0.16.7 and byLLM 0.6.19 are pinned in the project configuration.
- The preserved-cache-quarantine baseline passed 35 native Jac tests and seven authoritative HTTP checks. A subsequent planner type-narrowing fix passed clean checking and all 35 native tests; all seven authoritative HTTP checks passed on the latest typing-fix revision; hosted CI is awaiting confirmation. Hosted CI status is not asserted. The matrix covers graph branches/cycles, monetary oracles, input rejection, request isolation, real-field discovery and fallback behavior.
- The current local browser journey also showed genuine AI-assisted planning through search, evaluation and a relevant O/L English question, with no fallback label on that captured request. An earlier genuine Gemini smoke request took 4.89 seconds; that separate observation is not a response-time or quality guarantee.
- Core browser QA is complete for the tested local journeys: business/accounting discovery, mobile hospitality layout, dark theme and keyboard interaction, evidence links, the O/L English follow-up and F-grade re-evaluation, unknown-cost stress, fictional financial oracles, and network-error/retry handling. This is a scoped local check, not a claim of every browser, device or accessibility condition. Source composition has been measured as qualified below. The organiser’s method remains unconfirmed; clean checking and 35 native tests passed after the planner fix, along with all seven authoritative HTTP checks on the latest typing-fix revision. Hosting is deferred by the user until local review.

See [verification details](docs/test-matrix.md) and [catalogue provenance](docs/catalogue-evidence.md). Test success does not verify institutional admission or complete source accuracy.

## Limits and next development

Search is bounded to four stages, 100 states and 20 candidate paths, with truncation reported. Only the best three candidate and three blocked route cards are returned. Real complete fee schedules remain unknown, so the app cannot currently establish real affordability. Professional recognition and current intake are separate confirmation tasks. The named travel/delay scenario calculates absolute changes from recorded assumptions; it does not predict survival probability.

Next priorities are user review of the local app, confirmation of the hosted CI run, reconciliation of the organiser’s source-counting method, broader accessibility/device validation, reviewed catalogue coverage and complete payment schedules. Additional transfer edges require explicit institution-specific support.

## Deliverable status

| Deliverable | Status |
| --- | --- |
| Repository URL and access check | [Public GitHub repository](https://github.com/madukamalruk/unipathlk-v2); initial commit [`d2f41e8`](https://github.com/madukamalruk/unipathlk-v2/commit/d2f41e823edb7f940b32d0d3de24ab5d6290fb46) verified |
| Jac repository star requirement | Pending verification |
| Source composition | Measured: custom audit 86.191% bytes / 72.892% lines; GitHub Jac 88.3%; organiser’s method unconfirmed |
| Clean verification after planner fix | Clean checker and 35 native tests passed; all seven authoritative HTTP checks passed on this revision; hosted CI awaiting confirmation |
| Working deployment URL | Deferred by user until local review |
| Demonstration video | [Silent 2:30 captured-view MP4](https://github.com/madukamalruk/unipathlk-v2/blob/main/docs/demo-walkthrough.mp4) published on GitHub; event hosting/submission requirements pending |
| Pitch deck | [Six-slide PDF](https://github.com/madukamalruk/unipathlk-v2/blob/main/docs/pitch-deck.pdf), [PowerPoint](https://github.com/madukamalruk/unipathlk-v2/blob/main/docs/pitch-deck.pptx) and preview published; final rehearsal pending |
| Final event submission | Pending |

Use actual verified links when available. Do not replace pending entries with an assumed deployment or an unrecorded demonstration.

## Publication and source measurement snapshot — 17 October 2026

The [public repository](https://github.com/madukamalruk/unipathlk-v2) was published with initial commit [`d2f41e8`](https://github.com/madukamalruk/unipathlk-v2/commit/d2f41e823edb7f940b32d0d3de24ab5d6290fb46). This is the initial publication snapshot; a subsequent planner control-flow fix passed clean checking and 35 native tests, and all seven authoritative HTTP checks on the latest typing-fix revision. Hosting is deferred by the user until local review; final event submission remains pending.

The recorded source snapshot reports Jac **86.191% of nonwhitespace UTF-8 bytes** and **72.892% of nonblank lines** under `scripts/audit_source.jac`. The observed GitHub Languages display reports **Jac 88.3%, CSS 11.0%, Other 0.7%**. These use different denominators. The organiser’s counting method is unconfirmed, so these measurements do not establish unconditional compliance with the ≥80% requirement. Rerun the source audit after code changes.
