# Authentication contract package

## Purpose and status

This package is the design, backend-contract, security, navigation, and test
analysis for the first customer-authentication implementation slice. It is not
feature implementation: no authentication route, widget, API repository, token
persistence workflow, or route guard exists yet.

The smallest supported slice is mobile-number plus six-digit PIN login, secure
session persistence on Android, refresh rotation, authenticated-session
confirmation through the device-session endpoint, an authenticated placeholder,
logout, and terminal session recovery. Implementation must not begin until the
gaps marked blocking in [contract gaps](contract-gaps.md) are resolved or the
documented temporary behavior is accepted.

## Authority

Evidence was inspected on 19 July 2026 in this priority order:

1. Backend source in `../api/src/main/java` and backend configuration/migrations.
2. `../api/postman/E-Wallet Complete API.postman_collection.json`.
3. Approved binding references and related boards in `design-references/`.
4. Existing Flutter foundations under `lib/` and `test/`.
5. Repository architecture, security, localization, accessibility, and agent
   rules.

Backend source is authoritative where Postman text or a visual differs. Images
control supported presentation, but do not create routes, fields, error codes,
or business behavior.

## Approved reference set

The first-slice binding flow is `flow-auth-entry-v1`. The composite
`flow-auth-signup-foundation-v1` is approved but only its non-conflicting visual
language is supporting for this slice; its OTP-first and four-digit-PIN regions
conflict with the backend and are deferred. Related approved references are:

- `flow-system-states-v1`
- `flow-pin-recovery-v1` (recovery deferred; locked-state evidence only)
- `component-button-v1`
- `component-input-form-v1`
- `component-navigation-layout-v1`
- `component-security-privacy-v1`
- `component-feedback-status-v1`
- `foundation-api-error-v1`

All are composite boards, not single screens. Their paths, visible regions, and
classifications are recorded in [reference map](reference-map.md).

## Backend readiness and unresolved gaps

Login, refresh, logout, device-session listing, device revocation, and
logout-all exist. The backend returns bearer tokens in the response body and
rotates refresh tokens on every refresh. It does not expose token expiry fields
in the response, a dedicated customer `/me` profile endpoint, remaining PIN
attempts, lock expiry/countdown, a recovery/forgot-PIN contract, OTP login, or
server biometric login.

Two Flutter integration mismatches must be fixed during implementation:

- backend errors use `error.code` and `meta.traceId`, while the current
  `FailureInterceptor` looks for top-level `code` and `requestId`;
- the current authorization interceptor reads the access token from secure
  storage on every request, while the approved security plan keeps the access
  token in memory and persists the rotating refresh token.

See [contract gaps](contract-gaps.md) for ownership and blocking decisions.

## Next phase

Phase A is contract DTOs, parsing, and error-mapping tests. It may start only
after product/backend acceptance of the six-digit PIN flow authority and the
device-session endpoint as the first-slice session-confirmation probe. UI work
does not begin until Phases A–C satisfy their exit criteria.

## Documents

- [Scope](scope.md)
- [Backend contract](backend-contract.md)
- [Reference map](reference-map.md)
- [Visual Reference Contracts](visual-reference-contracts.md)
- [State machine](state-machine.md)
- [Navigation contract](navigation-contract.md)
- [Security contract](security-contract.md)
- [Localization contract](localization-contract.md)
- [Accessibility contract](accessibility-contract.md)
- [Contract gaps](contract-gaps.md)
- [Implementation plan](implementation-plan.md)
- [Acceptance criteria](acceptance-criteria.md)
- [Test plan](test-plan.md)
