# Financial-flow rules

The default money-moving flow is:

```text
Entry
→ local validation
→ server-side validation or quote
→ review
→ authentication
→ submit once
→ processing
→ confirmed result, pending result, or unknown result
→ receipt/status tracking
```

The server is authoritative for fees, limits, recipient verification, balance,
and final status. Review must show exact amount, currency, fee, total, source,
and verified/masked recipient details as supported. Format amounts locally but
never recompute an authoritative fee.

Generate one logical idempotency key per user-authorized operation and retain it
for safe recovery/retry of that same operation. A new tap after validation is
not automatically a new logical operation. Prevent duplicate taps, disable and
show loading on submit, submit once, and never automatically retry a
non-idempotent request.

> A network timeout does not prove that the server rejected or failed to
> execute a financial operation.

After submission, cancellation may stop waiting but must not claim the server
cancelled. Represent processing, pending, declined, reversed, confirmed, and
unknown separately. On timeout/connection loss, capture request ID and
idempotency key, show an honest unknown/pending message, and query transaction
status before offering another submission. Never show optimistic success.

A receipt/status record needs the server reference ID, status, timestamp,
amount/currency, fee/total, masked parties, and a route to status tracking.
Haptics or animation may reinforce a server-confirmed state only.

Tests must cover successful submission, duplicate submission, timeout, unknown
outcome, pending, decline, limit exceeded, insufficient balance, session
expiration, reversal, and eventual completion. Verify a single submission,
stable idempotency key, disabled/loading behavior, and status lookup before
retry.
