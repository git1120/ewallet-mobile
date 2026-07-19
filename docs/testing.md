# Testing

Unit tests cover environments, formatting, masking, redaction, idempotency
keys, authentication DTO/API contracts, secure rotating sessions, controller
state, router guards, and refresh concurrency. Widget tests cover buttons,
customer mobile/PIN login, inputs, PIN, OTP, alerts, loading/empty/error states,
financial cards, localization direction, semantics, production gallery
exclusion, and 200% text scaling. Proxy tests cover the fixed loopback server,
approved target, single `/api/` prefix, no path replacement, no-cache header,
platform-specific API resolution, and staging/production rejection.

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
It also requires the restricted proxy configuration and rejects arbitrary proxy
rules and unsafe browser-security flags.

For live Chrome validation, run without a web `API_BASE_URL` override:

```bash
flutter --no-version-check run -d chrome \
  --dart-define=APP_ENV=development
```

The pinned Flutter 3.38.3 middleware preserves proxied methods, request headers,
and streamed bodies. Its source shows two relevant limitations: a backend 404
falls through to Flutter asset handling, and Wasm/release development serving
does not use the proxy middleware. Its current path rewrite also reconstructs
the target from the request path without the query string; query-bearing API
routes therefore require separate validation before use. Do not enable Wasm
for this authentication smoke test.
