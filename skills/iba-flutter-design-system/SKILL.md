---
name: iba-flutter-design-system
description: Implement repository-compliant IBA E-Wallet Flutter UI using its semantic tokens, shared Iba components, state patterns, financial-safety language, localization, RTL, accessibility, privacy, motion, and widget-test requirements. Use whenever creating or modifying screens, reusable widgets, forms, navigation, dialogs, bottom sheets, cards, account/balance UI, financial flows, receipts, loading/error/empty states, responsive layouts, localized or RTL behavior, accessibility, motion, or haptics.
---

# IBA Flutter design-system workflow

1. Read `../../AGENTS.md`, `../../docs/design-system.md`, and
   `../../docs/agent-guidelines/design-system-rules.md`.
2. Inspect `../../lib/core/theme/`, `../../lib/design_system/`, the component
   gallery, and relevant feature/test code. Do not assume a business screen
   exists.
3. Read the references relevant to the change:
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
4. Select a screen pattern. Define entry/data source, all applicable states,
   responsive reflow, RTL/mixed-direction behavior, accessibility/focus, and
   financial privacy before editing.
5. Reuse an existing component when sufficient. Extend a shared component when
   the variation is broadly reusable. Compose shared components for a
   feature-specific arrangement. Never fork shared components locally or add a
   one-screen-only shared abstraction without genuine reuse.
6. Implement with semantic tokens, theme, generated localized text, directional
   layout, masked data, and explicit server-authoritative financial states.
7. Add widget tests for behavior, states, RTL, semantics, and 200% text scale as
   applicable. Validate English, Dari, and Pashto at 100% and 200%, responsive
   sizes, keyboard/focus, and reduced motion.
8. Decide whether a broadly reusable variation belongs in the design system and
   gallery. Record any contract/design-system gap instead of bypassing it.

For completion, report the screen pattern, reused/extended components, new
tokens, implemented states, RTL and accessibility evidence, tests, and runtime
screenshots/smoke evidence when available.
