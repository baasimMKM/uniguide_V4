---
name: premium-human-ui-ux
summary: Design and implement distinctive, premium, accessible, human-centered UI/UX without generic AI-generated visual or copywriting patterns.
description: Use this skill when asked to design, critique, refactor, implement, or audit UI/UX for web, mobile, desktop, SaaS, dashboards, forms, onboarding, or product interfaces. Enforces human-centered information architecture, restrained visual design, Apple-inspired craft without copying Apple branding, accessibility, complete interactions, responsiveness, and anti-AI-slop quality gates.
---

# Premium Human UI/UX — Anti-AI-Slop Skill

## Mission
Produce interfaces that feel intentional, clear, trustworthy, distinctive, fast, and crafted by expert product designers. Optimize for users completing real tasks. Never confuse visual spectacle with good UX. Apple's Human Interface Guidelines are an inspiration for clarity, familiarity and craft, not a template to clone. Respect the target platform's native conventions.

## Activation and working contract
Use for any request to create, redesign, audit or implement an interface or design system. First infer from context: platform, audience, primary task, content, product personality, constraints and stack. Ask only if a missing answer is genuinely blocking; otherwise choose reasonable assumptions and state important ones. When implementation is requested, deliver actual working code, not just a pretty concept. When an audit is requested, identify severity, user consequence, and specific fix. Never claim testing or verification that did not occur.

## Non-negotiable priorities (ordered)
1. User goals, useful content and clear task flow.
2. Accessibility, privacy, safety, trust and inclusive interaction.
3. Understandable navigation and predictable controls.
4. Content hierarchy, typography, spacing and readable contrast.
5. Fully working UI states, feedback, errors and recovery.
6. Responsive, performant and maintainable implementation.
7. Distinctive and refined aesthetics, only after the above.

## 1. Anti-AI-slop hard rules
- **NO generic AI aesthetic by default:** avoid purple/blue gradient washes, neon glows, gratuitous glassmorphism, gradient text, glass cards everywhere, and endless pill buttons.
- **NO decorative excess:** avoid pointless sparkles, robots, rockets, magic wands, blobs, abstract waves, oversized hero art, and ornamental dashboards not justified by the product.
- **NO card soup:** do not wrap every heading, label, chart and paragraph in a bordered card; prefer clear spacing and typography for grouping.
- **NO fake substance:** never fabricate real metrics, testimonials, ratings, customers, awards, notifications, charts or activity. Clearly label sample/demo data.
- **NO fake functionality:** every clickable item must do something meaningful. Disabled buttons explain requirements when needed. No dead-end navigation, fake search, decorative toggles or broken links.
- **NO robotic microcopy:** ban filler such as “Unlock the power of,” “Revolutionize your workflow,” “Seamlessly elevate,” “Empower your journey,” “Supercharge,” unless genuinely appropriate to a product's established voice. Use straightforward, context-specific words.
- **NO indiscriminate animation:** no bouncing everything, constant shimmering, entrance effects on every element, unnecessary parallax, autoplay, or cursor-following spectacles.
- **NO unearned complexity:** avoid nested navigation, duplicate calls to action, dashboard statistics without a decision purpose, and excessive filters.
- **NO Apple imitation by copying** proprietary graphics, icons, product screens or brand styling. Aim for comparable craft and platform-native familiarity, with an original product identity.
- **NO cargo-cult minimalism:** do not hide useful functions, sacrifice contrast, or remove essential labels to look clean.
- **NO one-size-fits-all template:** adapt layout and visual identity to audience, domain, content and task.
- **NO unnecessary emojis/icons** in product UI. Icons must communicate actions or concepts and come from one coherent icon system.
- **NO high-fidelity mockup that ignores reality:** long names, errors, loading, permissions, keyboard, small screens, zoom and assistive technologies must work.

## 2. Define the product before drawing screens
Identify: (a) who uses this, (b) top three jobs-to-be-done, (c) most important action per view, (d) content model and actual data, (e) user context and device, (f) error/security/privacy risks, (g) desired brand traits, (h) success metrics. Map task flows, entry points, back paths, destructive actions and empty states. Prioritize task success, learnability and speed over decorative novelty.

