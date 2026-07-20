# Authentication visual validation notes

- Binding reference: `flow-auth-entry-v1`
- Source board: 1672×941, EN/LTR composite
- Implemented: third phone (mobile) and fourth phone (six-digit PIN)
- Target viewports: 360×800 and 412×915 logical portrait
- Automated: EN/LTR, FA/RTL, PS/RTL, 100%/200% text, reduced motion
- Chrome runtime: the same-origin proxy removed the CORS rejection; an
  authorized login reached the confirmed protected placeholder in Chrome 150
- Independent live validation (20 July 2026): login 200, device-session
  confirmation 200, browser-refresh rotation 200, restored confirmation 200,
  logout 200, and final refresh remained unauthenticated without another
  refresh request
- Safe implementation evidence:
  `implementation/restored-authenticated-412x915.png`; the placeholder contains
  no customer or session identifiers
- Runtime issue corrected: login-page disposal could cancel an already
  unconfirmed session and notify the router while its tree was locked; the
  controller now ignores cancellation after leaving unauthenticated state
- Hot reload: passed; authenticated placeholder rendered after reload
- Logout: backend 200 through the proxy before the smoke browser closed
- Matching-viewport mobile/PIN screenshots: captured at 412×915 for EN/LTR and
  FA/RTL under `implementation/`; all use empty or safely masked values
- Invalid-login UI capture: pending; the single dummy transport request
  returned nested `UNAUTHORIZED` with matching header/body trace ID, while the
  localized widget state remains covered by automated tests

## Recorded differences

1. No repository brand-mark asset exists. A token-colored decorative
   security/bank mark is temporary.
2. Create Account, Need help, Forgot PIN, and biometric controls are omitted
   because no first-slice route/security contract exists.
3. Mobile accepts the backend-authoritative ten digits without implicit `+93`.
4. Mobile is masked on the PIN screen because the identifier is sensitive.
5. PIN lock has no countdown or remaining-attempt count because the backend
   returns neither.
6. Root back/language, divider, Create Account, and Need help remain omitted;
   the measured composition preserves their region without presenting dead
   actions.
7. PIN keypad geometry, dial labels, action placement, indicators, safe-area
   rhythm, and loading placement now follow the measured reference.
8. Mobile uses an external label, country indicator, intentional focus border,
   measured field/action placement, and bottom security reassurance. Exact
   `+93` editable composition remains contract-limited.

## Runtime/accessibility findings

- The live browser exposed a narrow-height overflow in the authenticated
  placeholder during logout. The placeholder now uses a constrained scrollable
  composition; a 206×401 regression test covers the observed effective
  viewport.
- Chrome runtime logs contained only sanitized method, path, status, and trace
  ID. There was no CORS error or credential/body/token/authorization log. The
  one rendering exception was corrected and covered by automated gates; the
  authorized account was not signed in a second time merely to repeat it.
- Chrome development runtime and hot reload passed without another live login.
- Android TalkBack and language-owner review remain pending. The installed
  Pixel 2/API 28 emulator did not attach, and Flutter doctor reports missing
  Android command-line tools and unknown license status.

The measured correction pass closes the material field, spacing, keypad,
navigation, and action-placement drift identified by independent review.
`comparison/notes.md` records the category decisions. The final visual decision
is **Blocked by missing approved asset** because the brand mark and the
contract-driven deviations still require external approval; the reference
therefore stays `in-progress`.
