# UI security and privacy

Apply `docs/agent-guidelines/security-rules.md`.

Mask account/wallet numbers before they reach display widgets and semantics.
Minimize NID, CIF, KYC, device, and recipient data. PIN/OTP/password fields are
ephemeral, obscured, excluded from logs/analytics, and cleared at appropriate
submission, navigation, and lifecycle boundaries.

Do not put sensitive values in widget keys, route URLs, errors, clipboard,
screenshots, diagnostics, or restoration state. Add screenshot/recents and
clipboard controls only through reviewed platform abstractions. Analytics may
record a coarse screen/action/status, never entered amounts, identifiers,
credentials, payloads, or backend messages.
