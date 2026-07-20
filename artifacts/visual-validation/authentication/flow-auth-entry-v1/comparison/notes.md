# `flow-auth-entry-v1` comparison notes

## Evidence

- Binding reference: `flow-auth-entry-v1`
- Approved board:
  `design-references/flows/authentication/customer-authentication-entry-states-en-ltr-v1.png`
- Board dimensions: 1672×941 pixels
- Comparison viewport: 412×915 logical pixels, portrait, 100% text
- Implementation screenshots:
  - `../implementation/mobile-entry-412x915-en-ltr.png`
  - `../implementation/pin-entry-412x915-en-ltr.png`
  - `../implementation/mobile-entry-412x915-fa-rtl.png`
  - `../implementation/pin-entry-412x915-fa-rtl.png`
- Reproducible capture:
  `flutter --no-version-check test
  test/authentication_visual_capture_test.dart
  --dart-define=CAPTURE_AUTH_VISUALS=true`
- All four evidence files are 412×915 RGBA PNGs. They contain an empty mobile
  field or a masked synthetic mobile context and no entered PIN, token,
  developer tool, request/response body, or session/account identifier.

## Decisions by category

| Category | Comparison decision |
|---|---|
| Overall composition | Mobile and PIN now preserve the approved centered secure-entry hierarchy, measured vertical landmarks, full-width primary region, six-indicator row, action row, and keypad grouping. Unsupported product regions remain intentionally absent. |
| Geometry | Mobile: approved seal begins near y=145 in an 88px aspect-preserving box, title near y=264, field near y=397, Continue near y=484, reassurance near y=779. PIN: safe header near y=56, separate security mark near y=105, title near y=200, indicators near y=341, action row near y=397, keypad near y=468. Directional sides are 16px at 412px. |
| Spacing | Screen-specific measured gaps reproduce the source-board proportions at 412×915. Constraint-driven scrolling preserves the hierarchy at 360×800, 390×844, 430×932, keyboard transitions, and 200% text. |
| Typography | Bundled Inter and Noto Naskh Arabic are used. Title/body hierarchy and dial-letter labels match the binding flow. Platform font rasterization is accepted as platform tolerance. |
| Color | The approved standard green/white PNG is used unchanged on the light authentication surface. Repository semantic institutional green, off-white background, surface, outline, muted, and error colors remain in the surrounding UI. The white-backed logo variant is reserved for dark/green surfaces. |
| Radius | Field and action use the shared 12px radius. Keypad keys use 12px rounded rectangles with a light outline and low elevation. Focus is a single intentional 2px green border; focused errors use a single 2px error border. |
| Icons and branding | The mobile primary brand region uses the approved IBA PNG through shared `IbaBrandMark`; no temporary primary-brand icon remains. The PIN shield is intentionally retained as a separate security concept. Direction-aware back, country indicator, and backspace placement match the approved intent. |
| State | Local field error remains associated with mobile input. PIN invalid/offline/server feedback is localized and announced. Submitting keeps layout stable, disables the keypad/actions, clears the PIN immediately, and uses compact in-place loading; no branded success transition is invented. |
| RTL | Dari screenshot evidence mirrors header and supported Change number placement. Mobile input, masked country/mobile context, indicators, numeric keypad, digit order, and delete column remain controlled LTR. Pashto follows the same runtime direction and is covered at 200% by widget tests. |
| Accessibility | Interactive controls remain at least 48×48; keypad keys are approximately 121×64 at 412px. Screen/field/keypad/delete/loading/error semantics remain localized. Entered PIN values are excluded from semantics. Scroll reflow keeps controls reachable. |

## Remaining deviations

1. `DDR-AUTH-ENTRY-01` is approved and resolved: the official existing IBA PNG
   replaces the temporary primary mark, with byte integrity documented in
   `assets/branding/README.md`.
2. Create Account, Need help, Forgot PIN, biometric, OTP-first, countdown, and
   attempt-counter treatments remain omitted/deferred under the approved
   unsupported-action decision (`DDR-AUTH-ENTRY-02`).
3. The exact `+93` plus national-number field composition is not shown as one
   editable value. The accepted backend contract requires the unchanged
   ten-digit local value, so the screen uses a non-interactive country indicator
   and controlled-LTR ten-digit input (`DDR-AUTH-ENTRY-03`).
4. The PIN screen masks the synthetic mobile context instead of exposing the
   full number (`DDR-AUTH-ENTRY-04`).
5. Dari and Pashto linguistic approval remains external to this implementation.
6. Android TalkBack runtime could not be completed: the installed emulator did
   not attach through ADB, and Flutter doctor reports missing Android
   command-line tools and unknown license status. Automated semantics coverage
   remains green.

## Final visual decision

**Accept with documented deviation.**

The branding region is resolved with the approved byte-preserved asset, and
the four matching-viewport screenshots confirm unchanged composition, scale,
clear space, light-surface contrast, and RTL balance. The implemented mobile
and six-digit PIN regions are visually accepted with approved
`DDR-AUTH-ENTRY-02`, `DDR-AUTH-ENTRY-03`, and `DDR-AUTH-ENTRY-04`. Composite
splash/language/biometric regions remain deferred and are not claimed as
implemented. Android TalkBack runtime and Dari/Pashto linguistic review remain
open, accurately reported limitations; automated semantics, RTL, and 200%
coverage pass.
