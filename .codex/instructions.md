# Codex repository instructions

Follow the root `AGENTS.md`. Inspect relevant source, tests, contracts, and
guidance before editing. Use existing API, storage, failure, localization,
theme, and `Iba*` abstractions; do not replace secure boundaries with shortcuts.

For UI, locate the authoritative manifest ID, visually inspect its exact image
and related boards, record viewport/state, and map visible elements to `Iba*`
components. Do not invent visuals. Validate at the reference viewport, report
deviations, preserve reference files, and update implementation status.

Make the smallest complete change, preserve public contracts unless the task
explicitly changes them, and avoid speculative APIs, screens, and states. Add
or update proportionate tests. Run formatting, analyzer, tests, the relevant
build/smoke check, and `dart run tool/validate_agent_rules.dart`; report exact
commands and results. Never silently ignore failures, initialize Git, run
`flutter upgrade`, or commit unless asked.
