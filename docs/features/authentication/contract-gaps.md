# Authentication contract gap register

Blocking means the named implementation phase cannot pass its exit gate without
the decision; it does not imply backend work is authorized in this repository.

## AUTH-GAP-01 — Login identifier (resolved)

**Implementation update (19 July 2026):** closed for the first slice. Flutter
serializes exactly ten ASCII digits; no implicit `+93` conversion is made.

- **Category / desired behavior:** API; serialize the exact supported login
  identity.
- **Approved reference / backend / Flutter:** both auth boards show mobile;
  backend requires ten-digit `mobileNumber`; `IbaPhoneField` accepts up to 12
  digits and strips formatting.
- **Missing decision:** exact UI normalization of `+93` display to ten-digit
  backend value, including local digit input.
- **Security / UX / implementation impact:** wrong normalization can deny access
  or send an unintended identifier; mixed direction needs care.
- **Temporary behavior / blocking:** accept ASCII ten-digit local form only and
  format display separately; **blocks Phase A serialization until encoded in
  tests**, not a backend blocker.
- **Owner / recommended resolution:** Flutter + product; define examples and
  pure normalization tests without changing backend shape.

## AUTH-GAP-02 — PIN-length visual conflict

**Implementation update (19 July 2026):** resolved for this slice by the
explicit six-digit task direction. Four-digit and OTP-first regions remain
deferred.

- **Category / desired behavior:** visual/API; one authoritative login PIN
  length.
- **Reference / backend / Flutter:** `flow-auth-entry-v1` shows six; signup
  foundation shows four; backend and existing `IbaPinField` require/allow six.
- **Missing decision:** written confirmation that first-slice authority is the
  six-digit entry board and conflicting four-digit regions are excluded.
- **Impact:** four digits cannot authenticate; merging boards would redesign.
- **Temporary / blocking:** use six-digit contracts only; **blocks Phase D**
  until product/design acknowledges the conflict resolution.
- **Owner / resolution:** product/design; annotate design decision without
  modifying either approved image.

## AUTH-GAP-03 — Biometric login

- **Category / desired behavior:** security/platform; secure local biometric
  unlock with PIN fallback.
- **Reference / backend / Flutter:** auth/security boards show biometric;
  backend only stores session preference and explicitly has no biometric-login
  protocol; no reviewed local-auth abstraction exists.
- **Missing:** package/platform architecture, protected refresh-token access,
  enrollment, fallback, revocation, lifecycle/privacy behavior.
- **Impact:** pretending backend biometric support would weaken security.
- **Temporary / blocking:** unavailable in first slice; **not blocking** if the
  action is removed/disabled through an approved visual deviation.
- **Owner / resolution:** security, mobile platform, product, backend; separate
  threat-modelled slice.

## AUTH-GAP-04 — Forgot PIN, signup, and help actions

**Implementation update (19 July 2026):** unsupported actions are omitted, not
tappable or presented as available. Product visual sign-off remains open.

- **Category / desired behavior:** product/navigation/API; visible actions lead
  somewhere valid.
- **Reference / backend / Flutter:** auth boards show all three; login backend
  has no recovery route; signup is separate; no support route exists in mobile.
- **Missing:** first-slice visibility/disabled behavior and approved deviation.
- **Impact:** dead controls are inaccessible and misleading.
- **Temporary / blocking:** do not expose tappable dead actions; **blocks Phase
  D** until product approves omission/disabled presentation or supplies scope.
- **Owner / resolution:** product/design; approve a deviation tied to exact
  regions.

## AUTH-GAP-05 — Lock countdown and remaining attempts

**Implementation update (19 July 2026):** the locked state contains neither a
countdown nor an attempt count. Exact board fidelity remains open.

- **Category / desired behavior:** API/UX; accurate attempts and unlock time.
- **Reference / backend / Flutter:** recovery board shows `14:59`; backend
  defaults to 3/5m but returns neither attempts nor `lockedUntil`.
- **Missing:** response fields and stable semantics; no Flutter implementation.
- **Impact:** hardcoded countdown can be wrong and disclose policy.
- **Temporary / blocking:** calm “try later” with no number/countdown;
  **blocking only for exact locked-screen fidelity** and needs deviation.
- **Owner / resolution:** backend/product/security; return safe authoritative
  retry metadata if desired, otherwise revise approved visual state.

