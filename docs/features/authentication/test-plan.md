# Authentication test plan

Tests are required before/during implementation.

## Implemented automated coverage — 19 July 2026

- `test/authentication_contract_test.dart`: DTO/envelope/trace/failure,
  production URL rejection, and redaction.
- `test/authentication_api_test.dart`: exact paths, methods, bodies, trace,
  authorization, optional-header omission, and typed failures.
- `test/authentication_session_controller_test.dart`: secure persistence,
  rotation concurrency, stale completion, corrupt restore, state transitions,
  restrictions, and local-first logout.
- `test/authentication_widget_router_test.dart`: mobile/PIN behavior,
  invalid credentials, semantics, EN/FA/PS direction and 200% scale, bootstrap,
  restored protected routing, logout, and terminal recovery.

Golden baselines remain deferred. Runtime screenshot comparison and Android
TalkBack smoke remain manual Phase E evidence.

## Chrome runtime evidence — 19 July 2026

The development build launched successfully in Chrome 150 with
`APP_ENV=development` and `API_BASE_URL=http://74.118.81.141`. Mobile entry,
six-digit PIN entry, automatic guarded submission, and the safe offline error
state rendered without a Flutter runtime exception. The browser refused the
login request at CORS preflight because the deployed API response did not
include `Access-Control-Allow-Origin` for the generated `localhost` origin.
The request therefore did not reach the login controller, and no live
credential/error-envelope result is claimed from Chrome.

Console and Flutter-run evidence contained only the method, endpoint path,
generated trace ID, and the browser CORS error; no mobile number, PIN,
authorization value, or token appeared. No further invalid login was attempted.
Matching-viewport acceptance, runtime FA/PS switching, 200% runtime inspection,
Android TalkBack, and authenticated runtime flow remain pending; their
automated widget coverage is listed above.

## DTO and mapper tests

- Parse a valid login/refresh `ApiResponse<JwtResponse>` including both device
  ID aliases and nullable/empty role cases exactly as decided.
- Reject non-object envelope, `success: false` on success path, null/missing
  `data`, missing/blank token/refresh/type, malformed UUID, wrong field types,
  and partial response without persisting anything.
- Prove no expiry field is required or invented; if JWT `exp` scheduling is
  approved, test malformed/missing claim and clock skew without trusting claims
  for authorization.
- Parse failure `error.code`, validation details where relevant,
  `meta.traceId`, response `X-Trace-Id`, and unknown code fallback.
- Map `PIN_INVALID`, `PIN_LOCKED`, `USER_SUSPENDED`, `USER_LOCKED`,
  `USER_CLOSED`, `REFRESH_TOKEN_REUSED`, `REFRESH_TOKEN_EXPIRED`,
  `SESSION_REVOKED`, `SESSION_EXPIRED`, generic unauthorized, validation,
  offline, timeout, and 5xx.
- Normalize accepted mobile presentation into exact ten-digit serialization;
  reject empty/short/long/unsupported digit forms per the accepted contract.

## Repository and API tests

- Assert exact method/path/body and `Accept`/`Content-Type` for login/refresh;
  protected logout/devices include one bearer header.
- Assert `X-Trace-Id` capture and that optional device headers are absent until
  approved.
- Pass and honor `CancelToken`; cancelled/stale login cannot persist or
  navigate.
- Guard duplicate login submission.
- Invalid credentials, lock, suspended, locked/blocked, closed, validation, and
  generic unauthorized map without backend copy/account enumeration.
- Refresh success replaces both tokens and session ID; malformed success keeps
  no partial new state.
- Refresh reuse/expiry/revocation and uncertain network response are terminal;
  old token is never retried.
- Logout makes one request, handles 200/401/403/network/timeout, and always
  invokes local cleanup.
- Session confirmation matches current session ID and `ACTIVE`; historical,
  missing, malformed, and restricted results follow contract.

## Session infrastructure tests

- Restore with no credential → unauthenticated.
- Valid credential → one refresh → confirmation → authenticated.
- Corrupt/blank storage → named-key cleanup and unauthenticated.
- Secure-store read/write/delete failure maps safely without exposing data.
- Concurrent protected 401s invoke one refresh and each eligible request
  retries at most once with new access token.
- Logout during login/refresh invalidates generation; late result is ignored.
- Refresh failure/reuse/revocation clears access, refresh, session/user state,
  cancels protected work, and emits one terminal event.
- Current logout and local-only logout failure cleanup are complete.
- Logger/redactor tests cover authorization, PIN/mobile, token fields, device
  headers, trace metadata, nested envelopes, and exception strings.

## State/controller tests

- Cover every allowed state-machine transition and reject impossible
  combinations.
- Mobile → PIN → submitting → unconfirmed → confirmed happy path.
- Invalid credentials clear PIN/retain mobile; network/server failure is
  recoverable only explicitly; restrictions are terminal.
- Threshold attempt returning `PIN_INVALID` does not invent lock; subsequent
  `PIN_LOCKED` enters locked state with no countdown.
- Cancellation and repeated actions cannot produce duplicate requests.
- Lifecycle/privacy event clears PIN.

## Router tests

- Bootstrap holds routing while restoring.
- Unauthenticated protected visit redirects once to login.
- Confirmed session accesses protected placeholder and visiting login redirects
  once to placeholder.
- Unconfirmed/refreshing states do not expose protected content or loop.
- Session expiry/revocation/reuse and logout leave protected branch only after
  cleanup.
- Unknown/corrupt state becomes unauthenticated.
- Allowlisted deep link resumes only after confirmation; unsafe/unknown link is
  discarded; no sensitive value enters URL.
- Development gallery behavior and production exclusion remain unchanged.

## Widget tests

- Mobile default, focused, required/invalid, valid, disabled/advancing, and
  keyboard submit.
- PIN default, partial, six digits, delete, obscured semantics, submission,
  loading/disabled, invalid credentials, and secret clearing.
- Offline, server unavailable, temporary lock, generic restriction with each
  backend subtype, and session expired.
- No unsupported forgot PIN/signup/help/biometric action is accidentally
  tappable.
- EN/LTR, FA/RTL, PS/RTL with reviewed long copy; controlled-LTR mobile value.
- 100%/200% text, 360×800 and 412×915 plus wide constrained layout, keyboard
  insets, safe areas, no overflow.
- Semantics titles/labels/errors/live regions, focus order/error focus, visible
  focus, 48×48 targets, reduced motion, and color-independent states.

## Visual review

For each implemented contract:

1. resolve and open the exact approved reference;
2. record board dimensions, target logical viewport/device class, OS text scale,
   locale, direction, keyboard, and state;
3. capture implementation under
   `artifacts/visual-validation/authentication/<reference-id>/implementation/`;
4. compare overall geometry, safe area, spacing, alignment, typography, color,
   radii, icons, fields, button states, fixed/scroll behavior, and keyboard;
5. inspect EN/FA/PS, RTL, 200%, narrow/wide, and reduced motion;
6. record every variance in `notes.md` and link an approved deviation where
   required;
7. decide Accept, Accept with documented deviation, Reject, Blocked by
   contract/accessibility, or Reference unclear.

Do not mark a composite reference implemented when only one phone region is
complete.
