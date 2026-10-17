# UniPath LK

An evidence-aware education pathway explorer for Sri Lankan post-A/L students across **12 fields**, with **37 real programmes from seven providers**. Explore current routes, compare their conditions and consider whether another A/L sitting fits your circumstances.

Built with **Jac 0.16.7, Python 3.12 and byLLM 0.6.19**. The native Jac client and graph/rule engine share one application. This is a hackathon prototype with a small researched catalogue, not a national directory or an admission service.

## Current experience

- Compact discovery dashboard with a desktop profile sidebar, collapsible mobile profile and live Asia/Colombo date/time.
- Up to three server-checked pathways, a side-by-side comparison, independent evidence disclosures, actual graph connections and planning activity.
- A/L retake scenario comparing user-estimated preparation time/spending, extra initial savings needed and separately calculated income forgone with routes available now.
- Show/hide study-guide panel with optional Gemini assistance. Gemini selects supported topics, programme IDs and curated tips; all displayed facts, numeric values and links come from server-owned records.
- Direct and multi-stage graph search, transition prerequisites, isolated branch state, pass/fail/unknown checks and an explicit travel/delay stress scenario.
- Six practical additions: SLITHM craft cookery/reception and DTET electrician, welding, tailoring and food processing. Complete current costs and intakes remain unconfirmed.

Another examination sitting and eligibility for UGC internal admission are different questions. The retake view cites the **2025/2026** handbook with its scope, and historical examination instructions are clearly labelled. No predicted grade, Z-score probability, examination permission or university place is promised.

## Run locally

```powershell
py -3.12 -m venv .venv
.venv\Scripts\python.exe -m pip install -r requirements.txt
$env:PYTHONIOENCODING = "utf-8"
.venv\Scripts\jac.exe start main.jac --port 8000
```

Open [UniPath LK locally](http://127.0.0.1:8000). The supplied `run_project.ps1` / `run_project.bat` launchers use the project environment. `index.html` is only a legacy startup note.

Configure `GOOGLE_API_KEY` or `GEMINI_API_KEY` only in the server environment or ignored local `.env`; optional `UNIPATH_MODEL` defaults to `gemini/gemini-3.5-flash-lite`. Without successful AI, deterministic planning and curated guidance remain available with honest fallback labels. Keys never belong in frontend settings, screenshots or commits.

## Verify

```powershell
.venv\Scripts\jac.exe test -d tests -v
# With the local server running:
.venv\Scripts\jac.exe run tests/http_regression.jac
.venv\Scripts\jac.exe run scripts/audit_source.jac
```

Latest local checks: **18 authored Jac modules checked; 54 native tests passed; 10 HTTP groups passed**. Overlapping root/council cases were consolidated after the earlier 71-case pass; assertions covering distinct boundaries remain. One real guide request returned `live_ai`, three programme IDs and three official sources in **2.05 seconds**; this is one smoke observation, not an SLA.

The owner confirmed both new retake and guide panels open in their browser. Automated local browser control remained disabled by Work settings, so new mobile, focus, comparison interactions and clock ticking are **not independently browser-verified**. Earlier screenshots and the prepared video show the prior release. See [verification](docs/test-matrix.md), [current UI checklist](docs/student-ui-review.md) and [research](docs/student-reality-research.md).

## Evidence and limits

Real complete fees stay unknown. Fictional fixtures remain separate: direct **LKR 84,000 / initial gap 22,000** versus the three-stage **54,000 / zero gap**. Retake preparation example: six months, monthly spending 7,000, one-off 4,000, savings 2,000 and contribution 5,000 gives spending 46,000 and extra initial savings 14,000. Income forgone 1,000/month is a separate 6,000 opportunity cost; it is not subtracted from the contribution again.

Jac 87.371% of nonwhitespace UTF-8 bytes; 71.707% of nonblank lines, including CSS and support scripts. The organiser's denominator remains unconfirmed; no unconditional 80% compliance claim is made. No Linguist overrides or generated filler are used.

Shared AI limits are two concurrent calls and 30 calls/minute per process; this is not distributed or per-client abuse control. The SDK transport timeout is 8 seconds with zero retries, within bounded outer waits. Request bodies are capped at 32 KiB, unused account/function surfaces are denied, static traversal is rejected and API errors are redacted. This is not a comprehensive security or production certification.

No accounts, saved plans, payments, loan approvals, live scraping, guaranteed transfers or job guarantees. Hosting through JacHammer is **deferred until local review**. Owner's deadline is **17:00 on 17 October 2026, Asia/Colombo**; aim to freeze fixes and rehearse before then.

## Project records and presentation

[PRD](prd.md) · [Architecture](architecture.md) · [Tasks](tasks.md) · [Decisions](decisions.md) · [Memory](memory.md) · [Catalogue evidence](docs/catalogue-evidence.md)

[Existing pitch PDF](docs/pitch-deck.pdf) · [PowerPoint](docs/pitch-deck.pptx) · [150-second silent walkthrough](docs/demo-walkthrough.mp4). These presentation binaries predate the new dashboard/retake increment and need an updated live demonstration or explicit prior-release label. Publication is not event submission.

Current source `92b9d31` also passed [clean Linux CI](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39018179217): dependency installation, authored Jac checks, native regressions and explicit HTTP checks.


Public-image repair: all five owner-provided artworks are included in the header, theme-aware welcome state, retake aid and study guide. The pinned runtime's missing binary-static hook is handled by a fixed-name project adapter. Latest local image increment passes five affected module checks, 54 native tests and **11 HTTP groups**, including exact PNG delivery/MIME. New visual layout review remains unverified because browser control is blocked.