## AUTH-GAP-06 — Device/client metadata

- **Category / desired behavior:** privacy/API; send only necessary metadata.
- **Reference / backend / Flutter:** Postman sends four `X-Device-*` headers;
  source records them optionally; Flutter has no device identity service.
- **Missing:** requiredness, generation, retention, reset, consent, privacy and
  app-version source.
- **Impact:** fingerprinting/privacy risk and inconsistent sessions.
- **Temporary / blocking:** omit optional headers; **not blocking** backend
  login. Document reduced device labeling.
- **Owner / resolution:** backend/security/privacy/product; publish a header
  contract before Flutter adds identifiers or dependencies.

## AUTH-GAP-07 — Token expiry semantics

- **Category / desired behavior:** API/session; schedule or react to expiry
  deterministically.
- **Reference / backend / Flutter:** response has no expiry fields; access JWT
  has `exp`; session list has server-local `expiresAt`; Flutter parser absent.
- **Missing:** whether client may decode `exp`, clock-skew allowance, refresh
  expiry contract, timezone/format guarantees.
- **Impact:** premature refresh or avoidable 401s; decoding must not become
  authorization.
- **Temporary / blocking:** reactive serialized refresh on controlled auth
  failure; **not blocking** first slice if accepted and tested.
- **Owner / resolution:** backend/security/mobile; preferably add explicit
  access/refresh expiry fields or approve reactive-only behavior.

## AUTH-GAP-08 — Logout-all and session management

- **Category / desired behavior:** scope; manage/revoke other sessions.
- **Reference / backend / Flutter:** security boards and backend routes support
  list/revoke/logout-all; no UI exists.
- **Missing:** product flow, confirmation, current-device behavior, copy.
- **Impact:** important security capability but not needed for current logout.
- **Temporary / blocking:** defer; **not blocking** first slice.
- **Owner / resolution:** product/security; dedicated security-settings slice.

## AUTH-GAP-09 — Browser token transport

- **Category / desired behavior:** security/platform; production web auth.
- **Reference / backend / Flutter:** web is validation-only; backend sends body
  bearer tokens, uses stateless security/CSRF disabled/no auth cookies; secure
  storage web is not hardware-backed.
- **Missing:** browser threat model, CORS/CSP/hosting/XSS design and cookie
  support.
- **Impact:** bearer theft/persistence risk.
- **Temporary / blocking:** no production web auth claim; **blocks production
  web**, not Android-first implementation.
- **Owner / resolution:** security/backend/web platform; prefer reviewed
  HttpOnly cookie architecture where feasible.

## AUTH-GAP-10 — OTP login

- **Category / desired behavior:** API/product; OTP-first login shown visually.
- **Reference / backend / Flutter:** signup foundation shows Send/Verify OTP;
  backend OTP routes are signup/transaction only; Flutter OTP component exists.
- **Missing:** login OTP challenge, purpose, attempt/expiry/resend and token
  issuance contract.
- **Impact:** reusing signup OTP for login would be unauthorized.
- **Temporary / blocking:** visual-only/deferred; **not blocking** PIN slice.
- **Owner / resolution:** product/backend/security; define a separate login
  protocol or mark board regions signup-only.

## AUTH-GAP-11 — Maintenance and minimum version

- **Category / desired behavior:** system contract; safe launch blocking.
- **Reference / backend / Flutter:** system board shows maintenance/update;
  no inspected auth/bootstrap route or version policy provides these states.
- **Missing:** route/config, version comparison, bypass policy, timestamps.
- **Impact:** client cannot truthfully display or enforce.
- **Temporary / blocking:** generic server unavailable only; **not blocking**
  auth, blocks those state implementations.
- **Owner / resolution:** backend/platform/product.

## AUTH-GAP-12 — Current user/profile confirmation

**Implementation update (19 July 2026):** the temporary probe is implemented:
`GET /api/v1/auth/devices`, exact current session ID match, and `ACTIVE`
status. No profile is fabricated.

- **Category / desired behavior:** API/session; confirm restored identity/session.
- **Reference / backend / Flutter:** no customer profile `/me`; authenticated
  `GET /api/v1/auth/devices` exists and JWT filter validates current session.
- **Missing:** customer profile endpoint and explicit session-confirmation
  purpose; list also includes historical sessions.
- **Impact:** first slice can confirm bearer/session but cannot hydrate
  authoritative customer profile.
