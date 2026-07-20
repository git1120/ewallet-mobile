# Authentication Visual Reference Contracts

## Shared interpretation

These contracts resolve regions inside composite boards; no board is treated as
one screen. Target implementation viewport must be recorded before Phase D.
Until then, the viewport contract is compact portrait Android with safe areas,
validated initially at 360×800 and 412×915 logical pixels and compared against
the proportional phone artboard. English is LTR; Dari and Pashto mirror
directionally without changing hierarchy. Phone values remain controlled LTR.

Shared component mapping is `IbaButton`, `IbaTextButton`, `IbaPhoneField` or a
broad reusable extension, `IbaPinField` or a broadly reusable secure PIN-entry
extension, `IbaAlertBanner`, `IbaLoadingState`, `IbaErrorState`, and
`IbaPageScaffold` where their current contracts fit. Material defaults may not
replace reference-specific geometry.

## AUTH-VRC-01 — Mobile login, default

| Field | Contract |
|---|---|
| Contract / reference / image | `AUTH-VRC-01`; `flow-auth-entry-v1`; `design-references/flows/authentication/customer-authentication-entry-states-en-ltr-v1.png`. |
| Visible board region | Third phone: “Welcome back” mobile-number entry. |
| Surface / feature / screen / state | Customer / authentication / mobile login / default. |
| Viewport / orientation / locale / direction | Compact portrait; EN/LTR board. Required adaptations: en/LTR, fa/RTL, ps/RTL. |
| Entry condition | Bootstrap concluded unauthenticated, or user chose change number. |
| Exit conditions | Valid Continue → PIN entry; Create Account and Need help remain unavailable until their contracts exist. |
| Primary / secondary actions | Continue. Visible Create Account and Need help are omitted/deferred under approved `DDR-AUTH-ENTRY-02` and `AUTH-GAP-04`; no dead or disabled lookalike is shown. Language action remains visible only if the surrounding flow includes it. |
| Fixed / scrollable elements | Safe-area top actions and bottom privacy reassurance follow the board; content scrolls/reflows when keyboard, translation, or 200% text requires it. Primary action remains reachable, never obscured. |
| Components | Approved standard PNG through shared `IbaBrandMark`, localized text, phone input, `IbaButton`, optional `IbaTextButton`, security reassurance. Asset provenance and hashes are recorded in `assets/branding/README.md`. |
| Typography / spacing / radii | Preserve centered mark/title/subtitle hierarchy, full-width field and button, generous vertical grouping, rounded field/button, and smaller reassurance-container radius relationship. Use repository semantic tokens only after measured mapping. |
| Icon behavior | Back and language icons are directional/semantic controls; flag/country selector is not permission to accept arbitrary country identifiers. The official identity mark exposes the localized app name; the separate PIN security fallback is decorative and excluded. |
| Keyboard behavior | Phone keyboard; no autofocus on entry unless product/accessibility review accepts it. Next/submit invokes the same single guarded Continue action. Phone remains visible above keyboard. |
| Loading / validation / error / disabled | Default has no error. Local empty/format errors are inline and announced. While advancing, button may show the approved loading state and duplicate actions are disabled. Backend credential errors belong to PIN state, not the phone field. |
| Session / responsive behavior | No token/storage mutation. On wide web validation target, constrain the portrait composition rather than expanding/reordering it. |
| Accessibility adaptations | Semantic screen title, explicit mobile label, 48×48 controls, logical focus, visible focus, 200% reflow, controlled-LTR number in RTL. |
| Allowed / prohibited deviations | Allowed: safe-area, keyboard, RTL, translation, text-scale reflow; Android system chrome. Prohibited: merging OTP, PIN, and mobile into an invented screen; changing hierarchy/colors/radii; using the four-digit board. |
| Backend dependencies / tests | Ten-digit `mobileNumber`; local normalization decision. Widget tests for three locales, validation, submit once, keyboard, focus, semantics, 200%, narrow/wide. Visual comparison at recorded target. |

## AUTH-VRC-02 — Mobile login, focused and locally invalid

