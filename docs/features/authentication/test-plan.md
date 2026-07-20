# Authentication test plan

Tests are required before/during implementation.

## Implemented automated coverage — 19 July 2026

- `test/authentication_contract_test.dart`: DTO/envelope/trace/failure,
  production URL rejection, and redaction.
- `test/authentication_api_test.dart`: exact paths, methods, bodies, trace,
  authorization, optional-header omission, and typed failures.
- `test/authentication_session_controller_test.dart`: secure persistence,
  rotation concurrency, stale completion, corrupt restore, state transitions,
  generic and specific restrictions, confirmation cancellation, and local-first
  logout.
- `test/authentication_widget_router_test.dart`: mobile/PIN behavior,
  invalid credentials, semantics, EN/FA/PS direction and 200% scale, bootstrap,
  immediate completed-PIN clearing, restored protected routing, logout, and
  terminal recovery.

Golden baselines remain deferred. Runtime screenshot comparison and Android
TalkBack smoke remain manual Phase E evidence.

## Measured visual-fidelity evidence — 20 July 2026

- Added geometry and reachability coverage at 360×800, 390×844, 412×915, and
  430×932.
- Added exact 412px directional-side, six-indicator, 11-key, 64px key-height,
  delete-column, controlled-LTR field, external-label/country-indicator, and
  single-focus-border assertions.
- Expanded Dari/Pashto 200% coverage through the PIN state and confirmed the
  numeric keypad remains stable.
- Added a normally skipped, opt-in renderer in
  `test/authentication_visual_capture_test.dart`. It loads repository fonts and
  icons, uses an in-memory secure-store replacement, and produces the four
  required 412×915 identifier-safe PNGs only when
  `CAPTURE_AUTH_VISUALS=true`.
- Chrome launched with `APP_ENV=development`, loaded `web_dev_config.yaml`, and
  hot reload completed in 152 ms without a runtime exception or another live
  login.
- Android runtime/TalkBack remains blocked in this environment: the installed
  Pixel 2/API 28 emulator launch returned but no device attached through ADB;
  Flutter doctor reports missing Android command-line tools and unknown license
  status.

## Chrome and proxy runtime evidence — 19 July 2026

Chrome 150 launched with only `APP_ENV=development`; Flutter loaded
`web_dev_config.yaml` and served `http://127.0.0.1:8080`. A single invalid
dummy login sent to the same-origin `/api/v1/auth/login` returned backend 401,
nested `error.code: UNAUTHORIZED`, and the same `X-Trace-Id` in the header and
`meta.traceId`. Flutter logged the exact forwarded backend path. There was no
CORS rejection, request/response credential body, mobile number, PIN,
authorization value, or token in console output.

An explicitly authorized credential smoke reached login 200, device-session
confirmation 200, and the authenticated placeholder. It exposed a
route-disposal race: the login page cancelled the controller after it had
already advanced to `authenticatedUnconfirmed`, causing a router assertion.
The cancellation guard now acts only while the session is unauthenticated; a
regression test covers this boundary. Hot reload completed and the protected
placeholder rendered. The final authorized logout returned 200 before the
test browser closed.

The backend's public health route is `/actuator/health`, outside the
deliberately restricted `/api/` proxy prefix. A direct health request returned
200 `UP`; requesting `/api/actuator/health` through the proxy preserved that
exact path and returned the backend's non-destructive 401. Expanding the proxy
to reach actuator would violate the API-only rule, so no proxied health 200 is
claimed.

The safe invalid request verified the nested envelope and trace propagation at
the transport boundary, but the localized invalid-credential widget was not
manually captured. Its automated widget coverage remains the UI evidence.
Matching-viewport acceptance, runtime FA/PS switching, 200% runtime inspection,
and Android TalkBack remain pending.

## Independent authorized validation — 20 July 2026

The authorized test account was entered manually once. Sanitized runtime
evidence showed:

- `POST /api/v1/auth/login` → 200;
- `GET /api/v1/auth/devices` → 200 and the protected placeholder rendered;
- browser refresh → one `POST /api/v1/auth/refresh` → 200, then one device
  confirmation → 200 and the protected placeholder restored;
- `POST /api/v1/auth/logout` → 200;
- final browser refresh rendered login and made no refresh request.

Every response trace matched its request trace. The `/api/` proxy produced no
CORS error. Runtime logs contained no mobile number, PIN, request/response body,
authorization value, token, or secure-storage content. Raw/fingerprinted token
values and browser storage were deliberately not inspected. The live refresh
therefore proves the rotating endpoint was exercised and the replacement
session was accepted; previous-token non-reuse and atomic local replacement
remain automated/backend-contract evidence rather than raw live inspection.

A narrow effective browser viewport exposed an authenticated-placeholder
overflow during logout. Logout still completed with 200. The placeholder was
made scrollable and a narrow-viewport widget regression was added. A clean
412×915 identifier-free restored-placeholder screenshot is stored under the
governed authentication implementation evidence directory. Login pixel
acceptance and Android TalkBack remain open. The corrected placeholder passed
the widget and web-build gates but was not exercised in a second live account
run, because the authorized login sequence was intentionally limited to once.

The required credential grep has no textual source/document/fixture matches
after correction. Its binary-aware default still reports a byte-pattern match
inside the bundled Noto font; the same scan with binary files ignored produces
no output. No font bytes were modified or treated as credential material.

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
