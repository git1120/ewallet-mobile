# Design-reference status register

No business screen is implemented in this repository slice. All approved flow
boards are therefore `not-started`; component/foundation records are
`foundation-only` where the existing design system provides a partial base.
Routes, pixel review, backend-contract review, and per-screen accessibility/RTL
validation remain unassigned until an implementation task resolves individual
screens from each composite board.

| Feature group | Reference IDs | Surface | State / locale-direction | Implementation | Flutter route/file | Visual | Accessibility | RTL | Backend | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| Authentication/recovery | `flow-auth-entry-v1`, `flow-auth-signup-foundation-v1`, `flow-pin-recovery-v1` | customer | multiple / en-ltr | not-started | — | not-run | not-run | required | pending | Composite boards require per-screen contracts. |
| Transfers/beneficiaries | `flow-transfer-financial-v1`, `flow-transfer-payment-v1`, `flow-recipient-validation-v1`, `flow-transaction-risk-v1`, `flow-beneficiary-v1` | customer | multiple / en-ltr | not-started | — | not-run | not-run | required | pending | Financial truth and recovery require API contracts. |
| Top-up/bills | `flow-top-up-mobile-v1`, `flow-top-up-withdrawal-v1`, `flow-bill-payment-v1` | customer | multiple / en-ltr | not-started | — | not-run | not-run | required | pending | No API behavior inferred from images. |
| Accounts/transactions | `flow-customer-core-v1`, `flow-transactions-v1`, `flow-transaction-history-v1`, `flow-statements-v1`, `flow-account-balance-states-v1`, `flow-transaction-dispute-v1`, `flow-transaction-recovery-v1` | customer | multiple / en-ltr | not-started | — | not-run | not-run | required | pending | Includes visible/hidden balance and recovery states. |
| Profile/settings/support | `flow-profile-security-v1`, `flow-settings-security-v1`, `flow-profile-preferences-v1`, `flow-support-v1`, `flow-notifications-v1`, `flow-legal-consent-v1`, `flow-security-response-v1`, `flow-system-states-v1`, `flow-app-permissions-v1`, `flow-kyc-status-v1` | customer | multiple / en-ltr | not-started | — | not-run | not-run | required | pending | Legal, OS, KYC and security contracts remain authoritative. |
| Staff | `flow-staff-walk-in-v1`, `flow-staff-agent-v1`, `flow-staff-admin-v1`, `flow-staff-reports-v1`, `flow-staff-reports-detail-v1`, `flow-staff-permissions-v1`, `flow-staff-system-settings-v1` | staff | multiple / en-ltr | not-started | — | not-run | not-run | required | pending | Role and API support must be confirmed before implementation. |
| Components | `component-financial-v1`, `component-button-v1`, `component-input-form-v1`, `component-navigation-layout-v1`, `component-feedback-v1`, `component-fintech-v1`, `component-security-privacy-v1`, `component-responsive-navigation-v1`, `component-feedback-status-v1` | shared | multiple / neutral-bidi | foundation-only | `lib/design_system/` | not-run | partial | partial | n/a | Existing components predate these boards; no fidelity claim made. |
| Foundations/supporting | `foundation-design-system-v1`, `foundation-localization-rtl-v1`, `foundation-accessibility-v1`, `foundation-motion-v1`, `foundation-ux-writing-v1`, `foundation-api-error-v1`, `foundation-flutter-map-v1`, `component-screen-patterns-v1` | shared | multiple | foundation-only / n/a | `lib/core/theme/`, docs | not-run | partial | partial | pending/n/a | Supporting mappings never override accepted architecture/contracts. |

Superseded references: none. API-blocked screens: not yet assessed. Passed
pixel-level screens: none. Additional reference states must be identified during
the first per-feature implementation specification.
