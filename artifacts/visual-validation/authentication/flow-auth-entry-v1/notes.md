# Authentication visual validation notes

- Binding reference: `flow-auth-entry-v1`
- Source board: 1672×941, EN/LTR composite
- Implemented: third phone (mobile) and fourth phone (six-digit PIN)
- Target viewports: 360×800 and 412×915 logical portrait
- Automated: EN/LTR, FA/RTL, PS/RTL, 100%/200% text, reduced motion
- Chrome runtime: the same-origin proxy removed the CORS rejection; an
  authorized login reached the confirmed protected placeholder in Chrome 150
- Runtime issue corrected: login-page disposal could cancel an already
  unconfirmed session and notify the router while its tree was locked; the
  controller now ignores cancellation after leaving unauthenticated state
- Hot reload: passed; authenticated placeholder rendered after reload
- Logout: backend 200 through the proxy before the smoke browser closed
- Matching-viewport screenshot: pending (the runtime capture included docked
  browser developer tools and is not an acceptance artifact)
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

Product visual approval and matching-viewport comparison remain open; the
reference is `in-progress`.