## 3. Information architecture and navigation
- Give each screen a clear purpose, descriptive title, and dominant next step.
- Design around user mental models and established platform conventions. Keep depth shallow where practical.
- Make current location visible; back behavior must be predictable, preserving context, scroll and unsaved work where feasible.
- Make critical actions discoverable; do not hide them in icon-only menus or gestures.
- Mobile primary tab destinations are commonly 3–5 when suited to the product; do not force tabs onto every design.
- Search, filtering, sorting, grouping and browsing solve different problems; implement only when needed.
- Apply progressive disclosure: simple defaults, advanced options available on demand.
- Support keyboard shortcuts and power-user paths when appropriate; avoid making novices pay for expert complexity.

## 4. Visual hierarchy and composition
- Establish reading order: screen context → main information → primary action → supporting detail.
- Use consistent alignment, a coherent grid, intentional negative space and proximity-based grouping.
- Prefer content-first sections to nested containers. Separate areas using whitespace first, dividers next, surfaces only when genuinely useful.
- Keep surfaces flat by default; elevation communicates layering or interaction, not status or visual flair.
- Avoid duplicated headings, introductory filler, oversized empty headers and excessive above-the-fold chrome.
- Align visual priority with semantic and interaction priority. Do not make destructive or secondary actions look primary.
- Use believable, domain-specific content; realistic edge cases should influence layout.

## 5. Design tokens — starting values, not universal laws
Use a token system, not scattered constants. Adapt values to platform, accessibility needs, and existing design systems.

| Category | Practical starting point |
|---|---|
| Spacing | 4, 8, 12, 16, 24, 32, 48, 64 px; 4 px fine adjustments |
| Mobile page gutters | 16–24 px |
| Desktop page gutters | 24–48 px, based on layout |
| Prose width | ~60–75 characters per line where practical |
| General content max width | Often ~1100–1280 px for broad layouts; narrower for reading/forms |
| Base body text | 16–17 px equivalent; respect user font scaling |
| Type scale | ~12, 14, 16, 20, 24, 32, 40 px, context-dependent |
| Body line height | ~1.45–1.65, adjusted to typeface and size |
| Controls | Often ~44–52 px tall; account for platform touch-target requirements |
| Card corners | Usually ~12–20 px if cards are warranted |
| Borders | Usually subtle 1 px with adequate visibility when conveying boundary |
| Motion | Commonly ~150–300 ms for small UI transitions; never a mandate |

### Colors and surfaces
- Start with calm neutral backgrounds, strong readable foreground text, and one restrained brand accent; add semantic success/warning/error colors.
- Define `background`, `surface`, `surface-raised`, `text-primary`, `text-secondary`, `border`, `accent`, `focus`, `success`, `warning`, `danger`, and their dark-mode equivalents.
- Color must convey meaning consistently; never rely on color alone for state or errors.
- Use dark-mode surfaces with intentional depth and contrast, not mechanical inversion.
- Test actual contrast; placeholder and secondary text must stay readable.
- Avoid uncontrolled opacity layers, gradients and shadows. Do not use transparent glass behind critical reading content if contrast suffers.

### Typography
- Prefer a suitable system font (SF on Apple platforms, native fonts elsewhere), or a carefully selected versatile family such as Inter on web.
- Minimize font families; use weights and scale deliberately. Typical headings use semibold/bold, body regular/medium, never bold everything.
- Support localization, long words, dynamic type, RTL when relevant, and readable numeric alignment.
- Do not use uppercase or letter spacing as an automatic premium design signal.
- Use accessible, semantic heading hierarchy, not just visually enlarged divs.

### Iconography and imagery
- Maintain one icon family with consistent stroke, size, metaphors and optical alignment.
- Label ambiguous actions. Do not substitute icon-only controls for discoverability without a compelling reason.
- Use images that explain real content or establish a genuine brand voice; do not add stock visuals to fill space.
- Use appropriate alt text and optimize image size and cropping.

## 6. Component behavior
### Buttons
One primary action per decision area where practical. Make secondary actions quieter. Label with verbs and outcomes (`Create project`, `Save changes`). Show hover, focus-visible, pressed, loading, disabled, success/error states. Prevent double submission. Do not put two equally loud CTAs next to each other without a reason.

### Inputs and forms
Use persistent labels, explicit units, relevant input types, autocomplete where appropriate, sensible defaults, clear required/optional indication, and inline validation at the right time. Keep user inputs after errors. Provide actionable error descriptions and error summaries for longer forms. Ensure keyboard focus order, enter/escape behavior and mobile keyboard handling are sensible. Never depend solely on placeholders.

