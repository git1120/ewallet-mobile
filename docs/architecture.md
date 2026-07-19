# Architecture

`main.dart` delegates to `app/bootstrap.dart`, where Flutter bindings,
preferences, the root Riverpod scope, and top-level error handling are
initialized. `app/app.dart` owns routing, localization, theme, persisted locale,
and the development gallery switch.

`core/` contains environment configuration, API transport, typed failures,
logging, security, storage, theme, and pure utilities. `design_system/` contains
reusable `Iba*` UI. `features/` is reserved for vertical product slices; only
the development component gallery exists in this foundation.

Dependencies point inward: features can use the design system and core;
design-system widgets can use tokens/theme and Flutter; core services do not
depend on features. Authentication, signup, home, accounts, beneficiaries,
transfers, top-up, transactions, profile, security, and walk-in boundaries are
created when their first real behavior is implemented—never as empty files.

Environment values are compile-time defines. Development API resolution is
centralized: native targets default to the direct development host, while
Flutter Web defaults to a relative same-origin base consumed by the root
development-server proxy. Staging and production require an explicit remote
HTTPS URL; neither can select relative proxy addressing. Production performs
additional fail-fast URL validation and never registers the component-gallery
route.

Coding agents must also follow the repository-specific
[architecture rules](agent-guidelines/architecture-rules.md) and
[implementation workflow](agent-guidelines/implementation-workflow.md). These
documents define dependency, DTO/domain, Riverpod, navigation, storage, and
feature-boundary rules without changing the architecture described here.
Approved visuals govern presentation only; they do not create routes, APIs,
permissions, feature boundaries, or business contracts.
