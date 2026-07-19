# Approved design-reference library

This library is the permanent visual source of truth for IBA E-Wallet Flutter
work. `manifest.yaml` identifies authority, source provenance, state, viewport,
relationships, and implementation status. `status-register.md` tracks delivery;
`visual-review-checklist.md` controls review; `migration-report.md` records the
one-time migration.

## Authority and conflict resolution

Approved screen and component reference images are binding visual
implementation specifications. Agents must implement them pixel by pixel as
closely as Flutter, platform behavior, localization, accessibility, and
responsive constraints reasonably permit. Agents must not redesign, simplify,
modernize, reinterpret, restyle, rearrange, recolor, or substitute approved
visuals without an explicitly recorded and approved design exception.

Management or client approval has already been obtained for these references.
Personal preferences, generic design trends, framework defaults, and
agent-generated alternatives do not override them.

A screen reference controls visual hierarchy, layout, spacing relationships,
component placement, dimensions, alignment, typography hierarchy, color usage,
radius relationships, icon placement, navigation placement, and state
presentation. Existing repository security, backend-contract, accessibility,
localization, and platform rules remain mandatory.

Conflicts are resolved in this order:

1. Security and privacy requirements.
2. Backend API and business-contract correctness.
3. Accessibility requirements.
4. Approved visual reference.
5. Repository design tokens and shared components.
6. Responsive and platform adaptation.
7. General Flutter conventions.
8. Agent preference.

Agents may not silently deviate. Security or accessibility corrections preserve
the approved appearance as closely as possible. Responsive adaptation is not
permission to redesign hierarchy. Before implementation, unavoidable deviation
records must name the reference, affected region, reason, alternatives, and
approval status.

## Structure and use

- `foundations/` contains visual-language and implementation-mapping boards.
- `components/` contains reusable component specifications and templates.
- `flows/` contains composite customer/staff flows and intentional state boards.
- `archive/unclear/` and `archive/superseded/` retain non-authoritative history.

Files in `archive/unclear` and `archive/superseded` are not implementation
authorities.

Run `dart run tool/list_design_references.dart` and filter by `--feature`,
`--surface`, `--status`, or `--id`. An implementation task must name exact IDs,
open the images, inspect related records, record their pixel dimensions, map
visible elements to `Iba*` components, and compare at an equivalent viewport.
Reviewers use the checklist and reject undocumented reinterpretation.

## Change control

New designs require a stable name, an image-content review, a manifest record,
an authority classification, and a status row. Exact duplicates are not added.
Near-duplicates are retained when they convey language, direction, visibility,
role, or state. Uncertain content goes to `archive/unclear`; replaced but useful
content goes to `archive/superseded`.

Approved binding references must not be modified, replaced, recolored, cropped,
or re-exported without preserving the original and recording the change.
Implementation agents never edit reference images. Superseding creates a new
version, moves the old version to the archive, links `supersedes`, and records
approval. No agent approves its own visual deviation.

Responsive work preserves hierarchy, ordering, emphasis, geometry
relationships, and state meaning while reflowing only as constraints require.
Localization and RTL mirror directionally without redesign. Accessibility
adaptations follow the same rule and use a Design Deviation Record when exact
fidelity cannot coexist with a mandatory requirement.

Implementation evidence is stored separately:

`artifacts/visual-validation/<feature>/<reference-id>/implementation/`,
`comparison/`, and `notes.md`. Never place generated screenshots beside source
references.
