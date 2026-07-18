# Design system

The visual direction uses institutional green, a restrained gold accent,
off-white backgrounds, white surfaces, and accessible semantic colors. Tokens
centralize color, spacing, radius, elevation, motion, breakpoints, and font
families. Theme configuration centralizes Material color and text schemes,
buttons, inputs, cards, app bars, sheets, dialogs, navigation, and financial
positive/negative colors.

Inter and Noto Naskh Arabic are bundled assets. Noto Naskh Arabic is selected
for Dari and Pashto; no font is downloaded at runtime.

Shared components use directional layout primitives, 48×48 minimum controls,
semantics, icon-plus-text status cues, flexible text, and reduced-motion
checks. The gallery displays all initial components and important UI states,
with live English/Dari/Pashto and 100%/200% text controls.

New widgets should consume tokens and theme values. Avoid raw color, padding,
radius, animation duration, and text-style values in feature code.

For implementation rules, component-extension decisions, screen states, and
validation, use the [design-system rules](agent-guidelines/design-system-rules.md)
and the actionable
[IBA Flutter design-system skill](../skills/iba-flutter-design-system/SKILL.md).
