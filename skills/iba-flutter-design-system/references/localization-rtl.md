# Screen-level localization and RTL

Apply `docs/agent-guidelines/localization-rtl-rules.md`. Source copy from all
three ARBs and use `AppLocalizations`; never edit generated Dart.

For each screen, test English, Dari, and Pashto at 100%/200%, narrow/wide
constraints, long labels/errors, back/forward icons, field order, overlays, and
financial rows. Use directional layout primitives. Keep only phone/account/
reference/technical identifier value spans controlled LTR inside RTL, mask them,
and verify mixed-direction reading. Never reverse strings or duplicate a page
for RTL.