| Field | Contract |
|---|---|
| Contract / reference / region | `AUTH-VRC-02`; `component-input-form-v1`; phone input and default/focused/error regions, composed inside the `AUTH-VRC-01` screen. |
| Surface / screen / state | Customer authentication / mobile login / focused or local validation error. |
| Viewport / locale / direction | Same as `AUTH-VRC-01`; neutral/bidi component board adapted to all locales. |
| Entry / exit | Field receives focus; correction returns valid/default; valid submit advances to PIN. |
| Primary / secondary actions | Continue stays primary; it does not fire for invalid local input. |
| Fixed / scrollable / components | Screen composition remains unchanged; focused/error field uses shared input plus localized associated error. |
| Typography / spacing / radii / icons | Preserve label above/within the approved field pattern, green focus outline, red outline plus text/icon for error, and surrounding screen geometry. Error must not cause action clipping. |
| Keyboard / loading / validation / error / disabled | Phone keyboard. Validate required and exact normalized ten-digit shape. Do not claim account existence. Error is text plus semantics, not color alone. Loading is not part of this state. |
| Session / responsive / accessibility | No session mutation. Focused outline remains visible; error is announced once and focus stays or moves to first actionable invalid field. Reflow at 200%. |
| Allowed / prohibited deviations | Error wording may be localized; no backend code/message, nationality assumption, or unsupported nine-digit rule from the component board. |
| Backend dependencies / tests | `LoginRequest.mobileNumber` validation. Test focused styling contract, ten-digit serialization boundary, RTL mixed direction, error association/announcement. |

## AUTH-VRC-03 — Six-digit PIN entry

| Field | Contract |
|---|---|
| Contract / reference / image | `AUTH-VRC-03`; `flow-auth-entry-v1`, fourth phone; related `component-security-privacy-v1` PIN pattern and `component-input-form-v1`. |
| Surface / feature / screen / state | Customer / authentication / PIN login / default, focused, partially entered, locally invalid. |
| Viewport / orientation / locale / direction | Compact portrait; en/LTR source, required fa/ps RTL. Mobile number is controlled LTR. |
| Entry / exit | Entered after a locally valid mobile number; six digits trigger or enable guarded submission according to product decision. Success enters authenticated-unverified; change number returns to mobile. |
| Primary / secondary actions | Numeric entry is primary task. Change number is supported. Forgot PIN and Use Biometric are omitted/deferred under approved `DDR-AUTH-ENTRY-02`; they are not shown as enabled or disabled capabilities. |
| Fixed / scrollable elements | Header/security mark, title/subtitle, security-required masked/formatted number under approved `DDR-AUTH-ENTRY-04`, dot row, keypad/action area. Scroll/reflow only as needed for safe areas, keyboard, and text scale. |
| Components | Secure PIN input/keypad must be a shared design-system variation if `IbaPinField` cannot reproduce the board; no feature-local fork. |
| Typography / spacing / radii | Preserve centered title, number emphasis, evenly spaced six indicators, three-column keypad rhythm, and bottom biometric panel relationship. |
| Icon behavior | Back/change icons direction-aware; delete removes one digit; biometric icon/action is not active in first slice. PIN visibility must remain obscured by default. |
| Keyboard behavior | Use one input model. If native numeric keyboard is used instead of board keypad, that is a visual deviation requiring approval. Submit once at six digits or explicit action as approved. |
| Loading / validation / error / disabled | Partial entry is not an error. Non-digits are rejected. Fewer/more than six cannot submit. On submit, input/actions disable. Invalid credentials clear PIN and move to `AUTH-VRC-05`. |
| Session behavior | PIN is ephemeral: never persisted/logged/restored; clear on submit completion, background/lifecycle loss, route exit, session event, or disposal. |
| Responsive / accessibility | Preserve keypad grouping; at 200%, allow content scroll without shrinking targets. Each keypad key and action is at least 48×48. Screen-reader output must never speak entered digits. |
| Allowed / prohibited deviations | Six digits are mandatory. Prohibited: four-digit pattern, OTP wording, exposing PIN, active unsupported recovery/biometric actions, custom non-shared fork. |
| Backend dependencies / tests | `pin` exactly six digits. Tests: obscured semantics, digit count, delete, submit once, secret clearing, lifecycle, RTL, 200%, keyboard/focus. |

## AUTH-VRC-04 — Login submitting