- **Temporary / blocking:** call devices, match returned login session ID and
  require `ACTIVE`; end at placeholder. **Blocks Phase C until backend/product
  accepts this probe or supplies `/me`.**
- **Owner / resolution:** backend/product/mobile; preferably add minimal
  customer `/me`/session response.

## AUTH-GAP-13 — Restriction reason and recovery action

- **Category / desired behavior:** API/UX; precise suspended/locked/closed next
  step without internal disclosure.
- **Reference / backend / Flutter:** generic restricted board; backend returns
  state code and raw status message, no safe reason/action.
- **Missing:** safe reason category, support/verification route, whether closed
  is permanent UI.
- **Impact:** user may have no actionable next step; raw message is unsafe.
- **Temporary / blocking:** state-specific generic localized copy and return to
  login; **blocks Phase D copy approval**, not infrastructure.
- **Owner / resolution:** product/backend/security/language owners.

## AUTH-GAP-14 — Flutter error-envelope mismatch

**Implementation update (19 July 2026):** closed. Central parsing reads
`error.code`, safe validation metadata, `meta.traceId`, and `X-Trace-Id`.

- **Category / desired behavior:** Flutter foundation; map exact backend errors.
- **Reference / backend / Flutter:** backend uses `error.code` and
  `meta.traceId`/`X-Trace-Id`; `FailureInterceptor` reads top-level `code` and
  `requestId`/`x-request-id`.
- **Missing:** correct nested parsing and status-aware generic mapping.
- **Impact:** restriction/session codes currently collapse to generic server
  errors and diagnostics lose trace ID.
- **Temporary / blocking:** none safe for implementation; **blocks Phase A**.
- **Owner / resolution:** Flutter; update parser with contract tests, preserving
  sanitized logging.

## AUTH-GAP-15 — Access-token storage mismatch

**Implementation update (19 July 2026):** closed. Authorization reads a
testable memory token source; only refresh/session material uses named
`SecureStore` keys.

- **Category / desired behavior:** Flutter security; memory-only access token.
- **Reference / backend / Flutter:** security contract requires in-memory access
  token; current interceptor reads `SecretKeys.accessToken` from `SecureStore`.
- **Missing:** central session token provider/interceptor integration and atomic
  refresh persistence.
- **Impact:** inconsistent lifecycle and stale-token races.
- **Temporary / blocking:** no authentication implementation until designed;
  **blocks Phase B**.
- **Owner / resolution:** Flutter/security; inject a testable in-memory token
  source and keep rotating refresh in secure storage.

## AUTH-GAP-16 — Logout confirmation visual

- **Category / desired behavior:** visual/product; determine whether explicit
  logout needs confirmation.
- **Reference / backend / Flutter:** drawer shows Logout; no approved
  confirmation screen; `IbaConfirmationDialog` exists.
- **Missing:** product requirement and binding visual.
- **Impact:** inventing a dialog violates reference governance; skipping one may
  surprise product.
- **Temporary / blocking:** direct explicit logout; **not blocking** if product
  accepts, otherwise Phase D blocks for reference.
- **Owner / resolution:** product/design.

## AUTH-GAP-17 — Distinct suspended and closed visuals

- **Category / desired behavior:** visual; faithfully represent distinct account
  states.
- **Reference / backend / Flutter:** generic Account Restricted frame; backend
  distinguishes three codes; no feature screen exists.
- **Missing:** approved distinct screens or approval to reuse generic
  composition with reviewed state copy.
- **Impact:** over-specific visual invention or under-specific messaging.
- **Temporary / blocking:** `AUTH-VRC-08` generic composition; **blocks Phase D
  visual sign-off**.
- **Owner / resolution:** product/design/accessibility.

## AUTH-GAP-18 — Refresh network uncertainty

- **Category / desired behavior:** security/session; recover safely when refresh
  response is lost after server rotation.
- **Reference / backend / Flutter:** single-use refresh rotation and reuse family
  revocation; no idempotency/reconciliation endpoint.
- **Missing:** safe retry/recovery protocol.
- **Impact:** retrying old token may revoke the family; preserving it may leave
  unusable state.
- **Temporary / blocking:** terminate local session and require login after
  uncertain refresh; **not blocking** if product accepts conservative recovery.
- **Owner / resolution:** backend/security/mobile; consider idempotent refresh
  exchange or documented grace/reconciliation design.
