---
name: iba-flutter-design-system
description: Implement repository-compliant IBA E-Wallet Flutter UI using approved images, semantic tokens, shared Iba components, state patterns, localization, RTL, accessibility, privacy, motion, and tests. Mandatory when a task references an image, mockup, screenshot, approved screen, design-references, visual fidelity, pixel-perfect work, or any UI/component/state work.
---

# IBA Flutter design-system workflow

1. Read `../../AGENTS.md`, `../../docs/design-system.md`, and
   `../../docs/agent-guidelines/design-system-rules.md`.
2. Read the design-reference manifest, resolve the ID, open the exact image,
   inspect related component and flow references, and record its viewport.
3. Inspect `../../lib/core/theme/`, `../../lib/design_system/`, the component
   gallery, and relevant feature/test code. Do not assume a business screen
   exists.
4. Read the references relevant to the change:
   - tokens/components: [design tokens](references/design-tokens.md) and
     [components](references/components.md);
   - screens/states: [screen patterns](references/screen-patterns.md) and
     [states and feedback](references/states-and-feedback.md);
   - forms: [forms and validation](references/forms-and-validation.md);
   - money UI: [financial patterns](references/financial-patterns.md);
   - quality: [accessibility](references/accessibility.md),
     [localization/RTL](references/localization-rtl.md), and
     [security/privacy](references/security-and-privacy.md);
   - interaction/copy: [motion and haptics](references/motion-and-haptics.md)
     and [UX writing](references/ux-writing.md).
   For approved images also read [screen governance](references/approved-screen-governance.md),
   [pixel review](references/pixel-fidelity-review.md),
   [responsive adaptation](references/responsive-reference-adaptation.md), and
   [deviations](references/visual-deviation-process.md).
5. Select a screen pattern. Define entry/data source, all applicable states,
   responsive reflow, RTL/mixed-direction behavior, accessibility/focus, and
   financial privacy before editing.
   Authentication UI may not begin until its backend contract, Visual Reference
   Contract, state machine, security contract, and contract gaps are documented.
6. Map every visible element to `Iba*` components and identify system gaps.
   Reuse an existing component when sufficient. Extend a shared component when
   the variation is broadly reusable. Compose shared components for a
   feature-specific arrangement. Never fork shared components locally or add a
   one-screen-only shared abstraction without genuine reuse.
7. Implement without visual reinterpretation, using semantic tokens, theme,
   generated localized text, directional
   layout, masked data, and explicit server-authoritative financial states.
8. Compare at the reference viewport and record every deviation.
9. Add widget tests for behavior, states, RTL, semantics, and 200% text scale as
   applicable. Validate English, Dari, and Pashto at 100% and 200%, responsive
   sizes, keyboard/focus, and reduced motion.
10. Decide whether a broadly reusable variation belongs in the design system and
   gallery. Record any contract/design-system gap instead of bypassing it.
11. Validate localization, RTL, accessibility, and responsiveness.
12. Update the design-reference implementation status.

Pixel-perfect means preserving the approved composition and visual
relationships. It does not permit inaccessible text, insecure behavior, false
transaction states, or broken responsive behavior. Necessary adaptations must
remain visually faithful and be documented.

For completion, report the screen pattern, reused/extended components, new
tokens, implemented states, RTL and accessibility evidence, tests, and runtime
screenshots/smoke evidence when available.
