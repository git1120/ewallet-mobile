# Authentication scope

## Included

The first implementation slice is:

```text
application launch
→ restore refresh credential, if present
→ establish or reject the session
→ mobile-number entry
→ six-digit PIN entry and credential submission
→ persist the rotating refresh credential
→ confirm the authenticated session
→ authenticated placeholder destination
→ access-token refresh
→ logout
→ session-expired/revoked recovery
```

It includes:

- initial unauthenticated entry and deterministic bootstrap;
- customer mobile-number plus six-digit PIN form and local format validation;
- one guarded credential submission;
- successful access/refresh session establishment;
- Android secure persistence of the refresh credential and session metadata
  required for safe restoration;
- in-memory access-token handling;
- current-session confirmation using authenticated
  `GET /api/v1/auth/devices` and the returned login `deviceSessionId`;
- an authenticated navigation boundary and non-business placeholder;
- access-token expiry detection, serialized refresh, atomic refresh rotation,
  and stale-response prevention;
- refresh failure, revoked/reused/expired session termination;
- current-session logout and local cleanup even when remote logout cannot
  complete;
- precise invalid-credential, temporary PIN lock, suspended, locked/blocked,
  closed, offline, server-unavailable, and expired-session state mapping.

`APPROVED` and `ACTIVE` are the only backend customer statuses eligible for
login/refresh. A temporary PIN lock is separate from `users.user_status`.

## Excluded

| Capability | Reason deferred |
|---|---|
| Signup and onboarding | Separate resumable onboarding contract and composite board; not required to establish an existing-user session. |
| Forgot PIN / PIN reset | Approved visuals exist, but no customer recovery route is present in the inspected backend authentication contract. |
| PIN creation/change/delete | Account lifecycle/settings work; current-user PIN routes are not needed for login. |
| Biometric enrollment and local biometric unlock | Backend stores only a device-session preference; reviewed native `local_auth` and protected-storage architecture is not yet present. |
| Server biometric challenge/login | Backend explicitly marks old challenge payloads/controllers superseded and performs no biometric login. |
| OTP login | Backend OTP is for signup and transaction authorization, not login. |
| OTP transaction authorization | Financial-flow scope. |
| Session list, per-device revocation, logout-all UI | Backend-supported security settings, but not required for the smallest current-session slice. |
| Language onboarding screen | Locale persistence already exists; onboarding presentation is a separate implementation decision. Login still requires all three locales. |
| Splash branding implementation | Bootstrap needs a loading state, but exact splash implementation is a separate visual slice. |
| Account recovery countdown/support workflow | No exact lock expiry or supported recovery action is returned by login. |
| KYC and walk-in customer flows | Separate identity/compliance contracts. |
| Accounts, transfers, top-up, transactions, beneficiaries, profile editing | Authenticated product features; the first slice ends at a placeholder boundary. |
| Staff/admin login | Customer and admin auth routes/contracts are explicitly separate. |
| Production Flutter Web authentication | Web is development/visual-validation only pending a separate browser threat model and server cookie decision. |
| iOS validation | No iOS runner exists in this repository. |

Approved visual presence does not move an excluded capability into scope.
