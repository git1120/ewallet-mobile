# Authentication security contract

## Credential and token handling

- PIN is ephemeral, obscured, numeric, exactly six digits, never persisted,
  logged, placed in keys/routes/restoration/clipboard, or included in
  analytics/crash reports. Clear it after every submission result, lifecycle
  privacy loss, route exit, restriction, and disposal.
- Refresh token is the durable credential and is accessed only through
  `SecureStore`. Replace it atomically after every successful rotation.
- Access token remains in memory. The existing
  `AuthorizationInterceptor` currently reads `SecretKeys.accessToken` from
  secure storage; Phase B must align it without bypassing `ApiClient`.
- If minimal non-secret session metadata must survive launch, document each
  field. User/session/device identifiers are treated as sensitive and do not go
  to `PreferencesStore`.
- Never decode JWT claims as trusted authorization state. If `exp` is decoded
  for scheduling, server response/401 remains authoritative.

## Refresh rotation and concurrency

`RefreshCoordinator` is the existing single-flight primitive. The implemented
workflow must:

1. capture the current session generation and old refresh credential;
2. permit exactly one refresh call;
3. validate the complete nested response;
4. atomically persist the new refresh credential and new session ID;
5. install the new access token in memory;
6. discard the old credential;
7. release eligible waiters;
8. ignore a completion whose generation was invalidated.

Never retry refresh with the old token after a timeout or uncertain response.
Reuse can revoke the whole family. Concurrent protected requests retry at most
once and only if their method/business semantics permit it.

`REFRESH_TOKEN_REUSED`, expired/invalid refresh, session revocation/expiry, and
account restriction are terminal. Cancel work, clear server session where a
safe authorized call remains possible, clear local secrets, reset in-memory
sensitive state, and route through the central session boundary.

## Login/logout cancellation and stale responses

Login uses a `CancelToken`, is single-flight, and carries an operation
generation. Route disposal may cancel waiting, but a late success must not
persist credentials. Logout first blocks new protected work and invalidates the
generation, makes one bounded best-effort server call, then clears all local
auth secrets in `finally`. Remote logout failure never leaves the device
locally authenticated.

Avoid `SecureStore.clear()` if future unrelated secrets share it; Phase B must
decide whether deleting named authentication keys is safer. Current
`SecureStore` supports both named delete and clear.

## Headers and device metadata

`X-Device-Id`, `X-Device-Name`, `X-Platform`, and `X-App-Version` are optional
in backend source. Do not add fingerprinting or stable identifiers until
backend/product defines purpose, generation, retention, reset, consent, and
privacy treatment. If sent, values are minimized, stable only as required,
redacted from logs, and never used as sole authentication.

Use `X-Trace-Id`, not an invented request ID, for shared auth diagnostics. It
may be recorded after redaction but is not normal user copy.

## Logging, analytics, crash reports, clipboard

`SafeLogger`/`SanitizedLoggingInterceptor` may record method, path, status, and
trace ID. They must redact authorization, cookies, mobile/PIN, tokens, response
body, user/role/session/device identifiers, and user agent. The current logger
passes request headers through redaction; redaction coverage must be tested for
all new device/trace headers.

Analytics, if later approved, is limited to coarse screen/action/outcome such
as `login_failed_invalid_credentials`; it contains no entered value, backend
message/code, trace ID, account state reason, or unique identifier. Crash
reports follow the same boundary.

Authentication offers no copy/paste for PIN. Do not write credentials to the
clipboard. Mobile-number clipboard policy requires separate privacy review.

## Screen capture and lifecycle privacy

Approved boards request screenshot blocking/app-switcher blur on sensitive
screens, but the repository has no reviewed platform abstraction and Android is
the only mobile runner. Phase D records this as a gap; it must not add ad-hoc
platform code. At minimum, lifecycle transitions clear PIN and prevent stale
credential state from being reconstructed. Do not claim screenshot protection
until it is implemented and runtime-verified.

## Browser boundary

> Flutter Web remains a development and visual-validation target unless a
> production browser authentication architecture is explicitly approved.

Browser storage is not equivalent to Android Keystore or iOS Keychain. The
inspected backend uses JSON bearer/refresh tokens, stateless security, disabled
CSRF, and no authentication cookies. Production browser auth requires a
separate threat model, explicit CORS/CSP/hosting and XSS review, output/dependency
review, and preferably backend-managed `Secure`, `SameSite`, HttpOnly cookies.
No production web token persistence is approved here.

## Biometric boundary

The backend never performs biometric authentication. Its device endpoint only
stores a preference. Any later biometric login means local platform
authentication unlocks a device-protected refresh credential and then calls the
normal refresh endpoint. It requires a reviewed package/platform design,
fallback PIN, enrollment/revocation semantics, lifecycle tests, and secure
storage controls. It is excluded from this slice.
