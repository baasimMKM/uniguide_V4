# UniPath LK — 2:30 captured-view walkthrough script

The prepared docs/demo-walkthrough.mp4 is a captioned walkthrough assembled from nine real local-app captures. It has no audio and is not a continuous screen recording. This script describes its actual scenes; it can also guide an optional separate spoken presentation. Never claim that captions show unrecorded clicks or live interactions between captures.

Core browser QA is complete for the tested business, mobile hospitality, dark-theme/keyboard, evidence, follow-up English F-grade update, unknown-cost stress, fixture and network-error/retry journeys. The repository and presentation files are published on GitHub. The planner fix passed clean checking and 35 native tests; all seven authoritative HTTP checks passed on the latest typing-fix revision; hosted CI is awaiting confirmation. Hosting is deferred by the user until local review; event-specific video requirements and final submission remain pending. Rehearse the submitted revision and preserve fixture/source disclosures.

## Startup for a separate live demonstration

```powershell
$env:PYTHONIOENCODING = "utf-8"
.venv\Scripts\jac.exe start main.jac --port 8000
```

Keep credentials and real student data out of recordings. Use an invented profile. For the fiction-only calculation, use savings LKR 2,000, monthly budget LKR 5,000, three A/L passes, any study mode, relocation Yes, no prior qualifications and a consistent below-credit maths result.

| Time | Captured scene | Caption/narration meaning |
| --- | --- | --- |
| 0:00–0:15 | Desktop home | Post-A/L discovery across 31 programmes and 12 fields; a curated sample, not a complete national directory. |
| 0:15–0:35 | Business/accounting results | Results follow the field and show editorial subject-term alignment; this does not establish admission or a career. |
| 0:35–0:55 | Expanded evidence | Programme identity, entry, fees, recognition and intake are separate claims; real complete costs remain unknown. |
| 0:55–1:10 | Replacement AI activity capture | The actual screen reports AI-assisted search, evaluation and a relevant O/L English question without fallback. Server rules retain authority. |
| 1:10–1:25 | Mobile profile | Enter academic results and preferences; missing facts remain questions to confirm. |
| 1:25–1:40 | Mobile hospitality | Another field in the same scoped catalogue; review institutional conditions and current selection. |
| 1:40–1:50 | Dark mobile theme | The same actual application in its alternate theme; this does not prove all devices. |
| 1:50–2:10 | Fictional three-stage route | LKR 54,000 total, zero initial gap, 12 months, conditional on progression and relocation. These are fictional fixtures. |
| 2:10–2:30 | Fictional direct route | The same profile produces LKR 84,000 total and LKR 22,000 initial gap. This is not a real institutional fee offer. |

The replacement AI capture is evidence of that observed request. An earlier genuine Gemini smoke request took 4.89 seconds; do not attribute that timing to this screenshot or treat it as an SLA. If a later live demonstration falls back, show the actual fallback label and reason. Confirmed native/HTTP test counts belong in docs/test-matrix.md.

The provider adapter is native Jac using byLLM 0.6.19’s public parameter extension: SDK timeout eight seconds and zero SDK retries; outer future min(10 seconds, remaining 15-second planning deadline); zero stream/output retries. These implementation details support the technical pitch rather than the student-facing flow.

The generation helper is local-setup/build_demo_walkthrough.py outside the product. Its current build uses --activity-mode live only because capture 03 was replaced with the verified AI-assisted view. After changing captures, rerun and inspect the actual encoded frames. The MP4 is published on GitHub. Event-specific hosting and final submission are separate actions; publication is not event submission.

Publication: [repository](https://github.com/madukamalruk/unipathlk-v2), [captioned walkthrough](https://github.com/madukamalruk/unipathlk-v2/blob/main/docs/demo-walkthrough.mp4), [pitch PDF](https://github.com/madukamalruk/unipathlk-v2/blob/main/docs/pitch-deck.pdf). Initial published commit: `d2f41e823edb7f940b32d0d3de24ab5d6290fb46`. Final event submission remains pending. Hosting is deferred by the user until local review.
