# Design-system rules

The design system is an implementation contract. Semantic tokens live in
`lib/core/theme/tokens.dart`; `IbaTheme` and `IbaFinancialTheme` live in
`lib/core/theme/iba_theme.dart`. Consume them instead of hardcoding color,
typography, spacing, radius, elevation, or motion.

Implemented shared components are:

- `buttons/iba_buttons.dart`: `IbaButton`, `IbaIconButton`, `IbaTextButton`;
- `inputs/iba_fields.dart`: text, Afghan phone, amount, PIN, and OTP inputs;
- `feedback/iba_feedback.dart`: alerts, badges, empty/error/loading, skeleton;
- `fintech/iba_fintech.dart`: account, balance, and transaction-summary cards;
- `navigation/iba_navigation.dart`: `IbaAppBar`, `IbaPageScaffold`;
- `overlays/iba_overlays.dart`: bottom sheet and confirmation dialog.

The barrel is `lib/design_system/design_system.dart`; the development gallery is
`lib/features/component_gallery/component_gallery_page.dart`.

Use responsive constraints and reflow, a clear visual hierarchy, restrained
semantic color, accessible contrast, and at least 48×48 interactive targets.
Financial amounts receive deliberate emphasis without relying on color alone.
Use consistent radii, with nested/internal radii visibly smaller than their
parent where both are present. Do not add arbitrary shadows or one-off local
styles without a documented gap.

> When a required variation is broadly reusable, extend the design-system
> component. When it is feature-specific, compose existing components inside
> the feature. Do not fork shared components locally.

Validate new shared variations in the gallery, English/Dari/Pashto, RTL, 100%
and 200% text scale, semantics, keyboard interaction where applicable, and
reduced motion.
