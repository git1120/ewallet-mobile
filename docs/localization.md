# Localization

English (`en`), Dari (`fa`), and Pashto (`ps`) are generated from ARB files by
Flutter gen-l10n. Add every user-facing string to all three ARB files. The
selected locale is persisted in shared preferences because it is not secret.

Dari and Pashto resolve to RTL through Flutter localization delegates. UI uses
`EdgeInsetsDirectional`, `AlignmentDirectional`, `BorderRadiusDirectional`,
and directional borders. Financial values that must remain visually stable
explicitly use LTR only at the value level.

`IbaFormatters` supplies locale-aware amount, date, and time foundations plus
Afghan phone formatting. Formatting and translations should be extended when
backend currency/date contracts are finalized.

Agents must apply the complete
[localization and RTL rules](agent-guidelines/localization-rtl-rules.md),
including directional layout, mixed-direction identifiers, long translations,
and 200% text-scale tests.
