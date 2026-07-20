# Authentication acceptance criteria

## Implementation checkpoint — 19 July 2026

Contract parsing, memory/secure token separation, rotating refresh, restore,
confirmation, guarded navigation, two-step mobile/PIN login, terminal states,
temporary placeholder, and local-first logout are implemented. Linguistic
approval, Android TalkBack/runtime evidence, and matching-viewport visual
acceptance remain open and are not claimed by the automated implementation.

## Contract and security

- [ ] Login sends only `mobileNumber` and six-digit `pin` to
      `POST /api/v1/auth/login`; refresh sends only `refreshToken` to the exact
      refresh path.
- [ ] DTOs parse the nested success envelope and exact response fields without
      invented expiry/profile data.
- [ ] Failures parse `error.code` and `meta.traceId`/`X-Trace-Id`; backend
      messages/codes are never user copy.
- [ ] Access token is memory-only; rotating refresh credential is stored only
      through `SecureStore`; no auth secret enters preferences.
- [ ] PIN is obscured, never persisted/logged/restored/clipboarded, and cleared
      at all documented boundaries.
- [ ] Refresh is serialized, atomically replaces credentials, never blindly
      reuses the old token, retries eligible requests once, and ignores stale
      responses.
- [ ] Logs, analytics, and crash reports contain no credentials, mobile/user/
      session/device identifiers, roles, or bodies.
- [ ] Logout makes one best-effort server call, cancels protected work, clears
      local credentials in all outcomes, and returns unauthenticated.

## State and navigation

- [ ] Launch restores no session, valid session, corrupt storage, terminal
      refresh, and network uncertainty deterministically.
- [ ] Session confirmation uses an accepted exact backend route; no customer
      `/me` route is invented.
- [ ] Unauthenticated users cannot access protected routes; confirmed users do
      not remain on login; redirect loops are impossible.
- [ ] Invalid credentials do not enumerate accounts and clear PIN.
- [ ] Temporary PIN lock, suspended, locked/blocked, and closed codes map to
      precise terminal/restricted state without invented countdown/reason.
- [ ] Session expiry, revocation, refresh reuse, and invalid refresh clear state
      before leaving the protected route.
- [ ] Offline and server-unavailable login are distinct and retry only by user
      intent.

## Visual, localization, and accessibility

- [ ] Implemented login regions follow `flow-auth-entry-v1` at the recorded
      viewport; the four-digit/OTP-first board is not merged into the flow.
- [ ] Every screen/state has a Visual Reference Contract or an approved
      missing-reference/deviation decision.
- [ ] Visible elements use sufficient existing/extended `Iba*` components and
      semantic tokens; no local component fork or Material-default drift.
- [ ] English, linguistically reviewed Dari, and linguistically reviewed Pashto
      ARBs are complete; generated files are produced normally.
- [ ] RTL mirrors directionally and mobile values remain controlled LTR.
- [ ] Semantic titles/fields/errors/loading, logical focus, keyboard submit,
      visible focus, and 48×48 targets pass.
- [ ] At 200% text, narrow/wide layouts and keyboard insets do not clip,
      overlap, or horizontally scroll prose.
- [ ] Reduced motion preserves all state meaning; error/restriction meaning is
      color independent.

### Measured fidelity checkpoint — 20 July 2026

- [x] Mobile/PIN regions were measured against `flow-auth-entry-v1` and audited
      at 412×915 before implementation.
- [x] Mobile field/action/reassurance and PIN header/indicators/action/keypad
      geometry were corrected with shared `Iba*` variations.
- [x] Layout tests cover 360×800, 390×844, 412×915, and 430×932, equal
      directional keypad sides, 64px key targets, six indicators, delete
      placement, focus treatment, RTL mixed direction, and 200% reflow.
- [x] Clean EN/LTR and FA/RTL mobile/PIN screenshots exist under the governed
      artifact path and contain no entered PIN or unmasked mobile value.
- [x] Approved brand artwork is copied byte-for-byte, mapped through shared
      `IbaBrandMark`, and hash-verified against its admin-panel sources.
- [x] Product/design has approved the unsupported-action, exact country-prefix,
      and privacy-masking deviation records.
- [ ] Android TalkBack runtime passes; current local Android tooling cannot
      attach the installed emulator.
- [ ] Language owners approve current Dari/Pashto wording.

Final matching-viewport decision for the implemented mobile/PIN regions:
**Accept with documented deviation**. Android TalkBack runtime and linguistic
review remain open; the accepted visual status does not claim either result or
the deferred composite-board regions.

## Verification and governance

- [ ] DTO/mapper, API/repository, session, router, widget, and security tests in
      `test-plan.md` pass.
- [ ] `dart format --output=none --set-exit-if-changed .`,
      `dart run tool/validate_agent_rules.dart`,
      `flutter --no-version-check analyze`,
      `flutter --no-version-check test`, and both quality-gate modes pass on
      Flutter 3.38.3 / Dart 3.10.1.
- [ ] Chrome visual smoke and available Android compile/runtime evidence are
      recorded without claiming production web or iOS support.
- [ ] Matching-viewport screenshots and deviations are stored only under the
      governed artifacts path.
- [ ] Authentication design-reference status is updated accurately; no
      composite board is marked implemented for partial work.
- [ ] Backend/admin repositories and approved images are unchanged; no
      dependency, commit, or push occurs without explicit authorization.
