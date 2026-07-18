# Testing rules

Test behavior and risk at the smallest reliable layer.

## By change type

- Pure logic: unit-test formatters, validators, DTO/domain mapping, failure
  translation, idempotency, redaction, and state transitions.
- Shared widgets: widget-test normal, loading, disabled, error, RTL, 200% text
  scale, semantics, and keyboard/focus behavior where applicable.
- API integrations: test serialization, parsing, backend errors, cancellation,
  authorization, concurrent refresh, timeouts, request IDs, and sensitive-log
  redaction.
- Financial workflows: test one-time submission, duplicate prevention,
  pending, timeout/unknown, safe status recovery, confirmed failure, success,
  and reversal.
- Navigation: test guards, session expiry, logout, restricted accounts, and
  supported deep links.

Tests must use deterministic fakes at boundaries, never production mock data.
Test removal, broad skipping, or weakened assertions/fixtures to make CI pass
is prohibited. Generated files are outputs, not direct test-edit targets.
Golden tests remain optional until brand assets and stable visual baselines are
approved; behavioral and semantics assertions are currently preferred.

Run the validator, formatting check, analyzer, complete tests, and relevant
build/smoke check. Report exact failures and unrun checks.