### Menus, tabs, dialogs
Choose navigation vs command surfaces intentionally. Menus have actionable labels and close predictably. Tabs switch peer views and expose their selected state. Dialogs focus on a small decision; favor inline flow when a modal would interrupt work. Trap/restore focus in modal dialogs, support appropriate Escape behavior and scrolling.

### Lists, cards and tables
Use lists for scannable information, tables for comparable dense structured data, cards only when grouping or selection benefits. Use sorting/filtering when they actually help. On small screens transform tables thoughtfully rather than blindly compressing columns.

### Search and filters
Clarify scope and query state; provide useful empty and no-result states. Debounce as appropriate, make applied filters visible and removable, support reset, and preserve state across reasonable navigation.

### Destructive actions
Use clear labels, distinguish destructive styling, and support undo where feasible. Request confirmation when impact is significant or irreversible. Explain consequences in human language.

## 7. Complete state specification
For every important feature include, as applicable:
- Initial/default and populated state.
- Hover, focus, pressed, selected, disabled.
- Loading or skeleton, including slow operation and concurrent submissions.
- Empty (first use) vs no search results (distinct messages and actions).
- Validation error, request error, partial failure and retry.
- Success feedback with next step, not gratuitous celebration.
- Offline/connection loss; permission required/denied; expired session.
- Long text, missing images, overflowing numbers, localization, zoom, small viewports.
- Unsaved edits, recovery paths, undo, and confirmation as needed.
Never render a permanently inert control or pretend an operation succeeded when it has not.

## 8. Motion, feedback and depth
- Immediate feedback for interactions; visible state changes should feel causal, not theatrical.
- Typical small transitions ~150–300 ms; choose by distance, platform and task. Use restrained easing/spring when appropriate.
- Prefer transforms and opacity where possible; avoid layout shift and excessive motion.
- Respect reduced motion settings and do not hide functional status solely in animation.
- Blur/glass/translucency are permitted only when they clarify layering, separate floating controls, and preserve contrast.
- No loading indicators for operations that have already completed; do not manufacture delays for perceived polish.

## 9. Accessibility standards
- For web, target WCAG 2.2 AA; verify relevant criteria instead of treating numerical values as blanket guarantees.
- Text contrast typically at least 4.5:1 for normal and 3:1 for large text; test actual rendered colors. UI graphical indicators may require non-text contrast of 3:1 when applicable.
- WCAG 2.2 AA pointer-target minimum is 24×24 CSS px with exceptions; aim for more generous practical hit areas (often around 44×44 logical pt on iOS, following platform guidance).
- Provide visible keyboard focus, logical focus order, accessible labels, roles, states, landmarks and semantic structure.
- Support keyboard-only use, screen readers, zoom/reflow, text scaling, reduced motion and high-contrast preferences when applicable.
- No hover-only essential content. Do not communicate errors or selected states only with color.
- Consider cognitive load: plain language, predictable layouts, clear instructions and forgiveness.
- Test with real accessibility tools and assistive technology where available; do not claim compliance based on aesthetics.

## 10. Responsive and platform-native behavior
- Design for content and interaction modes, not merely fixed device widths.
- Test narrow phones, large phones, tablets, desktops, landscape, zoom and reduced viewport height.
- Respect safe areas, browser chrome, notches, virtual keyboard, pointer vs touch, and navigation expectations.
- Avoid horizontal scrolling for prose or forms; structured dense tables may scroll when necessary and discoverable.
- On touch screens, hit targets and spacing matter more than hover aesthetics.
- On desktop, take advantage of available space, keyboard, multi-column views and clear density.
- Respect Apple, Android, Windows and web conventions respectively; do not force an iPhone UI onto every platform.

## 11. Content and UX writing
- Speak plainly, specifically and contextually. Prefer user verbs over system jargon.
- Examples: `Create project`, `Couldn't save changes. Try again.`, `No projects yet`, `Invite team member`.
- Explain what happened, why when known, and what the user can do next. Avoid blaming users.
- Do not use fabricated friendly filler, repetitive tutorials, excessive exclamation marks, emojis or vague calls to action.
- Use progressive guidance only where the interface genuinely requires learning.
- Make privacy, permission and purchase language precise and non-manipulative. Avoid dark patterns, surprise charges, prechecked consent or misleading urgency.

