# UI accessibility checks

Apply `docs/agent-guidelines/accessibility-rules.md`.

- Verify 48×48 targets, localized names/roles, contrast, visible focus, and
  logical keyboard traversal.
- Verify status/error meaning without color, icon, vibration, or motion alone.
- Test field error association, modal focus entry/return, and non-repeating
  live announcements.
- Test narrow reflow and 200% scale without clipped actions or prose.
- Give amounts explicit amount/currency semantics and keep masked digits hidden.
- Honor `MediaQuery.disableAnimationsOf(context)`.

Add widget semantics/focus tests where stable and runtime screen-reader/keyboard
smoke evidence for high-risk screens.
