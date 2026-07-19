# Design-reference naming convention

Use lowercase kebab-case and retain the source format. Screen files use
`<surface>-<feature>-<screen>-<state>-<locale>-<direction>-v<version>.<ext>`.
Composite boards may omit a single state and use `flow`. Component and
foundation boards use `component-<name>-approved-v<version>` and
`foundation-<name>-approved-v<version>`.

Use `neutral-bidi` only when language and direction are genuinely neutral.
Never use spaces, dates, camera names, hashes, unexplained numbers, `new`,
`copy`, `final`, or `final-final`. Renaming or versioning never changes image
content. A new version receives a new manifest record and the replaced version
is moved to `archive/superseded`.
