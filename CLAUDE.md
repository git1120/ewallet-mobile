# Claude Code entry point

Read `AGENTS.md` first and treat it as authoritative. Before modifying anything,
inspect the relevant implementation and the required documents selected by the
task routing in that file. UI changes must use
`skills/iba-flutter-design-system/SKILL.md`; API and financial changes require
their corresponding documents under `docs/agent-guidelines/`.

For UI, also read `design-references/README.md`, the manifest, exact binding
image, related design-system/component/flow references, and the design-system
skill. List followed reference IDs before editing. Visually inspect rather than
invent or improve. If a mandatory constraint forces a difference, stop that
region and record a Design Deviation Record for approval.

Keep the task boundary narrow, use existing abstractions, preserve public
contracts, and avoid unrelated refactors. Do not weaken analyzer configuration,
remove or dilute tests, introduce speculative behavior, or modify generated
localization files by hand. Never run `flutter upgrade`.

Add or update tests, then report every validation command and its exact result.
Do not hide failures or claim checks that were not run. Do not initialize Git
or create a commit unless explicitly requested.
