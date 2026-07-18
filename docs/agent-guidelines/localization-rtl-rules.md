# Localization and RTL rules

English (`en`), Dari (`fa`), and Pashto (`ps`) are required. Add semantic keys
to all ARB sources under `lib/app/localization/arb/`, then regenerate; never
edit `lib/app/localization/generated/` manually. No user-facing string may be
hardcoded. Locale remains a non-secret persisted preference through
`PreferencesStore`.

Use `IbaFormatters` as the formatting boundary and extend it when contracts
define currency, digits, dates/times/time zones, or phone behavior. Validate
digit shaping and currency placement with product language owners; do not
assume English punctuation or length.

Use `EdgeInsetsDirectional`, `AlignmentDirectional`,
`BorderRadiusDirectional`, `PositionedDirectional`, and direction-aware icons.
Use `TextDirection` and `DirectionalFocusTraversalPolicyMixin` (or equivalent)
only where controlled direction/focus is necessary. Avoid physical `left` and
`right`, `EdgeInsets.only(left: ...)`, duplicated RTL trees, string reversal,
and hardcoded directional arrows.

Phone numbers, account references, request/reference IDs, and technical
identifiers may need a controlled LTR value span inside an RTL page. Keep only
the identifier LTR; labels and surrounding layout follow locale direction.
Mask before display and test mixed-direction selection/reading.

Test English, Dari, and Pashto with realistic long text, RTL widget assertions,
100% and 200% text scale, narrow and wide layouts, and navigation/icon
direction. No layout may rely on English text length.
