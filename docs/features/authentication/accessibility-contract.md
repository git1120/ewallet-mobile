# Authentication accessibility contract

## Screen and focus semantics

- Each state exposes one localized semantic screen title. On route/state
  replacement, focus moves to that title or first actionable error, not an
  arbitrary icon.
- Login traversal is logical: title/context → mobile field → primary action →
  supported secondary actions; PIN state is title/context → secure input/keypad
  → supported actions. RTL mirrors visual direction without reversing task
  order unpredictably.
- Do not autofocus the mobile field by default. This prevents immediate
  keyboard obstruction and gives assistive technology the screen context.
  Product/user testing may approve autofocus as a recorded change.
- Keyboard Next/Submit invokes the same guarded action as the primary button.
  Duplicate keyboard/button submission is impossible.
- Web validation supports Tab/Shift+Tab, Enter/Space activation, visible focus,
  and no keyboard trap. Web validation is not production-web approval.

## Fields and validation

- Mobile and PIN have explicit localized labels; placeholders do not replace
  labels. Required/invalid state is associated with the field/task.
- PIN semantics identify a secure six-digit PIN field but never announce entered
  digits, dot count as credential content, or expose it through value semantics.
- If a visibility control is retained in a shared PIN field, it has a localized
  stateful name (“Show PIN”/“Hide PIN”), 48×48 target, and does not expose PIN
  in logs/screenshots. The approved entry board itself uses dots/keypad and does
  not require a visibility action.
- Invalid mobile focuses the mobile field and announces its error once. Invalid
  credentials clear PIN, focus secure entry, and announce a non-enumerating
  form error once.
- Color is never the only error/restriction signal: use icon/shape, text, and
  semantics while preserving approved colors.

## Loading and state announcements

- “Signing in,” “Checking your secure session,” and “Logging out” are polite
  live announcements emitted once per state transition. Decorative spinners
  are excluded from semantics.
- Offline, server unavailable, temporary lock, restriction, and session expiry
  move focus to a concise title and expose the valid next action.
- Concurrent 401 failures produce one refresh announcement and at most one
  terminal session announcement.
- Reduced-motion mode uses zero-duration/in-place state changes while preserving
  equivalent status meaning. No haptic or animation is the only feedback.

## Geometry, scale, contrast, and reflow

- Every interactive target, including keypad digits, delete, back, language,
  PIN visibility, and text actions, is at least 48×48 logical pixels even if a
  supporting board mentions 44×44.
- Text and meaningful icons meet accessible contrast in default, focus,
  disabled, error, and restricted states. Visible focus meets contrast against
  both white and tinted surfaces.
- At 200% text scaling, titles, instructions, errors, reassurance, and actions
  neither clip nor overlap. Vertical scrolling is allowed; prose never requires
  horizontal scrolling. PIN indicators/keypad remain operable without shrinking
  targets.
- Narrow devices, system safe areas, and on-screen keyboard preserve access to
  the focused field and primary action. Wide layouts constrain the mobile
  composition rather than creating excessively long reading lines.
- EN, FA, and PS receive semantics, focus, 100%/200%, and narrow/wide tests.

## Runtime review

Widget tests cover stable semantics/focus behavior. Phase E also performs
Android TalkBack and Chrome keyboard smoke checks. iOS VoiceOver validation
must not be claimed because no iOS runner exists.
