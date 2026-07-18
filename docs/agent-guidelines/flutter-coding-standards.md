# Flutter coding standards

- Use `lower_snake_case.dart` files, `UpperCamelCase` types, `lowerCamelCase`
  members, and `Iba` prefixes only for shared design-system types.
- Prefer immutable widgets, final fields, const constructors, and const
  subtrees. Preserve sound null safety; do not use `!` to avoid modeling a
  state.
- Keep `build` declarative and readable. Extract cohesive widgets instead of
  giant build methods, deep nesting, or deeply nested ternaries.
- Organize Riverpod providers by feature/responsibility. Controllers coordinate
  intent and state; providers do not become an untyped global registry.
- Await meaningful asynchronous work and map failures to typed `AppFailure` or
  feature failures. Do not use exceptions for normal flow or broad `catch (_)`.
  Preserve cancellation and rethrow truly unexpected errors after safe
  handling.
- After an async gap, verify `context.mounted` before using `BuildContext`.
- Keep secrets and full financial identifiers out of diagnostics, exception
  messages, state inspection, and `toString`.
- Do not use `print` or unrestricted `debugPrint`; use `SafeLogger`, which must
  receive structured, redactable metadata rather than payloads.
- Prefer `package:iba_ewallet/...` for cross-directory project imports and
  relative imports only within a tightly related local module. Sort imports by
  Dart, package, then local grouping as formatting/lints require.
- Comments explain constraints and decisions, not syntax. Document public
  contracts and security-sensitive invariants.
- Never edit `lib/app/localization/generated/` manually. Change ARB source and
  regenerate via Flutter tooling.
- Run `dart format`; do not weaken `analysis_options.yaml` or add broad ignores.
- Add dependencies only for a demonstrated need after checking Flutter 3.38.3
  and Dart 3.10.1 compatibility and platform support.
- Use explicit platform abstractions rather than scattered platform checks.
  Keep imports and behavior web-compatible unless the task documents an
  accepted platform exception. Never download fonts at runtime.

Never run `flutter upgrade`; do not change the SDK pin without an explicit
architecture decision. Use `flutter --no-version-check`.
