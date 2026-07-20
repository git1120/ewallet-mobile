# IBA E-Wallet mobile

Production foundation for the IBA E-Wallet Flutter client. This slice contains
infrastructure and reusable UI only; customer business flows are intentionally
deferred.

## Toolchain

- Flutter 3.38.3 (stable)
- Dart 3.10.1
- macOS Monterey: keep this SDK pin. Never run `flutter upgrade`. Do not change
  Flutter or Dart without an explicit architecture decision, and inspect pinned
  SDK compatibility before adding dependencies.

## Setup and run

```bash
flutter --no-version-check pub get
flutter --no-version-check run -d chrome \
  --dart-define=APP_ENV=development
```

For Chrome development, `web_dev_config.yaml` binds the Flutter server to
`127.0.0.1:8080` and proxies only `/api/` to the development backend. Do not
supply `API_BASE_URL` for this normal web flow: the app uses same-origin
`/api/v1/...` requests. This is a development tool, is not copied into
`build/web`, and does not approve production browser authentication.

Native development continues to call the configured backend directly:

```bash
flutter --no-version-check run -d android \
  --dart-define=APP_ENV=development \
  --dart-define=API_BASE_URL=http://74.118.81.141
```

Development opens customer authentication. The gallery remains available at
`/gallery` only in development. Supported `APP_ENV` values are `development`,
`staging`, and `production`. Staging and production require an explicit HTTPS
API URL and reject relative proxy addressing, loopback, HTTP, and the deployed
development address. Production also rejects development/staging host labels.

```bash
flutter --no-version-check run -d chrome \
  --dart-define=APP_ENV=staging \
  --dart-define=API_BASE_URL=https://staging-api.example.com

flutter --no-version-check build web \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://api.example.com
```

## Quality commands

```bash
dart format --output=none --set-exit-if-changed .
dart run tool/validate_agent_rules.dart
flutter --no-version-check analyze
flutter --no-version-check test
flutter --no-version-check build web

./tool/quality_gate.sh
./tool/quality_gate.sh --build-web
```

The quality gate verifies Flutter 3.38.3/Dart 3.10.1, runs the focused
repository-rule validator, formatting, analyzer, tests, and optionally the web
build. It resolves the project root, so it can be invoked from any directory.

The code is organized by application composition, cross-cutting core services,
reusable design-system components, and future feature boundaries. See
[architecture](docs/architecture.md), [design system](docs/design-system.md),
[localization](docs/localization.md), [security](docs/security.md), and
[testing](docs/testing.md).

## Authentication slice

The Android-first customer slice supports ten-digit mobile number plus
six-digit PIN login, rotating refresh credentials, restoration and confirmation
through `GET /api/v1/auth/devices`, guarded routes, a temporary authenticated
placeholder, current-session logout, and terminal recovery. Access tokens are
memory-only; refresh/session material uses `SecureStore`.

Flutter Web remains a development and visual-validation target. Production
browser authentication is not approved. The local proxy resolves development
CORS without disabling browser security or changing the backend; it does not
solve browser token-storage, CSP, XSS, or production hosting requirements.

## Coding-agent entry points

All coding agents start with [AGENTS.md](AGENTS.md). Claude Code and Codex also
have thin entry points in [CLAUDE.md](CLAUDE.md) and
[.codex/instructions.md](.codex/instructions.md). Detailed rules are indexed in
[docs/agent-guidelines](docs/agent-guidelines/README.md); reusable task/review
prompts are under [.agent](.agent/README.md).

UI work must use the
[IBA Flutter design-system skill](skills/iba-flutter-design-system/SKILL.md).
Agents must inspect before editing, report exact validation, never run
`flutter upgrade`, and never initialize Git or commit unless explicitly asked.

## Approved visual references

Client-approved designs are under
[design-references](design-references/README.md); the incoming temporary
directory was migrated and removed. Binding images may not be modified. List
them with `dart run tool/list_design_references.dart` and its `--feature`,
`--surface`, `--status`, or `--id` filters.

UI implementation resolves and opens the exact image, related boards, and
viewport, then ends with equivalent-viewport review and a
[status-register](design-references/status-register.md) update. Use the
[visual checklist](design-references/visual-review-checklist.md). Unavoidable
differences follow the documented design-deviation process; personal redesign
is never an implementation option.

Approved IBA logo PNGs are copied byte-for-byte from the admin-panel assets
into `assets/branding/` and rendered only through shared `IbaBrandMark`. Their
source paths, hashes, light/dark usage, and no-modification rules are recorded
in `assets/branding/README.md`; the mobile app has no runtime dependency on the
admin-panel working copy.
