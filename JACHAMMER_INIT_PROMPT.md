# Jac Hammer deployment continuation prompt

Deployment is pending. This prompt prepares the existing application for deployment; it does not claim that Jac Hammer currently hosts it. Confirm the target platform supports the pinned runtime and native Jac client before proceeding.

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

Use docs/test-matrix.md for the latest confirmed native/HTTP results. One earlier genuine Gemini smoke request took 4.89 seconds; the current browser capture separately verifies AI-assisted search/evaluate/question behavior. Core browser QA is complete for the tested local journeys. Deployment and final Jac audit/method reconciliation remain pending. Add deployment evidence and a real URL only after the deployed application has been checked. Do not mark submission/video/deck work complete automatically.
```
