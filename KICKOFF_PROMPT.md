# Continuation prompt — UniPath LK

Use this prompt to continue the existing project without regenerating it.

```text
Continue UniPath LK, the Sri Lankan post-A/L pathway discovery prototype. First read README.md, tasks.md, docs/test-matrix.md and docs/catalogue-evidence.md, then inspect the actual source relevant to the next task. Follow applicable repository instructions while checking older concept claims against the current code.

Use Python 3.12, jaclang 0.16.7 and byllm 0.6.19 through the project-local environment. Start with:
$env:PYTHONIOENCODING = "utf-8"
.venv\Scripts\jac.exe start main.jac --port 8000

Actual verification commands:
.venv\Scripts\jac.exe check tests/engine_tests.jac tests/http_regression.jac
.venv\Scripts\jac.exe test tests/engine_tests.jac -v
.venv\Scripts\jac.exe run tests/http_regression.jac
The HTTP helper requires an already-running local server. Use docs/test-matrix.md for the latest confirmed native and HTTP results; passing regressions are not complete coverage.

Preserve the native Jac client, six public walkers, deterministic graph engine and bounded typed byLLM planning. There are 31 real programmes across 12 fields, with explicit claim provenance and unknown complete real costs. The real English diploma-to-BA edge is an application route only. Nursing and several advanced-entry programmes need prior qualifications; avoid recommending them as direct A/L entry.

Keep fictional demo records separate and visibly labelled. Their financial oracle is direct total 84,000 / gap 22,000 versus three-stage total 54,000 / gap 0 at savings 2,000 / monthly budget 5,000, with relocation true. Never turn fixture figures into institutional claims.

The model may choose bounded actions and supplied route IDs. It must not invent programmes, fees, admissions, accreditation, credits or employment. Eligibility and finance remain server-owned. Preserve the honest live_ai/mixed/rules_fallback labels.

One earlier real Gemini request took 4.89 seconds, a smoke observation only. The current browser capture verifies AI-assisted search/evaluate/question behavior. Core browser QA is complete for the tested journeys. The captioned captured-view video and PDF/PPTX deck are prepared; the repository and files are published on GitHub. The planner fix passed clean checking and 35 native tests; all seven authoritative HTTP checks passed on the latest typing-fix revision; hosted Linux CI [run #2](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39014838908) passed for source commit `a5ff6d5`. Hosting is deferred by the user until local review and final event submission remains pending. Source composition is measured below; the organiser’s counting method remains unconfirmed. Work from tasks.md and verify a step before marking it complete.

The native Jac provider subclass uses byLLM 0.6.19’s public make_model_params extension for an eight-second SDK timeout and zero SDK retries; outer future waits are min(10 seconds, remaining 15-second deadline), with zero stream/output retries. Preserve it without editing installed packages.

Keep secrets server-side and out of source, browser, logs and recordings. Do not read or print credential values. Do not replace the working app with the superseded nine-walker/synthetic-bridge concept. Explain remaining limitations plainly.
```

## Publication and source measurement snapshot — 17 October 2026

The [public repository](https://github.com/madukamalruk/unipathlk-v2) was published with initial commit [`d2f41e8`](https://github.com/madukamalruk/unipathlk-v2/commit/d2f41e823edb7f940b32d0d3de24ab5d6290fb46). This is the initial publication snapshot; a subsequent planner control-flow fix passed clean checking and 35 native tests, and all seven authoritative HTTP checks on the latest typing-fix revision. Hosting is deferred by the user until local review; final event submission remains pending.

The recorded source snapshot reports Jac **86.191% of nonwhitespace UTF-8 bytes** and **72.892% of nonblank lines** under `scripts/audit_source.jac`. The observed GitHub Languages display reports **Jac 88.3%, CSS 11.0%, Other 0.7%**. These use different denominators. The organiser’s counting method is unconfirmed, so these measurements do not establish unconditional compliance with the ≥80% requirement. Rerun the source audit after code changes.

The preserved-cache-quarantine baseline passed **35 native Jac tests and seven authoritative HTTP checks**. The subsequent planner type-narrowing fix passed the clean checker and all **35 native tests**. All seven authoritative HTTP checks also passed on the latest typing-fix revision (exit 0, `ci-final-http-authoritative.log`). The clean 12-file checker and exact CI-discovery run of 35 native tests passed locally; hosted Linux CI [run #2](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39014838908) passed for source commit `a5ff6d5`. Use `docs/test-matrix.md` for the latest confirmed result.