| Field | Contract |
|---|---|
| Contract / reference / region | `AUTH-VRC-04`; `component-button-v1` loading/disabled states and `component-feedback-status-v1` loading indicators, within `AUTH-VRC-03`. No approved full-screen submitting mockup exists. |
| Surface / state / viewport | Customer PIN login / submitting credentials / same portrait screen. |
| Entry / exit | One six-digit submission; success → authenticated-unverified; controlled/network failure → corresponding state; cancellation/stale result → no navigation. |
| Actions / fixed/scrollable | Disable PIN, delete, back/change-number, recovery, biometric, and repeated submit while request is active. Keep layout stable. |
| Components / hierarchy / spacing/radii/icons | Approved `IbaButton` loading variation if an explicit button exists; otherwise a measured in-place indicator with no new full-screen composition. Spinner is decorative when a live label announces status. |
| Keyboard / loading / validation / error / disabled | Dismiss or retain keyboard only per measured layout; announce “Signing in” once. No optimistic success. Validation is complete before entry. |
| Session / responsive / accessibility | No persistence before full response parse. Cancel token belongs to controller. At 200%, progress and title remain visible; reduced motion uses static progress semantics. |
| Allowed / prohibited deviations | Allowed: in-place loading based on component board. Prohibited: inventing a branded transition screen, changing button width, duplicate requests, or implying success. |
| Backend dependencies / tests | Login route, cancellation, generation guard. Test disabled actions, one request, announcement, late response ignored, reduced motion. |

## AUTH-VRC-05 — Invalid credentials

| Field | Contract |
|---|---|
| Contract / reference / region | `AUTH-VRC-05`; PIN error region in `component-input-form-v1`, inline error in `foundation-api-error-v1`, inside `AUTH-VRC-03`. |
| Surface / state | Customer PIN login / backend `PIN_INVALID` or generic unauthorized unknown-user result. |
| Entry / exit | Controlled login failure; correction/resubmission → submitting; change number → mobile. |
| Primary / secondary | Re-enter PIN is primary. Do not reveal whether mobile number exists. |
| Fixed/scrollable / components | Preserve PIN screen; clear indicators, associate localized generic error with PIN task, focus secure input/keypad. |
| Typography / spacing / radii / icon | Approved error text/icon/color relationship without layout redesign or backend code. |
| Keyboard / loading / validation / disabled | Loading ends; PIN clears. Mobile number may be retained. Actions re-enable unless restriction state follows. |
| Session / responsive / accessibility | No credentials persisted. Announce one generic invalid-mobile-or-PIN message; do not flood repeat announcements. Reflow without clipping. |
| Allowed / prohibited deviations | Backend source wins over error board’s HTTP 400. Prohibited: remaining-attempt claim, account-existence disclosure, backend message/code. |
| Backend dependencies / tests | Generic unauthorized and `PIN_INVALID` both map to non-enumerating copy. Test mapping from nested `error.code`, PIN clearing, focus/error semantics, no sensitive logs. |

## AUTH-VRC-06 — Login offline or server unavailable

| Field | Contract |
|---|---|
| Contract / reference / region | `AUTH-VRC-06`; offline and service-unavailable frames of `flow-system-states-v1`, network region of `component-feedback-status-v1`. |
| Surface / screen / state | Customer authentication / login recoverable failure / offline or server unavailable (distinct). |
| Viewport / locale / direction | Compact portrait, all locales/directions. |
| Entry / exit | Transport failure before confirmed login response. Retry returns to guarded submitting; change number/back returns safely. |
| Primary / secondary | Retry is primary. Offline Help/Contact Support shown in boards require supported destinations and are otherwise omitted under a documented gap. |
| Fixed/scrollable / components | Prefer an inline/full-screen state consistent with the selected exact frame; retain mobile number, clear PIN. |
| Typography / spacing / radii / icon | Preserve illustration/title/explanation/info-box/action hierarchy; offline and server error use distinct icons and localized copy. |
| Keyboard / loading / validation / disabled | End loading, re-enable retry, clear secret. Do not automatically retry login. |
| Session / responsive / accessibility | No session is assumed even if outcome is uncertain; late response generation guard applies. State is text/icon/semantics, not color alone. 200% scrolls. |
| Allowed / prohibited deviations | No technical error codes, timestamps, false maintenance claim, or network auto-loop. |
| Backend dependencies / tests | Dio transport/server classification and cancellation. Tests for offline versus 5xx, explicit retry only, retained mobile/cleared PIN, semantics/RTL. |

## AUTH-VRC-07 — Temporary PIN lock

