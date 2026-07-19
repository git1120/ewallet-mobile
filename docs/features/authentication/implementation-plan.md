# Authentication implementation plan

Phases A–C and safe first-slice regions of Phase D were implemented on
19 July 2026. Runtime visual comparison and language-owner review remain open.

## Phase A — Contract models

- Add login/refresh request DTOs exactly as `mobileNumber`, `pin`, and
  `refreshToken`.
- Add nested success/error envelope parsing and `JwtResponse` fields exactly as
  source; do not add expiry fields.
- Add domain session model containing only required token/session identity and
  coarse account/session failures.
- Correct `error.code`, `meta.traceId`, and `X-Trace-Id` parsing.
- Define mobile normalization and request serialization.
- Add DTO, malformed-envelope, status/code, and trace contract tests.

**Exit:** `AUTH-GAP-01` examples encoded; `AUTH-GAP-14` closed; source/Postman
discrepancies tested; no backend message reaches UI; analyzer/tests pass.

**Status:** implemented and covered by contract/API tests.

## Phase B — Session infrastructure

- Introduce a testable in-memory access-token source for `ApiClient`.
- Persist rotating refresh credential/session metadata only through
  `SecureStore`.
- Build atomic token replacement, `RefreshCoordinator` integration, one-retry
  eligible request logic, generation/stale-response prevention, cancellation,
  and terminal cleanup.
- Add restore, corrupt store, concurrent 401, rotation, reuse, uncertainty,
  logout cleanup, and sensitive-log tests.

**Exit:** `AUTH-GAP-15` closed; no access token dependency on preferences;
refresh is single-flight/atomic; old token cannot be reused by the client;
logout always clears local state; security review passes.

**Status:** implemented. Refresh network uncertainty conservatively clears the
local session.

## Phase C — Authentication state and navigation

- Add Riverpod repository/controller/providers with separated session, form,
  request, restriction, and terminal state.
- Implement device-session confirmation or an approved replacement.
- Integrate GoRouter redirects through central state, protected placeholder,
  bootstrap, expiry, restriction, logout, deep-link allowlist, and loop guards.
- No widget triggers navigation from infrastructure.

**Exit:** `AUTH-GAP-12` accepted/closed; all state-machine and router tests pass;
protected content is never built before confirmation; concurrent terminal
events collapse to one cleanup/navigation event.

**Status:** implemented with the documented temporary `/auth/devices` probe.

## Phase D — Approved login UI

- Resolve `flow-auth-entry-v1` at the selected target viewport and use the exact
  mobile/PIN regions.
- Obtain decisions/deviations for `AUTH-GAP-02`, `04`, `05`, `13`, and `17`.
- Map to/extend shared `Iba*` components; add gallery coverage for any broadly
  reusable extension.
- Add approved EN/FA/PS ARB copy and regenerate localization.
- Implement default, focus, validation, submitting, invalid, offline/server,
  temporary lock, restriction, and session-ended contracts.
- Validate keyboard, lifecycle secret clearing, RTL, semantics, reduced motion,
  responsive constraints, and 200% text.

**Exit:** every implemented region has an exact reference/viewport and no
unapproved deviation; language review complete; widget/visual review passes.

**Status:** safe regions implemented. Composite status remains `in-progress`
pending matching-viewport review, brand-asset mapping, deviation approval, and
linguistic review.

## Phase E — Validation

- Run format, rule validation, analyze, all tests, quality gate, and web build.
- Compile/run Android where the repository environment permits.
- Smoke login using a controlled test environment only in an explicitly
  authorized integration task; never use production credentials.
- Capture screenshots under
  `artifacts/visual-validation/authentication/<reference-id>/`.
- Compare matching viewports and record platform tolerance/deviations.
- Update authentication reference status without marking unimplemented board
  regions complete.

**Exit:** static/full build gates pass; Android and Chrome validation evidence
is honest; EN/FA/PS, RTL, 200%, keyboard, accessibility, and session failure
evidence is recorded; status register updated.

**Status:** the original direct Chrome smoke reached the deployed API CORS
boundary. The repository now resolves web development to same-origin
`/api/v1/...` requests and delegates that prefix to Flutter 3.38.3's root
development proxy; Android remains direct and secure production validation is
unchanged. Live proxy/Chrome evidence is recorded in the test plan. No
production-web readiness is claimed.
