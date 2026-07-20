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
| Geometry | Mobile: mark begins near y=145, title near y=264, field near y=397, Continue near y=484, reassurance near y=779. PIN: safe header near y=56, mark near y=105, title near y=200, indicators near y=341, action row near y=397, keypad near y=468. Directional sides are 16px at 412px. |
| Spacing | Screen-specific measured gaps reproduce the source-board proportions at 412×915. Constraint-driven scrolling preserves the hierarchy at 360×800, 390×844, 430×932, keyboard transitions, and 200% text. |
| Typography | Bundled Inter and Noto Naskh Arabic are used. Title/body hierarchy and dial-letter labels match the binding flow. Platform font rasterization is accepted as platform tolerance. |
| Color | Repository semantic institutional green, gold, off-white background, surface, outline, muted, and error colors are used. The security reassurance now uses the green security semantic rather than an unrelated blue information treatment. |
| Radius | Field and action use the shared 12px radius. Keypad keys use 12px rounded rectangles with a light outline and low elevation. Focus is a single intentional 2px green border; focused errors use a single 2px error border. |
| Icons | PIN shield, direction-aware back, country indicator, and backspace placement match the approved intent. The mobile brand artwork remains a temporary standard security icon because no approved brand asset exists. |
| State | Local field error remains associated with mobile input. PIN invalid/offline/server feedback is localized and announced. Submitting keeps layout stable, disables the keypad/actions, clears the PIN immediately, and uses compact in-place loading; no branded success transition is invented. |
| RTL | Dari screenshot evidence mirrors header and supported Change number placement. Mobile input, masked country/mobile context, indicators, numeric keypad, digit order, and delete column remain controlled LTR. Pashto follows the same runtime direction and is covered at 200% by widget tests. |
| Accessibility | Interactive controls remain at least 48×48; keypad keys are approximately 121×64 at 412px. Screen/field/keypad/delete/loading/error semantics remain localized. Entered PIN values are excluded from semantics. Scroll reflow keeps controls reachable. |

## Remaining deviations

1. The approved gold brand artwork cannot be reproduced because the repository
   contains no approved image/vector asset. The temporary geometric security
   mark is documented in `../fidelity-audit.md` as `DDR-AUTH-ENTRY-01`.
2. Create Account, Need help, Forgot PIN, and biometric actions remain absent
   because their routes/API/security contracts are outside this slice
   (`DDR-AUTH-ENTRY-02`).
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

**Blocked by missing approved asset.**

The measured layout, shared components, responsive behavior, RTL, and
accessibility corrections are implementation-ready and materially closer to
the approved reference. The flow is not marked visually accepted because the
brand asset and product/design approval for the recorded contract-driven
deviations remain outstanding.
