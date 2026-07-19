# Testing

Unit tests cover environments, formatting, masking, redaction, idempotency
keys, authentication DTO/API contracts, secure rotating sessions, controller
state, router guards, and refresh concurrency. Widget tests cover buttons,
customer mobile/PIN login, inputs, PIN, OTP, alerts, loading/empty/error states,
financial cards, localization direction, semantics, production gallery
exclusion, and 200% text scaling.

Run:

```bash
dart format --output=none --set-exit-if-changed .
flutter --no-version-check analyze
flutter --no-version-check test
flutter --no-version-check build web
```

The repository-wide gate is:

```bash
./tool/quality_gate.sh
./tool/quality_gate.sh --build-web
```

Golden tests are intentionally deferred until brand assets and visual baselines
stabilize. Prefer behavioral and semantics assertions over implementation
details.

See the task-specific [testing rules](agent-guidelines/testing-rules.md) and
[Definition of Done](agent-guidelines/definition-of-done.md). The focused
validator enforces only the checks printed by
`tool/validate_agent_rules.dart`; documented rules still require review.
