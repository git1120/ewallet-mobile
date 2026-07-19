# Review workflow

Review-only mode must not modify files.

1. Establish repository boundary/status and distinguish pre-existing changes.
2. Inspect the requested diff/implementation, tests, accepted decisions, and
   authoritative API/security contracts.
3. Run only no-write validation appropriate to the scope.
4. Verify test evidence rather than trusting a completion claim.
5. Report findings first, ordered by Blocker, High, Medium, Low, then
   Informational. Cite exact files and lines.
6. Label each item as a defect, risk, improvement, or preference and state
   confidence plus recommended action.
7. State areas checked with no findings, validation limitations, and whether
   repository status contained unrelated/pre-existing files.

Severity meanings:

- **Blocker:** unsafe to ship or impossible to build/use.
- **High:** security, financial correctness, data loss, or core-flow defect.
- **Medium:** material behavior, accessibility, localization, or maintenance
  defect with a workaround or limited reach.
- **Low:** narrow quality defect with limited impact.
- **Informational:** non-blocking observation or preference.

For UI, open the exact approved image and compare at an equivalent viewport.
Verify every major region, alignment/spacing, header and bottom-navigation
geometry, radius hierarchy, icon placement, typography, visibility, state
variants, and RTL mirroring without redesign. Separate platform rendering
differences from drift. Reject undocumented reinterpretation; attractive and
functional alone is insufficient.
