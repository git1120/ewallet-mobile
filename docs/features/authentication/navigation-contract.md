# Authentication navigation contract

## Route boundary

The planned route names/paths are contract placeholders, not current code:

| Boundary | Planned path | Access |
|---|---|---|
| Bootstrap | `/` or router-owned initial loading location | Neither authenticated nor unauthenticated content until restoration resolves. |
| Login | `/login` | Unauthenticated only; represents mobile and PIN substates without placing credentials in URL. |
| Session-ended/restricted presentation | `/session-ended` or router-owned state outside protected shell | Unauthenticated, reason supplied from in-memory coarse state—not query parameters. |
| Authenticated placeholder | `/authenticated` | Authenticated and confirmed only. |
| Development gallery | Existing `/gallery` | Existing environment rule remains; it is not an authenticated product destination. |

Final route strings are selected in implementation and tested; no route is
created by this document.

## Bootstrap and redirect rules

1. Router starts in a non-protected bootstrap state.
2. No refresh credential routes to login.
3. A credential starts one serialized restoration refresh. Protected content is
   not built underneath.
4. Successful refresh plus session confirmation routes to the authenticated
   placeholder.
5. Corrupt, expired, revoked, reused, or invalid refresh state is cleared, then
   routes to session-ended/login as appropriate.
6. A transient bootstrap network failure must not expose protected content.
   Conservative first-slice behavior clears uncertain session state and offers
   login again; revising this needs an explicit rotation-recovery decision.

GoRouter `redirect` observes a listenable/provider projection of session state.
Repositories, Dio interceptors, and storage never navigate. Widgets do not call
navigation as a substitute for changing central auth state.

## Protected routes and loops

- `authenticated` is the only state allowed through the protected boundary.
- `authenticatedUnconfirmed`, `refreshing` during restoration, and
  `bootstrapping` wait at loading instead of bouncing between routes.
- An unauthenticated visit to a protected deep link redirects once to login.
  The intended location may be retained only as a validated in-memory path; no
  credential or sensitive query is retained.
- A logged-in visit to `/login` redirects to the authenticated placeholder.
- Redirect returns `null` when current location already represents the required
  boundary. Tests assert a finite redirect count.
- Unknown/corrupt session state is treated as unauthenticated after secure
  cleanup, never as authenticated.

## Session expiry and logout

Terminal expiry/revocation invalidates the session generation, cancels
protected work, clears storage/in-memory secrets, leaves the protected tree,
then presents `AUTH-VRC-09`. Login Again returns to `/login`; protected “Go
Home” is not available.

Logout performs the same local ordering after one best-effort server call and
ends at `/login`. No approved logout-confirmation screen exists, so first-slice
navigation assumes direct explicit logout. If product requires confirmation,
implementation pauses for a visual/product contract.

## Deep links and browser refresh

- Before authentication, a protected deep link is held only in memory and only
  for an allowlisted internal path. After confirmed login it may resume;
  otherwise it is discarded.
- Deep links never carry PIN, token, mobile number, restriction reason, or
  backend message.
- Flutter Web remains a development/visual-validation target. Browser refresh
  may exercise the same abstract restoration path for smoke testing, but this
  is not approval to persist production bearer tokens in browser storage.
- Unknown routes use the existing router error strategy and do not trigger
  authentication refresh loops.
