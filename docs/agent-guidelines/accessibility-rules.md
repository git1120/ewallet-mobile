# Accessibility rules

- Interactive targets are at least 48×48 logical pixels.
- Give controls meaningful localized names and semantic roles. Decorative
  icons are excluded; icon-only controls require labels/tooltips.
- Status, errors, and required action are communicated through text/semantics
  and shape/icon as appropriate, never color or vibration alone.
- Maintain accessible contrast and visible focus. Support logical traversal and
  keyboard activation on web.
- Associate errors/help with fields, focus the first actionable validation
  error, and announce loading, errors, processing, pending, and completion
  without repeatedly flooding live regions.
- Trap and restore focus appropriately for dialogs. Bottom sheets receive
  initial meaningful focus and restore it to their trigger when dismissed.
- Support screen readers, 200% text scaling, narrow responsive reflow, and
  large translations without clipping or horizontal scrolling of prose.
- Respect `MediaQuery.disableAnimationsOf(context)` and provide equivalent
  meaning without motion or haptics.
- Financial amount semantics must speak amount and currency unambiguously;
  masked identifiers must not expose hidden digits.

Validate semantics and focus behavior with widget tests where practical, then
perform a runtime keyboard/screen-reader smoke check for high-risk flows.
