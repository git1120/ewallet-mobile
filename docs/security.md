# Security

Tokens and future secrets are accessed only through `SecureStore`. Locale and
other non-sensitive preferences use `PreferencesStore`. PINs and OTPs remain
ephemeral UI input and must never be persisted.

`SafeLogger` recursively redacts authorization, tokens, PIN, OTP, NID, CIF,
account/wallet numbers, KYC images, and biometric private-key fields. API logs
record method, path, status, and request ID—not bodies. New sensitive fields
must be added to the deny list before integration.

The Dio foundation adds authorization, sanitized diagnostics, cancellation,
`X-Trace-Id` capture, and typed backend-failure parsing. Customer access tokens
are memory-only. Rotating refresh and sensitive current-session material use
namespaced `SecureStore` keys. Refresh is single-flight, replaces the old
credential before releasing waiters, rejects stale generations, and never
retries an uncertain refresh with the prior token.

Logout attempts one server revocation and always clears local authentication
material. Refresh reuse, expiry, revocation, restriction, and network
uncertainty terminate the local session.

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
