# Security

Tokens and future secrets are accessed only through `SecureStore`. Locale and
other non-sensitive preferences use `PreferencesStore`. PINs and OTPs remain
ephemeral UI input and must never be persisted.

`SafeLogger` recursively redacts authorization, tokens, PIN, OTP, NID, CIF,
account/wallet numbers, KYC images, and biometric private-key fields. API logs
record method, path, status, and request ID—not bodies. New sensitive fields
must be added to the deny list before integration.

The Dio foundation adds authorization, sanitized diagnostics, cancellation,
request-ID capture, and typed backend-failure parsing. Refresh concurrency is
coordinated, while the refresh endpoint is deferred until authentication
contracts exist. Mutating requests can use UUID v4 idempotency keys.

## Web limitation

`flutter_secure_storage` on the web relies on browser capabilities and does not
provide the hardware-backed guarantees available on supported mobile devices.
This architecture keeps storage replaceable, but it does not claim production
browser-token security. A production web authentication model requires a
separate threat model, CSP and hosting controls, XSS review, and preferably
server-managed HttpOnly cookies where the backend supports them.

Feature work must also follow the expanded
[agent security rules](agent-guidelines/security-rules.md) and, for
money-moving operations, the
[financial-flow rules](agent-guidelines/financial-flow-rules.md).
