# Visual implementation specification

Approved binding images are client/management-approved visual contracts, not
inspiration. Read the design-reference README, resolve the manifest ID, open
the exact image and related boards, and complete the Visual Reference Contract.

Pixel fidelity matches viewport, geometry, hierarchy, grid, alignment, spacing,
size, typography, color, radii, elevation, icons, navigation, density, state,
RTL, and affordances. Map these to `Iba*`; fix/extend shared components when
needed. Material defaults and local forks may not alter approved appearance.

Security/privacy, backend truth, and accessibility outrank a visual. Preserve
appearance as closely as possible and document unavoidable differences before
implementation. Localization preserves meaning/hierarchy; RTL mirrors
directionally; responsive/platform adaptation may reflow but not redesign.
Separate platform rasterization differences from actual drift.

Store screenshots only in
`artifacts/visual-validation/<feature>/<reference-id>/`, with
`implementation/`, `comparison/`, and `notes.md`; never beside source images.
Regression tests should lock stable geometry/states with documented rendering
tolerance. Acceptance requires exact-image review, matching major regions and
states, RTL/200%/responsive evidence, approved deviations, and status update.

Authentication UI implementation is additionally gated on a documented backend
contract, Visual Reference Contract, state machine, security contract, and
contract-gap register.
