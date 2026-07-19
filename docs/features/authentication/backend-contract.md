# Backend authentication contract

## Evidence and authority

The authoritative implementation is:

- `../api/src/main/java/ewallet/user/controller/AuthController.java`
- `../api/src/main/java/ewallet/user/service/AuthService.java`
- `../api/src/main/java/ewallet/user/service/RefreshTokenService.java`
- `../api/src/main/java/ewallet/user/service/DeviceSessionService.java`
- request/response payloads under `../api/src/main/java/ewallet/user/payload/`
- error/security code under `../api/src/main/java/ewallet/common/`
- `../api/src/main/resources/application.properties`

The compared collection is
`../api/postman/E-Wallet Complete API.postman_collection.json`, sections
“Customer Authentication” and “Device Sessions & Local Biometric Preference.”
Source code wins if they differ.

## Deployed development evidence — 19 July 2026

One safe health request returned `200` with `status: UP`. One intentionally
invalid dummy login returned `401`, nested `error.code: UNAUTHORIZED`,
`meta.traceId`, and a matching `X-Trace-Id`. No real credential, repeated
attempt, session mutation, or financial endpoint was used.

## Shared envelopes, headers, and transport

Success is JSON:

```json
{
  "success": true,
  "message": "backend diagnostic copy",
  "data": {},
  "meta": {
    "timestamp": "yyyy-MM-dd HH:mm:ss Z",
    "timeZone": "Asia/Kabul"
  }
}
```

Failure is JSON:

```json
{
  "success": false,
  "message": "backend diagnostic copy",
  "error": {"code": "CODE", "details": null},
  "meta": {
    "timestamp": "yyyy-MM-dd HH:mm:ss Z",
    "timeZone": "Asia/Kabul",
    "traceId": "trace value",
    "path": "/api/v1/..."
  }
}
```

The client sends `Accept: application/json`; JSON-body routes also send
`Content-Type: application/json`. Protected routes use
`Authorization: Bearer <access-token>`. `X-Trace-Id` is accepted or generated
by `RequestTraceFilter` and returned as `X-Trace-Id`; `X-Time-Zone` is optional.
The backend records optional `X-Device-Id`, `X-Device-Name`, `X-Platform`,
`X-App-Version`, `User-Agent`, and remote IP when a refresh session is created
or rotated. Source does not require or validate those device headers.

There are no authentication cookies and Spring Security is stateless. Tokens
are response-body/request-body values. No authentication-specific general HTTP
rate limiter or `Retry-After` contract was found. The PIN attempt policy
defaults to three failures and five minutes, but those are deploy-time
configuration, not stable client constants.

The backend never returns credentials through response cookies. The mobile
client must never show backend `message`, `error.code`, or trace IDs as normal
user copy.

## Login

| Item | Contract |
|---|---|
| Purpose | Authenticate an existing customer and create a refresh-backed device session. |
| Method / path | `POST /api/v1/auth/login` |
| Authentication required | No. |
| Headers | Shared JSON headers; optional trace, timezone, device/client metadata. |
| Request body | Required `mobileNumber`: exactly ten digits under `@TenDigitPhoneNumber`; required `pin`: exactly six ASCII digits (`\d{6}`). No username/account/CIF login. |
| Response body | `ApiResponse<JwtResponse>`; `data.token`, `data.refreshToken`, `data.type`, `data.id`, `data.username`, `data.roles`, `data.deviceSessionId`, `data.deviceId`. Both device fields receive the same server refresh-session UUID. |
| Success status | `200 OK`. `type` is `"Bearer"`. |
| Controlled failures | `400` validation envelope; `401 PIN_INVALID`; `403 USER_SUSPENDED`, `USER_LOCKED`, `USER_CLOSED`, or `FORBIDDEN`; `429 PIN_LOCKED`/`ACCOUNT_TEMPORARILY_LOCKED`; generic `401 UNAUTHORIZED` for unknown mobile number because that branch supplies no explicit code. |
| Sensitive fields | Mobile number, PIN, access token, refresh token, user/session IDs. |
| Retry policy | Never automatic. A user may explicitly resubmit after a controlled invalid-credential result. Do not retry a lock/restriction. |
| Cancellation policy | Cancel client waiting on route disposal/new intent; cancellation does not prove the backend did not create a session. If a late success arrives after cancellation, reject it by operation generation and attempt remote cleanup only if the session is safely known. |
| Flutter integration | Normalize display formatting to the backend ten-digit value; submit one guarded request; clear PIN after completion/failure as defined by the state machine; parse the nested envelope; store no backend message. |
| Evidence | `AuthController.login`, `LoginRequest`, `AuthService.authenticate/issueTokensForUser`, `UserSecurityLockService`, `JwtResponse`, Postman Login request. |

