# Shared components

| Path | Components and responsibility |
|---|---|
| `lib/design_system/buttons/iba_buttons.dart` | `IbaButton` primary/loading/disabled/optional icon/width; `IbaIconButton`; `IbaTextButton` |
| `lib/design_system/inputs/iba_fields.dart` | `IbaTextField`, `IbaPhoneField`, `IbaAmountField`, `IbaPinField`, `IbaOtpInput`, Afghan phone formatter |
| `lib/design_system/feedback/iba_feedback.dart` | `IbaStatus`, `IbaAlertBanner`, `IbaStatusBadge`, empty/error/loading states, skeleton |
| `lib/design_system/fintech/iba_fintech.dart` | Account card, balance card, transaction summary |
| `lib/design_system/navigation/iba_navigation.dart` | App bar and constrained safe-area page scaffold |
| `lib/design_system/overlays/iba_overlays.dart` | Modal bottom sheet and confirmation dialog |

Import the barrel `lib/design_system/design_system.dart` when several families
are used. Confirm semantics, loading/disabled behavior, and current constructor
contract before reuse. Extend a component and its tests/gallery example for a
broad reusable variant; compose inside the feature for a one-flow arrangement.
Do not subclass/copy a shared widget merely to restyle it.
