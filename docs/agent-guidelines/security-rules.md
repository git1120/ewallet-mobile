# Security rules

This extends `../security.md`; it does not replace a feature threat model or
backend contract review.

Access and rotating refresh tokens go only through `SecureStore` in
`lib/core/storage/secure_storage.dart`. Never put tokens, passwords, PINs, OTPs,
biometric material, or financial/customer identifiers in `PreferencesStore`.
On logout or refresh-token reuse/revocation, clear server session state as the
contract requires, clear local secrets, cancel protected work, reset sensitive
in-memory state, and return through the central session/navigation boundary.

PIN and OTP are ephemeral, obscured inputs and must be cleared after use or
relevant lifecycle loss. Biometrics unlock a protected local credential; they
are not a substitute for server authorization unless the accepted protocol says
so. NID, CIF, KYC documents, full account/wallet numbers, device identifiers,
clipboard content, and screen contents require minimization and masking.
Disable screenshots/recents previews and clipboard use for a feature only
through reviewed platform abstractions; clear temporary clipboard data where
platform behavior permits. Re-authenticate sensitive flows after lifecycle or
session transitions as the contract requires.

Never log:

- PIN, OTP, password, authorization headers, access tokens, refresh tokens;
- full account or wallet numbers, NID, CIF, KYC images;
- biometric keys, private cryptographic material, device secrets;
- sensitive request/response bodies.

`SafeLogger` and `SanitizedLoggingInterceptor` may log method, path, status, and
request ID after redaction. Crash reports and analytics follow the same rule;
collect only necessary event/state metadata and no user-entered financial data.
Add redaction tests whenever logging, diagnostics, or failure parsing changes.

Refresh must be serialized via `RefreshCoordinator`. Rotating-token reuse,
expiry, revocation, and logout are terminal session events unless the
authoritative contract explicitly provides recovery.

## Browser target

> Flutter Web is currently a development and visual-validation target. Browser
> storage must not be presented as equivalent to Android Keystore or iOS
> Keychain.

Local Flutter Web API access must use the loopback, same-origin development
proxy in `web_dev_config.yaml`. Agents must not disable browser security,
install CORS bypasses, add unsafe Chrome flags, expose the development server
publicly, or weaken staging/production URL checks. Native development remains
direct and must never receive a relative API URL.

Production browser authentication needs a separate threat model, strict CSP and
hosting controls, XSS review, dependency/output escaping review, and preferably
server-managed `Secure`, `SameSite`, HttpOnly cookies where supported. Do not
market `flutter_secure_storage` web behavior as hardware-backed protection.
