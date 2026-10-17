# Jac Hammer deployment continuation prompt

Hosting is deferred by the user until local review. This is a saved prompt for a future explicitly requested deployment; do not execute its deployment steps now. It does not claim that Jac Hammer hosts the app. After the user resumes hosting work, confirm platform support for the pinned runtime and native Jac client.

```text
Deploy the existing UniPath LK source rather than generating a replacement application. Inspect README.md, jac.toml, requirements.txt, main.jac and tasks.md. Preserve Python 3.12, jaclang==0.16.7 and byllm==0.6.19. Do not upgrade framework versions without checking compatibility.

The local supported startup command is:
$env:PYTHONIOENCODING = "utf-8"
.venv\Scripts\jac.exe start main.jac --port 8000
For a Linux deployment, use the corresponding executable in its Python 3.12 environment and a platform-supported port binding; verify the platform requirements rather than assuming the local command is the final deployment configuration.

The project-native Model subclass sets an eight-second SDK transport timeout and zero SDK retries through byLLM 0.6.19’s public make_model_params extension. The outer future waits for min(10 seconds, remaining 15-second planning deadline); stream/output retries are zero. Preserve these controls and test them on the host.

The app mounts a native Jac client from components/App.cl.jac and exposes six public walker operations: get_app_info, plan_pathways, run_stress_test, get_catalogue_projection, get_evidence and health. Carry both data/real/catalogue.json and data/demo/catalogue.json plus required styles/client files. Do not expose private helpers or accept client-computed eligibility and financial results.

Configure GOOGLE_API_KEY or GEMINI_API_KEY as a server-side secret and UNIPATH_MODEL as an optional model setting. Never copy a local .env into a deployment artifact or reveal its values. Missing/unusable AI configuration must preserve rule-based planning and truthful fallback status. The app is anonymous; review public access and provider usage controls before sharing a URL. Existing process-local limits are not a distributed abuse-control system.

Preserve all evidence boundaries: 31 programmes, 12 fields, unknown complete real costs and intakes, one sourced English diploma-to-BA application route, and clearly fictional financial fixtures. Do not claim current accreditation, automatic admission, loans, employment or production readiness.

Verify the deployed health operation, client loading, a real non-IT profile, evidence links, the fictional financial oracle, invalid-profile rejection, the named stress scenario and AI-disabled fallback. Use tests/engine_tests.jac and tests/http_regression.jac as documented; set UNIPATH_TEST_BASE_URL only to an explicitly authorised target. Record exact commands, URL and results. A working local server or uploaded source is not proof of a working deployment.

Use docs/test-matrix.md for the latest confirmed native/HTTP results. One earlier genuine Gemini smoke request took 4.89 seconds; the current browser capture separately verifies AI-assisted search/evaluate/question behavior. Core browser QA is complete for the tested local journeys. Hosting is deferred by the user until local review. Source composition is measured below with the organiser’s counting method unconfirmed; the planner fix passed clean checking and 35 native tests, along with all seven authoritative HTTP checks on the latest typing-fix revision. Add deployment evidence and a real URL only after the deployed application has been checked. Do not mark submission/video/deck work complete automatically.
```

## Publication and source measurement snapshot — 17 October 2026

The [public repository](https://github.com/madukamalruk/unipathlk-v2) was published with initial commit [`d2f41e8`](https://github.com/madukamalruk/unipathlk-v2/commit/d2f41e823edb7f940b32d0d3de24ab5d6290fb46). This is the initial publication snapshot; a subsequent planner control-flow fix passed clean checking and 35 native tests, and all seven authoritative HTTP checks on the latest typing-fix revision. Hosting is deferred by the user until local review; final event submission remains pending.

The recorded source snapshot reports Jac **86.191% of nonwhitespace UTF-8 bytes** and **72.892% of nonblank lines** under `scripts/audit_source.jac`. The observed GitHub Languages display reports **Jac 88.3%, CSS 11.0%, Other 0.7%**. These use different denominators. The organiser’s counting method is unconfirmed, so these measurements do not establish unconditional compliance with the ≥80% requirement. Rerun the source audit after code changes.

The preserved-cache-quarantine baseline passed **35 native Jac tests and seven authoritative HTTP checks**. The subsequent planner type-narrowing fix passed the clean checker and all **35 native tests**. All seven authoritative HTTP checks also passed on the latest typing-fix revision (exit 0, `ci-final-http-authoritative.log`). The clean 12-file checker and exact CI-discovery run of 35 native tests passed locally; hosted CI is awaiting confirmation. Use `docs/test-matrix.md` for the latest confirmed result.
