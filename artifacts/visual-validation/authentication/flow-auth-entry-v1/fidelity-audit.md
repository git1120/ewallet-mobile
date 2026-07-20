# `flow-auth-entry-v1` measured fidelity audit

## Measurement basis

- Approved source:
  `design-references/flows/authentication/customer-authentication-entry-states-en-ltr-v1.png`
- Source board: 1672×941 pixels, EN/LTR.
- Audited regions: third phone (mobile entry) and fourth phone (six-digit PIN).
- Approximate source phone bounds measured from the original board:
  mobile `(672, 58)–(980, 855)` and PIN `(1009, 58)–(1319, 855)`.
- Implementation comparison viewport: 412×915 logical pixels, portrait,
  100% text, with safe-area insets applied outside the measured content.
- Source-board coordinates below are measured to the nearest 2–4 pixels.
  Target logical values use independent horizontal and vertical proportional
  mapping because the composite phone mockup is narrower than the Android
  target. Platform font rasterization and system chrome are not treated as
  layout drift.
- The original geometry column records the pre-correction baseline. The final
  reassessment uses the four clean 412×915 EN/LTR and FA/RTL screenshots in
  `implementation/`.

## Region audit

| Region | Approved geometry | Current geometry before pass | Difference | Component involved | Required correction | Security/accessibility constraint | Status |
|---|---|---|---|---|---|---|---|
| Page background | Full phone; near-white surface | Full viewport `IbaColors.background` (`#F7F6F1`) | Slightly warmer than the phone surface | `Scaffold`, theme | Retain semantic background unless screenshot comparison proves material color drift | Contrast and theme consistency | Pending screenshot |
| Top controls | Mobile: 40×40 back at source-relative `(16,57)` and language at `(254,57)`; PIN: 40×40 back at `(16,57)` | Mobile has none; PIN has one 48×48 back at content y=16 | Mobile controls absent; PIN is too high and uses a physical back arrow | `IbaIconButton`, screen composition | Keep unsupported root back/language actions omitted and reserve approved header space; use direction-aware back on PIN | No dead or misleading action; 48×48 target | Deviation required / correction planned |
| Header / brand / security mark | Mobile gold brand mark about 78×86 source px, centered around source-relative y=125–211; PIN green shield circle about 52×58 at y=96–154 | Mobile now uses the byte-preserved approved IBA seal at 88px through `IbaBrandMark`; PIN retains a separate 56px security shield through the explicit fallback variant | The approved official seal replaces the temporary primary mark while preserving its measured box and clear space; the PIN cue remains non-redundant security meaning | `IbaBrandMark` | No further branding correction required | Brand label is semantic on mobile; the separate decorative security cue is excluded | Approved and resolved |
| Title and supporting copy | Mobile title center near target y≈268, subtitle y≈322; PIN title y≈204, instruction y≈249 | Mobile title begins near y≈144; PIN title near y≈152 | Both groups are substantially too high | Screen composition, theme text | Introduce measured header/hero spacing while preserving text reflow | 200% text may reflow/scroll | Correction planned |
| Mobile-number presentation | Label and field target y≈378–458; field spans about 370 logical px with 12px radius | Label/field begins around y≈236; content width 364; generic floating-label field | About 140px too high; generic treatment | `IbaPhoneField`, `IbaTextField` | Add a reusable country/mobile presentation and match height, border, focus, and radius without a local fork | Exact ten-digit controller value; controlled LTR; associated errors | Correction planned |
| Country code / flag treatment | Afghanistan indicator, selector chevron, separator, `+93`, and grouped national number | No country indicator or prefix | Entire visible treatment absent | `IbaPhoneField` | Add a non-interactive Afghanistan indicator to the reusable field; do not imply unsupported country switching. Keep backend-authoritative ten-digit input and document why `+93` cannot be paired with an unchanged leading zero as if it were one number | No fabricated selector; serialization remains exactly ten digits | Contract-limited correction |
| PIN heading and indicators | Six 16–18px circles centered near target y≈342; roughly 28–34px center spacing | Six 16px circles with 16px horizontal padding, near y≈237 | Size close; group is about 105px too high and too wide | `IbaPinKeypad` | Add explicit indicator geometry and move group to measured position | Always obscured; excluded from value semantics | Correction planned |
| Keypad width | Source uses nearly full phone content width; target about 380px with ≈16px sides | 364px with 24px screen sides | About 16px too narrow | `IbaPinKeypad`, screen padding | Use 16px compact side inset and constrained reusable keypad width | Equal directional spacing; no horizontal overflow | Correction planned |
| Keypad button diameter / size | Reference keys are rounded rectangles, target about 121×64 | About 116×70 from grid aspect ratio 1.65 | Too narrow/tall | `IbaPinKeypad` | Change aspect ratio/extent to measured 64px height and preserve reusable minimum size | At least 48×48 | Correction planned |
| Keypad row and column gaps | Source gaps map to about 6–8 logical px | 8px both axes | Close | `IbaPinKeypad` | Preserve 8px token gap and validate centering | Equal spacing in LTR/RTL | Verify |
| Delete / backspace placement | Fourth row, trailing column; compact outlined backspace icon | Fourth row, trailing column | Placement correct; icon/button styling differs | `IbaPinKeypad` | Keep trailing logical placement and simplify surface/elevation to match | Localized semantic label; direction remains understandable | Correction planned |
| Primary action placement | Mobile Continue target y≈484–543; PIN auto-submit at six digits, no extra submit button | Mobile Continue near y≈316; PIN auto-submit is correct | Mobile action about 165px too high | `IbaButton`, screen composition | Move mobile action to measured position; keep single guarded PIN auto-submit | One submission at a time; loading disables entry | Correction planned |
| Secondary action placement | Mobile board has divider, Create Account and Need help; PIN has Change number and Forgot PIN above keypad; biometric panel below | Unsupported actions omitted; Change number appears below keypad | Contract-safe omission is documented, but supported Change number is misplaced | Screen composition, `IbaTextButton` | Move Change number above keypad. Keep unsupported actions absent; preserve spacing without fake controls | No signup/help/recovery/biometric behavior | Deviation required / correction planned |
| Safe-area spacing | Approved phone uses status area then controls around target y≈65 | SafeArea exists; content begins y=16 | Content enters approved header zone | `SafeArea`, scroll layout | Reserve measured top region while keeping runtime system insets | Must remain reachable with keyboard and display cutouts | Correction planned |
| Lower navigation / reassurance | Mobile privacy panel near target y≈790–851; PIN biometric panel near y≈785–866 | Mobile alert follows content near upper-middle; PIN has no lower panel | Mobile panel far too high; unsupported PIN panel omitted | `IbaAlertBanner`, screen layout | Anchor mobile reassurance near bottom in normal viewport; omit unsupported biometric panel with deviation | No misleading biometric availability | Correction planned / deviation |
| Error placement | Supporting boards place concise inline error immediately with affected input/task | Mobile uses field error; PIN uses a full-width alert above indicators/keypad | Mobile broadly correct; PIN alert changes vertical geometry significantly | `IbaTextField`, `IbaAlertBanner` | Use compact inline task error while preserving announcement and stable keypad position where possible | Error announced once; non-enumerating copy; color-independent | Correction planned |
| Loading treatment | In-place loading/disabled state; layout remains stable | Separate `IbaLoadingState` appears below keypad and Change number | Adds height and shifts composition | `IbaPinKeypad`, `IbaLoadingState` | Use compact in-place signing-in status in the action row; keep keypad disabled | Polite status semantics; no duplicate submit; reduced motion | Correction planned |
| RTL mirroring | Directional top/action order; labels mirror; phone and PIN values remain LTR; keypad numeric order remains stable | Page direction mirrors; phone text is LTR; PIN keypad forces LTR | Core bidi behavior is sound; physical back icon and row placement need review | Directional layout, `IbaIconButton`, fields/keypad | Use direction-aware back icon and directional alignment; retain numeric keypad LTR | Do not reverse phone/PIN digits or keypad | Correction planned |
| Narrow-width behavior | Preserve hierarchy with controlled scroll; target widths 360–430 | Single scroll view and maxWidth 412; 24px sides | Functional but approved compact width/keypad proportions drift | Screen layout, keypad | Use constraint-driven compact padding and vertical scroll; test 360×800, 390×844, 412×915, 430×932 | No target below 48×48; action reachable | Correction planned |
| 200% text behavior | Reflow/scroll; keypad remains tappable and action reachable | Existing automated RTL 200% smoke has no exception | Coverage is too coarse and does not exercise PIN geometry/action reachability | Screen tests | Add mobile/PIN reachability and no-overflow checks at 200% | Do not shrink approved text to preserve geometry | Test expansion planned |
| Authentication transition | No approved branded transition; only in-place loading is allowed | In-place loading under keypad | Correct state class but wrong placement | PIN composition | Keep in-place status and do not invent a transition screen | No optimistic success; confirmation remains server-authoritative | Correction planned |

