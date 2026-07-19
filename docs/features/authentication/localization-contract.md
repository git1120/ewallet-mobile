# Authentication localization contract

## Locale and copy rules

English (`en`), Dari (`fa`), and Pashto (`ps`) are required at the same feature
milestone. Source strings belong in all three ARB files under
`lib/app/localization/arb/`, followed by normal `gen-l10n`; generated Dart is
never edited manually.

The English below is a proposed semantic inventory, not approval to hardcode
copy. Final Dari and Pashto wording requires linguistic/product review and is
therefore recorded as `REVIEW_REQUIRED`, not invented here. Review must cover
formal register, the accepted term for PIN, punctuation/digits, support wording,
and whether “mobile number” or a local equivalent is preferred.

Backend messages/codes are never displayed or translated directly. Unknown
mobile and wrong PIN use the same non-enumerating credential message.

## Key inventory

| Proposed ARB key | English source intent | Dari (`fa`) | Pashto (`ps`) |
|---|---|---|---|
| `authLoginScreenTitle` | Welcome back | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authLoginScreenSemanticLabel` | Sign in to IBA E-Wallet | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authMobileLabel` | Mobile number | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authMobileHint` | Enter your registered mobile number | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authMobileRequired` | Enter your mobile number. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authMobileInvalid` | Enter a valid 10-digit mobile number. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authContinue` | Continue | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authPinScreenTitle` | Enter your PIN | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authPinInstruction` | Enter your 6-digit PIN to continue. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authPinFieldLabel` | 6-digit PIN | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authPinRequired` | Enter your 6-digit PIN. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authChangeMobile` | Change number | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authSigningIn` | Signing in… | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authInvalidCredentials` | The mobile number or PIN is incorrect. Try again. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authAccountTemporarilyLockedTitle` | PIN temporarily locked | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authAccountTemporarilyLockedMessage` | For your security, PIN login is temporarily unavailable. Try again later. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authAccountSuspendedTitle` | Account suspended | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authAccountSuspendedMessage` | You cannot sign in to this account right now. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authAccountLockedTitle` | Account restricted | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authAccountLockedMessage` | You cannot sign in to this account right now. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authAccountClosedTitle` | Account closed | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authAccountClosedMessage` | This account is closed and cannot be used to sign in. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authSessionExpiredTitle` | Session expired | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authSessionExpiredMessage` | For your security, sign in again to continue. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authSessionEndedTitle` | Session ended | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authSessionEndedMessage` | Sign in again to continue. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authLoginAgain` | Sign in again | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authCheckingSession` | Checking your secure session… | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authOfflineTitle` | No internet connection | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authOfflineMessage` | Check your connection and try again. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authServerUnavailableTitle` | Service unavailable | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authServerUnavailableMessage` | We cannot sign you in right now. Try again later. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authRetry` | Try again | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authLogout` | Log out | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authLoggingOut` | Logging out… | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authLogoutFailedLocalComplete` | You have been logged out on this device. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authPrivacyPinMessage` | Never share your PIN. IBA staff will never ask for it. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |
| `authGenericError` | Something went wrong. Try again. | `REVIEW_REQUIRED` | `REVIEW_REQUIRED` |

Support/contact, forgot-PIN, biometric, signup, maintenance, update-required,
and lock-countdown keys are deliberately absent from the first-slice inventory
until their routes/behavior are approved.

## Direction and formatting

- English is LTR; Dari and Pashto are RTL through Flutter delegates.
- Layout, back/forward icons, field/action order, padding, and focus traversal
  adapt directionally. The hierarchy does not change.
- Mobile-number value, `+93`, trace/reference value if ever exposed for support,
  and technical identifiers are isolated controlled-LTR spans inside RTL UI.
- Do not reverse strings. Validate Afghan digit input/normalization with
  language/product owners before accepting non-ASCII digits.
- Test realistic long reviewed translations at 100% and 200% on narrow and wide
  constraints. No layout relies on English length.

## Review gate

Phase D cannot exit until language owners approve all first-slice `fa`/`ps`
values and product approves the English source. ARB keys are added only during
implementation; this analysis does not modify localization sources.
