# Forms and validation

Use existing `Iba*Field` components and model initial, focused, valid, invalid,
submitting, backend-validation, session, success, recoverable failure, and
unknown outcome where applicable.

Choose the correct keyboard/autofill policy and input formatter without using
formatting as business validation. Keep focus order logical in LTR and RTL;
Next advances, Submit invokes one guarded action, and modal forms restore focus.
Associate localized helper/error text with the field, announce errors, and
retain non-secret input after recoverable failure. Clear PIN/OTP and other
secrets after use/lifecycle transitions.

Run cheap syntax validation locally; debounce remote lookups where appropriate.
The server remains authoritative for identity, uniqueness, fees, limits,
permissions, balance, and transaction rules. Map field backend codes to
localized fields/messages; show a localized form-level failure when no safe
field mapping exists. Prevent duplicate submission and preserve cancellation.