The failure that reaches the configured threshold still originates from
`PIN_INVALID`; the lock is applied while recording that failure. A subsequent
attempt encounters `PIN_LOCKED`. The API returns neither remaining attempts nor
`lockedUntil`.

## Refresh

| Item | Contract |
|---|---|
| Purpose | Rotate a single-use refresh credential and issue a new access token/session-row generation. |
| Method / path | `POST /api/v1/auth/refresh` |
| Authentication required | No access token; possession of refresh token is the credential. |
| Headers | Shared JSON headers; optional trace/timezone and device/client metadata. |
| Request body | `{"refreshToken":"<raw token>"}`. Source has no bean-validation annotation; null/blank becomes generic unauthorized. |
| Response body | Same `ApiResponse<JwtResponse>` as login, with a new access token, refresh token, and replacement `deviceSessionId`/`deviceId`. |
| Success status | `200 OK`. |
| Controlled failures | `401 REFRESH_TOKEN_REUSED` (marks prior row suspicious and revokes active family); `401 REFRESH_TOKEN_EXPIRED`; `403 USER_SUSPENDED`, `USER_LOCKED`, `USER_CLOSED`, or `FORBIDDEN`; generic `401 UNAUTHORIZED` for blank/unknown token. `SESSION_REVOKED`/`SESSION_EXPIRED` are enforced on protected access-token requests; source refresh itself does not emit those codes for an unknown/revoked raw token. |
| Sensitive fields | Old/new refresh token, access token, user/session/device identifiers. |
| Retry policy | No blind automatic repeat with the old token. One serialized refresh operation may serve concurrent callers. Network uncertainty is terminal locally unless atomic state proves no rotation response was accepted; reusing the old token can revoke the family. |
| Cancellation policy | Do not cancel a refresh solely because one waiting request is disposed; the coordinator owns it. Ignore stale completion after logout/session generation change. |
| Flutter integration | Atomically replace token and session ID before releasing waiters; discard old token; retry each eligible safe request at most once with the new access token; never refresh the refresh request. |
| Evidence | `AuthController.refreshToken`, `AuthService.refreshToken`, `RefreshTokenService.rotate`, `RefreshTokenRequest`, Postman Refresh Customer Token. |

The `JwtResponse` contains no `expiresIn`, `expiresAt`, refresh expiry, or
server-time field. JWT `exp` exists in the access token, but relying on local
decoding requires an explicit implementation decision.

## Logout current session

| Item | Contract |
|---|---|
| Purpose | Revoke the refresh session linked by `sid` in the current access token. |
| Method / path | `POST /api/v1/auth/logout` |
| Authentication required | Bearer access token and authority `CUSTOMER_USER_LOGOUT`. The JWT filter also requires the linked server session to remain active. |
| Headers | Shared headers plus `Authorization`. No body. |
| Request / response body | No request body. Success `ApiResponse<Void>` has `data: null`. |
| Success status | `200 OK`. |
| Controlled failures | `401 ACCESS_TOKEN_INVALID`, `SESSION_REVOKED`, `SESSION_EXPIRED`, or generic unauthorized; `403` missing authority; possible `404 RESOURCE_NOT_FOUND` if authenticated mobile no longer resolves. |
| Sensitive fields | Authorization token and session ID implicit in JWT. |
| Retry policy | Do not loop. One explicit best-effort request; local logout completes regardless of remote response. |
| Cancellation policy | Logout owns cancellation of protected work. The logout call may be bounded, then local secrets are cleared. |
| Flutter integration | Block new protected work, invalidate session generation, attempt server logout, clear all local credentials/in-memory user state in a `finally` path, then route unauthenticated. |
| Evidence | `AuthController.logout`, `AuthService.logout`, `RefreshTokenService.revokeSession`, security configuration, Postman Customer Logout. |

