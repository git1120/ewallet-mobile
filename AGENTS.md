# IBA E-Wallet agent rules

## Project and boundary

This is the Flutter customer and staff application for IBA E-Wallet. It handles
financial and customer data, so correctness, privacy, and explicit transaction
states take priority over delivery speed. The application supports English,
Dari, and Pashto. This repository currently contains Android and web runners;
web is a development/visual-validation target. No iOS runner is currently
present, so do not claim iOS validation until that platform is added and
verified. The backend is `../api` and the admin panel is `../web`; do not
modify either sibling unless the current task explicitly includes it.

Neither `/Users/danish/projects/ewallet` nor this `mobile` directory was a Git
repository when these rules were created. Do not initialize Git. If a repository
is added later, verify its root before working and never commit unless requested.

Flutter is pinned to 3.38.3 and Dart to 3.10.1. Never run `flutter upgrade`.
Do not change either version without an explicit architecture decision. Use
`flutter --no-version-check` where required. Before adding a package, inspect
its compatibility with the pinned SDK; do not add speculative dependencies.

## Source-of-truth priority

1. Explicit current task
2. Accepted architecture and security decisions
3. Backend API contract and Postman collection
4. This `AGENTS.md`
5. Relevant repository skill
6. Detailed documents in `docs/agent-guidelines/`
7. Existing implementation patterns
8. General Flutter conventions

Mockups never override backend contracts or security rules. When sources
conflict or a contract is missing, record the gap; do not invent behavior.

## Required reading

For every task, read this file, `docs/architecture.md`, `docs/security.md`,
`docs/agent-guidelines/implementation-workflow.md`, and
`docs/agent-guidelines/definition-of-done.md`.

For UI work, also read `docs/design-system.md`,
`docs/agent-guidelines/design-system-rules.md`, and use
`skills/iba-flutter-design-system/SKILL.md`. For API work, read
`docs/agent-guidelines/api-integration-rules.md` and
`docs/agent-guidelines/security-rules.md`. For money movement, also read
`docs/agent-guidelines/financial-flow-rules.md`.

## Non-negotiable rules

- Inspect relevant code and contracts before editing; keep changes scoped.
- Never weaken analyzer rules, tests, or assertions to make validation pass.
- Never add production mock data or fabricate endpoints, fields, enums,
  permissions, or states.
- Widgets render state and dispatch intent. Never put business workflows in
  widgets or instantiate `Dio` outside `lib/core/api/`.
- Use shared `Iba*` components. A bypass requires a documented design-system
  gap. Never fork a shared component locally.
- Never hardcode colors, typography, spacing, radii, elevation, motion, or
  user-facing text. Use directional APIs instead of physical left/right layout.
- Never log secrets or sensitive financial/customer data. Store secrets only
  through `SecureStore`, never shared preferences.
- Never blindly retry a money-moving operation after an uncertain timeout.
  A timeout is not a confirmed transaction failure.
- Preserve public contracts unless the task explicitly changes them. Do not
  replace secure abstractions with shortcuts or perform unrelated refactors.
- Never claim completion without exact validation evidence, silently ignore a
  failure, initialize Git, or commit unless explicitly instructed.

Follow `docs/agent-guidelines/definition-of-done.md` and report limitations
honestly. Detailed rules and task routing are indexed at
`docs/agent-guidelines/README.md`.
