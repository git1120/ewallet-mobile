# Authentication state machine

## Separation of concerns

Do not encode every concern in one enum.

| State axis | Values |
|---|---|
| Session | `bootstrapping`, `unauthenticated`, `establishing`, `authenticatedUnconfirmed`, `authenticated`, `refreshing`, `loggingOut`, `terminal` |
| Login form | `mobileEntry`, `pinEntry`, `submitting`, `invalidCredentials`, `temporarilyLocked` |
| Request | `idle`, `inFlight`, `offline`, `serverUnavailable`, `cancelled` |
| Account restriction | `none`, `suspended`, `lockedOrBlocked`, `closed`, `otherForbidden` |
| Terminal reason | `expired`, `revoked`, `refreshReused`, `invalidRefresh`, `accountRestricted`, `logout` |

One immutable aggregate may expose these axes, but impossible combinations must
be rejected: for example, `authenticated` cannot carry a PIN form or account
restriction, and `refreshing` requires an established session generation.

## Session transitions

| State | Entry event | Allowed transitions | UI / router | Storage and sensitive handling | Retry / logging |
|---|---|---|---|---|---|
| `bootstrapping` | App launch. | No refresh credential → `unauthenticated`; credential → `establishing`; corrupt storage → cleanup → `unauthenticated`. | Non-navigable bootstrap loading; router waits. | Read refresh credential through `SecureStore`; no protected content. | One restore attempt. Coarse outcome only. |
| `unauthenticated` | No valid local/server session or logout complete. | Start login → form states; valid credentials → `authenticatedUnconfirmed`. | `/login`; protected routes redirect here. | No tokens; PIN absent. Mobile may remain only in controller while screen lives. | User-driven submission only. |
| `establishing` | Restore has a refresh credential. | Refresh success → `authenticatedUnconfirmed`; network failure → explicit bootstrap recovery decision; terminal refresh → cleanup → `terminal` then `unauthenticated`. | Bootstrap loading/recovery, no protected route. | Serialized refresh; old credential retained only until atomic replacement. | No blind repeat of a possibly rotated token. |
| `authenticatedUnconfirmed` | Login/restore produced parsed tokens. | Device-session confirmation active → `authenticated`; auth failure → refresh once or terminal; network/server → retry/abort policy. | Auth transition loading; authenticated destination not yet exposed. | New refresh credential stored atomically; access token in memory; generation assigned. | One confirmation request per attempt. |
| `authenticated` | Confirmation succeeded. | Access expiry/401 → `refreshing`; logout → `loggingOut`; account/session code → `terminal`. | Protected router branch and placeholder. | Refresh token secure; access token memory; no credentials in route state. | Safe reads may retry once after successful refresh. |
| `refreshing` | Eligible protected request receives expiry/auth failure or proactive policy triggers. | Success → `authenticated`; terminal failure → `terminal`; network uncertainty → `terminal` under conservative rotation policy. | Preserve protected UI behind non-interactive session progress where safe; no redirect loop. | One coordinator future per session generation; atomic replacement; queue eligible callers. | Never recursively refresh or reuse old token. |
| `loggingOut` | Explicit logout. | Always → `terminal(logout)` → `unauthenticated`. | Block protected actions; then `/login`. | Invalidate generation, cancel protected requests, best-effort server logout, clear store/memory in `finally`. | No remote retry loop. Log status/trace only. |
| `terminal` | Expiry, revocation, reuse, invalid refresh, restriction, or logout. | After cleanup → `unauthenticated`; restricted/session-expired presentation may precede login action. | Outside protected route; exact VRC based on reason. | Clear refresh/access/session/user-sensitive state before route exposure. | One terminal event despite concurrent failures. |

## Login-form transitions

```text
mobileEntry
  --valid mobile--> pinEntry
pinEntry
  --six digits + submit--> submitting
submitting
  --success--> session.authenticatedUnconfirmed
  --PIN_INVALID/generic unauthorized--> invalidCredentials
  --PIN_LOCKED--> temporarilyLocked
  --USER_*--> account restriction + session.terminal
  --offline/server--> pinEntry + request failure
invalidCredentials
  --edit PIN--> pinEntry
temporarilyLocked
  --return--> mobileEntry (no countdown or automatic unlock claim)
```

Local mobile/PIN validation never establishes account existence. On invalid
credentials, offline, server failure, cancellation, or restriction, clear the
PIN. Mobile number may be retained for recoverable form errors but is cleared
on logout, lifecycle/privacy reset, or user request.

## Request and race rules

- Every session-changing operation captures a monotonically increasing
  generation. A completion mutates state only if its generation is current.
- Login is single-flight. Refresh is single-flight through
  `RefreshCoordinator`. Logout invalidates both.
- A protected request retries at most once after refresh and never if cancelled,
  unsafe to repeat, or already marked retried.
- A late login/refresh success after logout is discarded and its credentials
  are never persisted.
- `REFRESH_TOKEN_REUSED`, `REFRESH_TOKEN_EXPIRED`, `SESSION_REVOKED`,
  `SESSION_EXPIRED`, generic invalid refresh, and account restriction are
  terminal.
- Offline login is recoverable only by explicit resubmission. Offline refresh
  is conservatively terminal because the old single-use token may have rotated;
  product/backend may later define safer reconciliation.

## Router and logging invariants

Controllers publish state; widgets dispatch intent. Infrastructure never calls
navigation APIs. The GoRouter redirect observes the central session state.
Logs may contain operation name, coarse state, HTTP status, and trace ID after
redaction. They never contain mobile number, PIN, tokens, roles, user/session
IDs, device metadata, backend body/message, or full route query data.