## Session confirmation / device list

| Item | Contract |
|---|---|
| Purpose | List refresh-backed sessions for the current user. For this slice it is the available authenticated session-confirmation probe, not a customer-profile `/me`. |
| Method / path | `GET /api/v1/auth/devices` |
| Authentication required | Bearer access token; JWT filter validates user status and active linked session. |
| Headers | Shared headers plus `Authorization`. |
| Request / response body | No body. `ApiResponse<List<DeviceSessionResponse>>`; each item contains `deviceSessionId`, alias `deviceId`, optional client/device metadata, `biometricEnabled`, `status`, `issuedAt`, `lastUsedAt`, `expiresAt`, `revokedAt`, and `revokedReason`. |
| Success status | `200 OK`. |
| Controlled failures | `401 ACCESS_TOKEN_INVALID`, `SESSION_REVOKED`, `SESSION_EXPIRED`, `USER_SUSPENDED`, `USER_LOCKED`, `USER_CLOSED`, or generic unauthorized. `404 RESOURCE_NOT_FOUND` is possible if no active current user resolves. |
| Sensitive fields | Session/device metadata, IP-derived context (not returned here), user agent, timestamps, revocation reason. |
| Retry policy | One user-initiated retry for network/server failure. Authentication failures enter refresh or terminate; no infinite confirmation loop. |
| Cancellation policy | Cancel when bootstrap generation changes or logout starts. |
| Flutter integration | A successful protected response confirms the bearer session. Match the current `deviceSessionId` when possible and require `ACTIVE`; do not expose the full device list in the placeholder. This does not provide a current-user profile. |
| Evidence | `AuthController.devices`, `DeviceSessionService.listCurrentUserDevices`, `DeviceSessionResponse`, Postman List My Device Sessions. |

The list includes historical sessions because source calls
`findAllByUserIdOrderByIssuedAtDesc`, not an active-only query.

## Logout all (supported, deferred UI)

`POST /api/v1/auth/logout-all` is bearer-authenticated and requires
`CUSTOMER_USER_LOGOUT`. It revokes all non-revoked sessions and returns
`ApiResponse<Void>` with `200`. It is not used by the first slice. A later
security-settings slice must treat its own session as terminated after success.

`POST /api/v1/auth/devices/{deviceId}/revoke` also exists and returns a
`DeviceSessionResponse`; it is deferred.

## PIN, biometric, OTP, and web findings

- Login uses PIN, not password. Admin password authentication is a separate
  route and surface.
- Old biometric challenge/login payload classes and controller are explicitly
  superseded. The backend only records a per-device `biometricEnabled`
  preference; local biometric unlock is a Flutter/platform responsibility.
- Signup and transaction OTP routes do not authorize customer login.
- PIN recovery is not present in the customer auth controller.
- Tokens are JSON body values, not cookies. CORS is enabled without an inspected
  production origin policy and CSRF is disabled for the stateless bearer API.
  This is insufficient evidence for production browser authentication.

## Postman discrepancies

| Topic | Collection | Source authority / decision |
|---|---|---|
| Refresh failures | Description includes `SESSION_REVOKED` and `SESSION_EXPIRED`. | Raw refresh lookup emits generic unauthorized for unknown/revoked tokens; those named codes arise on protected access-token validation. Model source behavior. |
| Device headers | Collection sends four device headers. | Source records them when present but does not require/validate them. Treat as optional until backend makes a requirement. |
| Current user | Collection has admin `/me` and customer nested `/users/me/...` feature routes, but no customer profile `/me`. | Do not invent a customer-profile endpoint. Use authenticated device-session confirmation only. |
| Expiry | Collection stores tokens but no expiry fields. | Response model confirms none. Do not invent expiry DTO fields. |
| Request ID | Some unrelated collection requests use `X-Request-Id`. | Shared backend auth/error tracing uses `X-Trace-Id` and `meta.traceId`. |
