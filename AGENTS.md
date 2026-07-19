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

For visual conflicts use: (1) security/privacy, (2) backend API and business
contract, (3) accessibility, (4) approved visual reference, (5) repository
tokens/shared components, (6) responsive/platform adaptation, (7) Flutter
conventions, and (8) agent preference. Agents may not silently deviate.
Security/accessibility corrections preserve the approved visual as closely as
possible. Responsive adaptation is not permission to redesign hierarchy.

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
- Flutter Web development uses the repository same-origin development proxy
  for backend API access. Never bypass CORS by disabling browser security,
  adding unsafe Chrome flags, or weakening production URL validation. Native
  development uses its direct configured backend; proxy behavior must not leak
  into native, staging, or production configuration.
- Authentication UI implementation may not begin until its backend contract,
  Visual Reference Contract, state machine, security contract, and contract
  gaps are documented.
- Never blindly retry a money-moving operation after an uncertain timeout.
  A timeout is not a confirmed transaction failure.
- Preserve public contracts unless the task explicitly changes them. Do not
  replace secure abstractions with shortcuts or perform unrelated refactors.
- Never claim completion without exact validation evidence, silently ignore a
  failure, initialize Git, or commit unless explicitly instructed.

Follow `docs/agent-guidelines/definition-of-done.md` and report limitations
honestly. Detailed rules and task routing are indexed at
`docs/agent-guidelines/README.md`.

## Approved Visual Specifications

Approved screen and component images are binding, client/management-approved
visual specifications. Implement them pixel by pixel as closely as Flutter,
platform, localization, accessibility, and responsive constraints permit.
They control hierarchy, layout, spacing relationships, component placement and
dimensions, alignment, typography hierarchy, color, radius relationships,
icons, navigation, and state presentation.

Before UI work, inspect `design-references/manifest.yaml`, open the exact image,
inspect related component and flow boards, identify reference IDs in the task
and report, record viewport/state, and map elements to existing `Iba*`
components. Validate at matching dimensions, preserve spacing/radius and exact
navigation geometry, run the reference resolver, compare a screenshot where
possible, document deviations before implementation, and update the status
register. Never substitute Material defaults where the reference differs.

Agents must not generate a new visual interpretation when an approved binding
reference exists. Agents must not treat text descriptions as permission to
alter a binding image. Agents may not improve an approved design based on
personal judgment. Improvements require a separate approved design-change
proposal. Never edit an approved reference during implementation.
