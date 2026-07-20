# Authentication contract package

## Purpose and status

This package governs the first customer-authentication implementation slice.
Infrastructure and the approved six-digit mobile/PIN regions were implemented
on 19 July 2026. Signup, forgot PIN, OTP login, biometric login, profile data,
and business destinations remain deferred.

The implemented slice is mobile-number plus six-digit PIN login, secure
session persistence on Android, refresh rotation, authenticated-session
confirmation through the device-session endpoint, an authenticated placeholder,
logout, and terminal session recovery. Implementation must not begin until the
gaps marked blocking in [contract gaps](contract-gaps.md) are resolved or their
temporary behavior is accepted; this task accepted the recorded safe temporary
behaviors. The implemented mobile/PIN regions are visually validated with
documented deviations. Language-owner review and deferred composite regions
remain open without changing that scoped visual result.

The measured 20 July 2026 fidelity pass corrected the mobile/PIN composition,
external mobile label and country indicator, focus treatment, supported action
placement, six-indicator rhythm, keypad geometry/dial labels, compact loading,
responsive scrolling, and mobile-to-PIN scroll restoration. Clean EN/LTR and
FA/RTL 412×915 screenshots are recorded under the governed artifact path.
The 20 July branding pass copied the user-approved IBA PNG assets byte-for-byte
from the admin-panel working copy, introduced shared `IbaBrandMark`, replaced
the temporary primary brand icon, regenerated clean EN/LTR and FA/RTL 412×915
evidence, and reached **Accept with documented deviation** for the implemented
mobile/PIN regions. The user approved the contract-driven omitted actions,
backend-compatible country/mobile presentation, and privacy masking decisions.
Composite splash/language/biometric regions remain deferred and unclaimed.

Chrome development uses the Flutter 3.38 root development-server proxy.
Browser requests remain same-origin at `/api/v1/...`; only `/api/` is forwarded
to the deployed development backend. Android continues to use the direct
development URL. This local transport arrangement does not approve production
browser authentication or change the token-storage limitations in the security
contract.

An independent authorized Chrome validation on 20 July 2026 completed login,
device-session confirmation, browser-refresh restoration, one refresh
rotation, logout, and post-logout non-restoration. Details and limitations are
recorded in the test plan; no credential or token value was retained.

Android TalkBack runtime remains blocked by unavailable local Android tooling,
and Dari/Pashto linguistic-owner review remains open. Automated semantics,
EN/FA/PS direction, 200% text, responsive, and no-overflow checks pass; neither
runtime limitation is represented as completed.

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

The original Flutter integration mismatches are now closed:

- failures read nested `error.code`, `meta.traceId`, and `X-Trace-Id`;
- access tokens remain in memory while rotating refresh/session material uses
  named secure-storage keys.

The 20 July 2026 independent review also corrected generic backend `FORBIDDEN`
mapping, threaded cancellation into device-session confirmation, shortened the
completed-PIN lifetime in widget state, and removed the authorized PIN sequence
from textual test fixtures.

See [contract gaps](contract-gaps.md) for ownership and blocking decisions.

## Implemented boundary

Implemented code lives under `lib/features/authentication/`, with shared session
coordination under `lib/app/session/` and corrected transport behavior under
`lib/core/api/`. Routes are `/`, `/login`, `/authenticated`, and
`/session-ended`. The authenticated route is explicitly temporary and contains
no profile, wallet, account, or balance data.

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