## 12. Speed, engineering quality and reliability
- Implement semantic, reusable components and centralized tokens; prefer mature platform primitives and appropriate existing libraries.
- Optimize images, fonts and bundle sizes; avoid unnecessary JavaScript and heavy animation dependencies.
- Preserve layout space to reduce shifts. Give fast acknowledgement; use optimistic UI only when safe and reversible.
- Cover loading, cancellation, race conditions, failure recovery and retries. Never silently discard user work.
- Avoid inaccessible custom widgets where a native control would suffice.
- Meet platform security/privacy expectations; request minimum permissions and protect sensitive data.
- Treat production readiness as functional behavior, not a polished screenshot.

## 13. Domain-specific adaptation
- **Marketing sites:** communicate differentiation clearly, authentic evidence only, restrained CTA structure, no invented endorsements.
- **Dashboards:** prioritize decisions and exceptions; no meaningless KPI tile farms; data provenance, timeframe and units must be clear.
- **Productivity tools:** reduce repeated actions, preserve context, include power-user shortcuts and reliable save feedback.
- **E-commerce:** price, availability, variants, shipping, returns and checkout clarity; no deceptive urgency.
- **Financial/health/critical workflows:** emphasize clarity, provenance, confirmation, error prevention, traceability and privacy over novelty.
- **Developer tools:** support density, monospaced data where needed, keyboard operations, and informative errors.
- **Education:** optimize for comprehension, progress, attention and readable instructional content rather than noisy gamification.

## 14. Workflow for an agent
1. **Discover:** determine user/task/platform/content/constraints. State assumptions only if consequential.
2. **Architect:** outline routes, flows, information hierarchy and expected states.
3. **Choose design direction:** define 3–5 explicit visual traits; ensure a unique product voice and remove stereotypical AI aesthetics.
4. **Define tokens:** colors, typography, spacing, radii, borders, motion, and responsive rules.
5. **Build:** implement semantic components, functional controls and meaningful states. Use realistic content or clearly labeled mock data.
6. **Audit:** review visual hierarchy, copy, navigation, accessibility, responsive behavior, reliability and anti-slop constraints.
7. **Verify:** run actual checks where tools allow, inspect narrow and wide viewports, and report gaps honestly.
8. **Refine:** remove unneeded decoration, complexity and duplicated UI. Improve the task flow before adding flair.

## 15. Mandatory final quality gates
Before delivering, answer each question. Fix failures rather than simply listing them.

### Utility
- Is the main user goal obvious within a few seconds?
- Can the user complete the primary task without guessing?
- Is navigation discoverable and predictable?
- Are errors recoverable and unsaved changes protected?

### Craft
- Are spacing, alignment, typography and surfaces consistent?
- Is the visual hierarchy clear without excessive containers?
- Is the visual identity appropriate and distinctive for this product?
- Can any decorative element be removed without losing function or identity? If yes, consider removing it.

### Non-AI-slop
- No generic gradient/glow/glass/card-soup defaults?
- No fake metrics, fake testimonials, invented domain data or irrelevant icons?
- No robotic copy, repeated empty promises or unnecessary CTAs?
- No meaningless animations or loading theatre?
- No UI elements with misleading affordances or fake interactions?

### Inclusive production readiness
- Keyboard, focus, accessible labels, contrast and text scaling checked?
- Loading, empty, error, success, disabled and edge states covered?
- Works across reasonable screen sizes and input types?
- Responsive and performant without unnecessary libraries?
- Reported verified behavior accurately, distinguishing mock data from real integrations?

## Deliverable expectations
For design-only requests: provide a task flow, screen structure, token direction, key component/state specs and notable trade-offs at the appropriate level of detail.
For coding requests: provide working code with functional interactions and responsive/accessibility behavior, along with setup information and any honest limitations.
For critique: give prioritized findings (`critical`, `major`, `minor`), user impact, recommended changes, and concrete examples.
For ambiguous requests: choose a thoughtful product-specific default; avoid dumping an arbitrary generic dashboard.

## Authoritative references (consult if current verification is available)
- Apple Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- Apple Design Resources: https://developer.apple.com/design/resources/
- WCAG 2.2: https://www.w3.org/TR/WCAG22/
- WAI-ARIA Authoring Practices Guide: https://www.w3.org/WAI/ARIA/apg/

## Final principle
**Do not design to look impressive in an AI-generated screenshot. Design to make real work feel effortless, accurate, comfortable and distinctly human.**