## Design Deviation Records

### DDR-AUTH-ENTRY-01 — Approved brand assets

- Reference / path / region: `flow-auth-entry-v1`; third-phone brand mark.
- Approved behavior: centered gold IBA security/brand artwork.
- Resolution: use the existing approved IBA PNG assets copied byte-for-byte
  from `web/public/images/iba-logo.png` and `web/public/images/logo_white.png`
  into `assets/branding/`.
- Implementation: `IbaBrandMark` renders the standard asset in the primary
  light-surface authentication brand region without runtime recoloring,
  cropping, distortion, or an admin-panel runtime dependency. The white-backed
  variant is reserved for dark/green surfaces.
- Integrity: copied SHA-256 values match their sources and are recorded in
  `assets/branding/README.md`.
- Fallback: the geometric mark remains permitted only for an explicitly
  separate security/reassurance concept, such as the PIN shield.
- Approver / status: user acting as product/brand authority; **Approved and
  resolved** on 20 July 2026.

### DDR-AUTH-ENTRY-02 — Unsupported reference actions

- Reference / regions: mobile Create Account / Need help / root controls; PIN
  Forgot PIN / Use Biometric; supporting-board OTP-first, countdown, and
  attempt-counter treatments.
- Approved behavior: visible interactive actions.
- Closest safe implementation: omit unsupported actions and preserve the
  remaining approved spacing/hierarchy; keep supported Change number.