| Field | Contract |
|---|---|
| Contract / reference / region | `AUTH-VRC-07`; PIN Locked frame in `flow-pin-recovery-v1`, locked security state in `component-security-privacy-v1`. |
| Surface / state | Customer login / temporary `PIN_LOCKED` or `ACCOUNT_TEMPORARILY_LOCKED`. |
| Entry / exit | Backend 429 lock result; return to login only for a later explicit attempt, or supported help destination. |
| Primary / secondary | The board shows Go to Login and Contact Support. A countdown/action such as “Try again after” is prohibited until backend returns authoritative expiry. |
| Fixed/scrollable / components | Full-screen restricted composition: lock illustration, title, calm explanation, permitted actions. |
| Typography / spacing / radii / icons | Preserve red locked hierarchy and alert container while ensuring contrast and non-color meaning. |
| Keyboard / loading / validation / error / disabled | PIN cleared, keyboard dismissed, credential submit disabled on this state. |
| Session / responsive / accessibility | No session. Announce lock once; title receives focus. Reflow/scroll at 200%. |
| Allowed / prohibited deviations | Required deviation: omit the board’s `14:59` countdown because no expiry is returned. It must be recorded/approved before UI work. Never hardcode configured five minutes. |
| Backend dependencies / tests | 429 plus exact code mapping. Test no countdown/remaining-attempt claim, PIN clearing, blocked resubmit, localized semantics. |

## AUTH-VRC-08 — Account restricted

| Field | Contract |
|---|---|
| Contract / reference / region | `AUTH-VRC-08`; Account Restricted frame in `flow-system-states-v1`. No distinct suspended or closed approved screen exists. |
| Surface / state | Customer authentication / backend `USER_SUSPENDED`, `USER_LOCKED`, or `USER_CLOSED`, represented by a shared restricted composition with state-specific reviewed copy. |
| Entry / exit | Login, refresh, or protected confirmation rejects account status. Exit only to unauthenticated root or a real support/verification route when available. |
| Primary / secondary | The board shows Verify Now and Contact Support; neither may be active without routes/contracts. Safe temporary primary is Return to login after product approval. |
| Fixed/scrollable / components | Full-screen restriction icon/title/explanation/reason panel/action region. Do not display raw backend reason. |
| Typography / spacing / radii / icons | Preserve restricted-state hierarchy and danger semantics without relying on color. |
| Keyboard / loading / validation / disabled | Clear PIN/tokens; no credential form or retry loop on the restricted screen. |
| Session / responsive / accessibility | Restriction is terminal: cancel work, clear local session, route outside protected tree. Focus/announce title and allowed next step; 200% scroll. |
| Allowed / prohibited deviations | Copy may distinguish suspended/locked/closed only after linguistic/product review. Prohibited: inventing reasons, expiry, verification path, or support contact. |
| Backend dependencies / tests | Exact nested backend codes. Tests for each code, terminal cleanup, no protected navigation, generic unknown restriction fallback. |

## AUTH-VRC-09 — Session expired or revoked

| Field | Contract |
|---|---|
| Contract / reference / region | `AUTH-VRC-09`; Session Expired frame in `flow-system-states-v1` and full-screen session mapping in `foundation-api-error-v1`. |
| Surface / state / viewport | Customer authentication / session expired, revoked, refresh reused / compact portrait, all locales. |
| Entry / exit | Terminal refresh/protected-request result; Login Again → unauthenticated mobile login. |
| Primary / secondary | Login Again. “Go to Home” shown in the board is prohibited because protected home is unavailable after session termination. |
| Fixed/scrollable / components | Full-screen clock/lock state, title, calm explanation, optional non-technical inactivity note, primary action. |
| Typography / spacing / radii / icon | Preserve centered illustration/title/body/notice/action hierarchy. Reuse appropriate full-screen message components only if fidelity is achievable. |
| Keyboard / loading / validation / disabled | Dismiss keyboards; cancel loading; no retry of old refresh token. |
| Session / responsive / accessibility | Clear all tokens and sensitive state before exposing login. `REFRESH_TOKEN_REUSED`, `REFRESH_TOKEN_EXPIRED`, `SESSION_REVOKED`, `SESSION_EXPIRED`, and unrecoverable refresh unauthorized converge on terminal cleanup, but analytics may retain coarse non-sensitive category. Focus/announce title once; reflow at 200%. |
| Allowed / prohibited deviations | User copy does not expose reuse detection or codes. Prohibited: Go Home, refresh loop, retaining stale protected screen, or promising a cause not established. |
| Backend dependencies / tests | Refresh/access error codes, serialized refresh coordinator, router redirect. Test cleanup-before-navigation and one terminal event for concurrent failures. |

## States without sufficient visual/product basis

No screen contract is created for:

- a distinct suspended screen;
- a distinct closed screen;
- a branded authenticated-transition screen;
- logout confirmation;
- maintenance or minimum-version blocking;
- remaining attempts or lock countdown.

They are registered in `contract-gaps.md`. Authentication transition may use
only the in-place loading behavior in `AUTH-VRC-04` until a screen reference is
approved. Logout proceeds directly unless product supplies a confirmation
requirement and approved visual.
