# Current UI review

The new UI builds through the pinned Jac client toolchain. Owner manually confirmed “Consider retaking A/Ls” and “Ask study guide” both open on the local app. The agent browser tool still returned “Local browser use is disabled in Work settings”, including after owner permission and a connection reset. No alternate browser automation bypass was used.

## Verified separately

- 18 Jac module checks; 54 native tests; 10 HTTP groups. These are not browser interaction checks.
- Local server rebuilt actual client bundle and served the application.
- Real Gemini guide API request succeeded with typed selections and server-owned sources.

## Remaining browser acceptance

1. Refresh the app; check compact dashboard and ticking Colombo clock.
2. Business & Finance, accounting goal, Commerce, 3 passes: explore then compare; inspect sources and unknown fees.
3. Retake: savings2,000/monthly contribution5,000;6months, monthly expense7,000, one-off4,000, income forgone1,000. Expected46,000spending/14,000extra initial savings/6,000opportunity cost. Change an input; previous scenario must show stale.
4. Open guide, ask with Gemini off, then explicitly enable Gemini. Check honest mode, safe source links, plain text, error/retry, Escape, close/reopen and focus return.
5. At 390px, inspect profile collapse, long programme headings, comparison horizontal scrolling, panel width, keyboard focus, dark theme and page overflow.

Earlier screenshots/video predate this increment. Keep them as prior-release evidence, not proof these new journeys were checked. No full WCAG, assistive-technology, multi-browser or load certification is claimed.
