# Financial UI patterns

- Amount entry: localized label/currency, decimal contract, available limits,
  safe parsing, no floating-point business calculation in widgets.
- Account/recipient selection: masked identifier, name/status, accessibility
  label, server verification where supported.
- Fee/limits: show server quote and expiry; distinguish fee, amount, and total.
- Review: freeze/display exact quote, source, recipient, amount, fee, total;
  offer explicit edit/back before authorization.
- PIN/OTP: ephemeral obscured input, attempt/expiry/resend behavior from
  contract, never log or persist.
- Processing: disable duplicate submission and announce progress without
  implying success.
- Result/receipt: only server-confirmed success; include masked parties,
  reference ID, status, timestamp, amount/fee/total.
- Pending/reversal/unknown: distinct icon, title, explanation, allowed action,
  and status tracking. Timeout becomes unknown until status lookup.

Use one idempotency key per logical authorized operation. Haptics and color
never establish transaction truth.
