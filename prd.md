# UniPath LK product requirements

Updated 2026-10-17. Audience: Sri Lankan students choosing their next education pathway after A/Ls, across all fields. The interface and code use English; collaboration with the owner uses natural Sinhala.

## Outcome

Help a student explore credible programmes and progression routes against their interests, qualifications, savings, monthly contribution, location and study preferences. Explain known constraints, unknown information and next actions with institutional sources. A catalogue match is neither an admission decision nor a career guarantee.

## Approved release

- Twelve fields: IT, engineering, medicine/health, science, business/finance, law, social sciences, education, arts/design, languages/media, agriculture/environment, tourism/hospitality.
- A free-text career goal complements the selected field. The catalogue is a small cross-field starting point, not nationwide completeness; specific career fit may need additional advice.
- Capture A/L stream, subjects/grades, year/passes, optional Z-score and O/L grades, existing qualifications, savings, monthly budget, district, relocation, study mode and ranking preference.
- Search direct and multi-step graph routes. Recheck node and transition prerequisites with pass/fail/unknown logic, copied branch states, cycle guards and explicit search limits.
- Compare up to three possible routes; list blocked options separately. Show prerequisites, stages, cash-flow assumptions, evidence, unknowns and next steps.
- Ask one relevant missing student question and recompute after an answer. A bounded Gemini planner can select actual actions and order known routes; deterministic code retains authority.
- Stress a full supplied profile using travel +40% and six months of delay. Show absolute deltas, not survival or success probabilities.
- Native Jac responsive UI with readable source information, graph/activity secondary views, light/dark themes, keyboard support and complete error/loading states.
- Run and verify locally first. Publish reviewed source to madukamalruk/unipathlk-v2, then deploy through JacHammer after local acceptance. Keep local/video backup.

## Excluded from this release

Accounts, saved student profiles, payments, loan approvals, live scraping, a complete national course database, foreign scholarship matching, job guarantees, fabricated lateral transfers, admission probabilities, synthetic institution nodes, resilience percentages and unsupported nationwide statistics. Minimum Change Finder and a separate Gap Finder are future scope. Standard course-source next steps are included.

## Acceptance

1. Every field has at least two real programme records, with independent claim statuses. Fees missing official complete schedules remain unknown.
2. Non-IT fields work through the same API and graph engine. Hard prerequisites cannot be overridden by AI, preferences or the existence of an edge.
3. Fictional fixture is explicitly labelled and its 84,000/54,000 cash-flow oracle is reproducible. Fixture facts never become real institutional claims.
4. Genuine Gemini activity is distinguished from deterministic fallback, mixed runs and internal test stubs. Invalid IDs/actions and provider errors recover safely.
5. Invalid input, request races, disconnected server, unknown costs and repeated requests behave predictably without losing the form or leaking another student's state.
6. Handwritten source is measured transparently against the >=80% Jac rule. Meaningful graph and AI behaviour remain authored in Jac.
7. A fresh setup, local browser journey, security checks and the final deployed journey have recorded evidence. An unrun check remains explicitly unrun.

The received older PRD and claims are preserved in the external original-project backup. This document supersedes their implementation scope; it does not rewrite project history.
