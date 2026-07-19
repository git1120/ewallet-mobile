# Authentication reference map

## Inspection method

`dart run tool/list_design_references.dart --feature=authentication` resolved
the two feature records. Related onboarding, signup, recovery, session,
security, system-state, navigation, input, button, feedback, and error boards
were then resolved from the manifest and visually inspected at original
resolution. No approved image was modified.

The displayed mobile frames are portrait customer artboards with iPhone-style
status/home indicators. The manifest records composite-board dimensions, not a
normative logical Flutter viewport. Individual frame widths are illustrative;
implementation must select and record a target Android logical viewport before
pixel comparison.

## Binding and flow boards

| Reference | Path / dimensions | Type and visible screens | Visible state/copy/actions | Backend support / phase / authority |
|---|---|---|---|---|
| `flow-auth-entry-v1` | `design-references/flows/authentication/customer-authentication-entry-states-en-ltr-v1.png`, 1672×941 | Approved customer flow board: splash, language chooser, mobile-number entry, six-digit PIN entry, biometric login. EN/LTR. | “Welcome back”; mobile number; Continue/Create Account/Need help; PIN dots/keypad, Change number/Forgot PIN/Use Biometric; fingerprint scan/use PIN. | Mobile + six-digit PIN is **supported now** and binding for Phase D. Splash/language are **deferred**. Create account/help/forgot PIN are **blocked or deferred**. Biometric is **supported with clarification** as local-only and deferred. |
| `flow-auth-signup-foundation-v1` | `design-references/flows/authentication/customer-authentication-signup-foundation-en-ltr-v1.png`, 1024×1536 | Approved composite foundation/flow board: splash, language, welcome, OTP mobile/verify, four-digit PIN login/create, biometric, signup success. EN/LTR with Dari/Pashto labels. | Login/Create Account/Send OTP/Resend/forgot PIN/use PIN/dashboard. | Visual language is supporting. OTP-first login and four-digit PIN are **blocked by contract** for login; signup regions are **deferred**. It cannot override `flow-auth-entry-v1` plus backend six-digit PIN. |
| `flow-pin-recovery-v1` | `design-references/flows/session-recovery/customer-pin-recovery-flow-en-ltr-v1.png`, 1536×1024 | Approved recovery flow board with eight mobile frames, including PIN Locked. EN/LTR. | Recovery start, OTP, identity methods, new PIN, success, locked countdown/support. | Recovery is **blocked by API gap/deferred**. The locked composition is visual evidence, but countdown/remaining time and support actions are unsupported for first slice. |
| `flow-system-states-v1` | `design-references/flows/customer/customer-system-empty-states-en-ltr-v1.png`, 1536×1024 | Approved state board: offline, maintenance, update, session expired, account restricted, service unavailable, empty, partial. EN/LTR. | Try again, login again, home, verify, support, update. | Offline, session expired, and service unavailable are **supported now** as presentation patterns. Maintenance/minimum version are **blocked by API/config gap**. Generic restriction is **supported with clarification**; exact suspended/closed art is missing. |
| `flow-security-response-v1` | `design-references/flows/customer/customer-security-response-flow-en-ltr-v1.png`, 1536×1024 | Approved security flow board; active sessions/logout selected sessions is one of eight frames. EN/LTR. | Session list, logout selected, disable biometric, security help. | Device listing/revocation/logout-all are backend-supported but **deferred** beyond current-session logout. Other security response concepts are not first-slice scope. |

## Component and foundation boards

| Reference | Path / dimensions | Type / related concepts | First-slice classification |
|---|---|---|---|
| `component-button-v1` | `design-references/components/buttons/component-button-states-approved-v1.png`, 1536×1024 | Component board: primary/secondary/text/destructive default, pressed, focus, disabled, loading, icon, RTL. | **Supported now** through `IbaButton`/`IbaTextButton`, subject to focus/fidelity review. |
| `component-input-form-v1` | `design-references/components/inputs/component-input-form-states-approved-v1.png`, 1536×1024 | Component board: default/focused/error/disabled/read-only, phone, PIN/password, OTP, RTL. | Phone and six-digit PIN states **supported now**. Existing `IbaPhoneField` formatter accepts up to 12 digits and needs contract-safe composition/extension; do not fork it. |
| `component-navigation-layout-v1` | `design-references/components/navigation/component-navigation-layout-approved-v1.png`, 1536×1024 | Component board: app bars, safe area, sticky action, keyboard, back, drawer logout. | Safe-area/back/keyboard patterns **supported now**. Drawer and logout placement **deferred**. No logout-confirmation visual is provided. |
| `component-security-privacy-v1` | `design-references/components/security/component-security-privacy-approved-v1.png`, 1536×1024 | Component board: masking, PIN keypad, biometrics, session/device list, screenshots, locked state. | PIN/privacy/session principles **supported now**. Biometrics and screenshot platform work **deferred**. |
| `component-feedback-status-v1` | `design-references/components/feedback/component-feedback-status-expanded-approved-v1.png`, 1536×1024 | Component board: alerts, inline errors, loading, network, full-screen errors, dialogs. | Invalid credentials/loading/offline/server error **supported now** as state patterns. |
| `foundation-api-error-v1` | `design-references/foundations/api-error-mapping/foundation-api-error-mapping-approved-v1.png`, 1536×1024 | Foundation board mapping codes to patterns and English/Dari examples. | **Visual-only/supporting**. Codes/statuses shown (`PIN_INVALID` 400, `PIN_LOCKED` 423) conflict with source (`401`, then `429`); backend source controls behavior. |

There is no separate approved overlay reference in the manifest.
`IbaConfirmationDialog` exists in Flutter, but that existence is not a visual
basis for a first-slice logout confirmation.

## Overlap and unsupported visual behavior

- The two auth boards disagree on four versus six PIN digits and on direct PIN
  login versus OTP-first flow. Do not combine them. First slice uses the
  six-digit sequence in `flow-auth-entry-v1`.
- The reference mobile field displays `+93` formatting, while backend requires a
  ten-digit `mobileNumber`. The UI may format, but serialization must be exactly
  the validated backend value.
- Forgot PIN, signup, OTP login, lock countdown, remaining attempts, and server
  biometric login are visually present but unsupported for this slice.
- Approved boards show generic restricted/session screens, but no distinct
  suspended or closed screen and no authenticated-transition screen.
- The error foundation is presentation guidance only; its codes/statuses do not
  establish API truth.
