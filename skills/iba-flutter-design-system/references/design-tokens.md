# Design tokens

`lib/core/theme/tokens.dart` defines:

- `IbaColors`: institutional green/strong/soft, gold, background, surface, ink,
  muted, outline, success, information, warning, and error;
- `IbaSpacing`: `xxs` 4, `xs` 8, `sm` 12, `md` 16, `lg` 24, `xl` 32,
  `xxl` 48;
- `IbaRadii`: `sm` 8, `md` 12, `lg` 18, `pill` 999;
- `IbaElevation`: low 1 and medium 4;
- `IbaMotion`: fast 120 ms, standard 220 ms, slow 360 ms;
- `IbaBreakpoints`: compact 600, medium 840, expanded 1200;
- `IbaTypography`: bundled Inter and Noto Naskh Arabic families.

`lib/core/theme/iba_theme.dart` maps these into Material 3 themes and defines
`IbaFinancialTheme` positive/negative semantic colors. Prefer `Theme.of` for
component semantics and tokens for approved layout constants. Add a token only
when its meaning/reuse is clear; do not encode a screen-specific number as a
global token. Use the nearest parent radius larger than nested child radii.
