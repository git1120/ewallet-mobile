# Authentication visual validation notes

- Binding reference: `flow-auth-entry-v1`
- Source board: 1672×941, EN/LTR composite
- Implemented: third phone (mobile) and fourth phone (six-digit PIN)
- Target viewports: 360×800 and 412×915 logical portrait
- Automated: EN/LTR, FA/RTL, PS/RTL, 100%/200% text, reduced motion
- Chrome runtime: mobile/PIN flow and safe offline state rendered on Chrome
  150 without a Flutter runtime exception
- Matching-viewport screenshot: pending (the runtime capture included docked
  browser developer tools and is not an acceptance artifact)
- Live browser request: blocked by the deployed API CORS preflight for the
  generated `localhost` origin; no backend login result is claimed

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