- Reason: no first-slice API, route, or reviewed biometric architecture exists.
- Impact: visible density differs from the approved board.
- Alternatives considered: active controls (unsupported and misleading);
  disabled controls (still suggests unavailable product capability); inert
  lookalikes (misleading and inaccessible).
- Exact decisions: signup, help, forgot PIN, and biometric are **omitted** and
  **deferred** to separately contracted flows; OTP-first is **omitted** and
  covered by a separate future login contract; countdown and attempt counter
  are **omitted** until authoritative backend values and a future contract
  exist. None is visually represented as enabled or disabled in this slice.
- Permanence: deferred until those separate contracts and routes exist.
- Approver / status: user acting as product/design authority; **approved** on
  20 July 2026 (`AUTH-GAP-03/04/05/10`).

### DDR-AUTH-ENTRY-03 — Mobile country-code display

- Reference / region: mobile field Afghanistan flag, selector, `+93`, grouped
  national number.
- Approved behavior: country treatment appears as part of the entered number.
- Closest safe implementation: show a non-interactive Afghanistan country
  indicator while the editable controlled-LTR value remains the exact
  backend-authoritative ten-digit local number.
- Reason: the accepted first-slice contract serializes ten ASCII digits and
  explicitly forbids implicit `+93` conversion. Prefixing `+93` to an unchanged
  leading-zero value would visually assert a different, malformed identifier.
- Impact: country context can match, but the exact prefix/value composition
  cannot.
- Alternatives considered: silently convert nine displayed digits (contract
  violation); show `+93 07…` as one number (misleading); omit all treatment
  (larger visual drift).
- Permanence: until product/backend approves exact normalization examples.
- Approver / status: user acting as product/backend/design authority;
  **approved** on 20 July 2026 (`AUTH-GAP-01` first-slice limitation). This
  backend-compatible presentation must not be reinterpreted by later agents.

### DDR-AUTH-ENTRY-04 — PIN mobile-number masking

- Reference / region: full mobile number above PIN indicators.
- Approved behavior: unmasked formatted number.
- Closest safe implementation: controlled-LTR country context with only the
  final four digits visible.
- Reason: the authentication security contract treats the mobile identifier as
  sensitive, and task evidence must not expose it.
- Impact: text width differs while hierarchy and emphasis remain.
- Alternatives considered: full number (privacy conflict); omit number
  (greater visual/context loss).
- Permanence: security requirement unless privacy review changes.
- Approver / status: user acting as security/product/design authority;
  **approved** on 20 July 2026. This masking requirement must not be
  reinterpreted by later agents.

## Post-integration reassessment

- Logo geometry and scale: the standard seal occupies the existing 88px
  aspect-ratio-preserving brand box and remains visually legible at 412×915.
- Clear space and header balance: the measured 128px hero lead-in, 24px gap to
  title, and surrounding whitespace remain unchanged; no title, field, or
  reassurance landmark moved materially.
- Relationship of marks: mobile has one official identity mark; PIN has one
  separate security shield. They are never shown redundantly on one screen.
- Contrast: the standard green seal is clear on the light authentication
  surface. The white-backed variant is gallery-verified on institutional green
  and is not needed on these light screens.
- Narrow/RTL: 360×800 reflow remains scroll-safe. FA/RTL screenshot evidence
  keeps the centered logo and mirrors directional controls; PS/RTL follows the
  same tested layout.
- Accessibility: identity use exposes the localized app name; decorative
  fallback use is excluded. Automated 200% text and no-overflow coverage
  remains green.

The missing-asset blocker is closed. The implemented mobile and PIN regions are
accepted with approved `DDR-AUTH-ENTRY-02`, `DDR-AUTH-ENTRY-03`, and
`DDR-AUTH-ENTRY-04`; Android TalkBack runtime and language-owner review remain
reported limitations rather than new visual blockers.
