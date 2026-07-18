# Architecture rules

## Implemented layers

- `lib/main.dart` delegates to `lib/app/bootstrap.dart`.
- `lib/app/bootstrap.dart` initializes bindings, `EnvironmentConfig`,
  `SharedPreferencesStore`, the root Riverpod `ProviderScope`, and uncaught
  error handling.
- `lib/app/app.dart` owns `MaterialApp.router`, `GoRouter`, locale persistence,
  generated localization delegates, `IbaTheme`, and the development-only
  component-gallery route. `lib/app/session/refresh_coordinator.dart`
  serializes concurrent refresh work.
- `lib/core/` holds `ApiClient` and its Dio interceptors, compile-time
  `EnvironmentConfig`, `AppFailure`, `SafeLogger`, idempotency, storage
  abstractions, theme/tokens, and `IbaFormatters`.
- `lib/design_system/` exports reusable `Iba*` controls. It depends on Flutter
  and core theme tokens, never feature code.
- `lib/features/` owns vertical slices. At present it contains only the
  development `component_gallery`; do not claim product screens exist.

Dependency direction is app/features → design system and core. Core never
depends on a feature, and features do not import one another's internals.
Promote code to `core` or `design_system` only after genuine reuse is clear;
feature-specific behavior stays in its feature.

## State, navigation, and boundaries

Riverpod is installed and the root `ProviderScope` exists, but no product
providers exist yet. Add providers close to the responsibility they expose:
pure dependencies, repositories, use-case/controller state, and derived
presentation state should not become one global provider. Avoid global mutable
state and service locators.

`GoRouter` is composed in `IbaApp`. Route definitions and guards belong in the
app/navigation composition boundary; infrastructure must not navigate.

Widgets render state and dispatch intent; they do not own business workflows.
API calls flow through a feature repository/service into
`lib/core/api/api_client.dart`, not from widgets. Use typed request/response
DTOs at the transport boundary, map them to domain models, and avoid leaking
DTOs into presentation when that couples UI to wire shape. `AppFailure` is the
current typed failure boundary.

`IbaFormatters` formats display values; it does not validate business rules.
Local synchronous validation may reject malformed input, but server-owned
limits, fees, permissions, recipients, and transaction validity remain
server-authoritative.

`SecureStore` is the secret boundary; `PreferencesStore` is only for
non-sensitive preferences such as locale. Platform behavior must stay behind
replaceable abstractions, especially secure storage and future biometrics,
screenshots, clipboard, and lifecycle controls.

Prefer the smallest complete vertical slice. Do not create empty feature
folders or premature interfaces without a real boundary, testing need,
platform substitution, or alternate implementation.
