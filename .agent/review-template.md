# Read-only review

Review mode must not modify files.

## Scope

Identify the change, repository boundary, base/reference, and exclusions.

## Evidence inspected

List files, contracts, decisions, repository status, tests, and no-write
validation commands. Separate pre-existing changes from reviewed work.
For authentication UI, verify that its backend contract, Visual Reference
Contract, state machine, security contract, and contract gaps existed before
implementation began.

## Findings

For each finding provide:

- severity: Blocker, High, Medium, Low, or Informational;
- category: defect, risk, improvement, or preference;
- exact file and line;
- evidence and contract alignment;
- architecture, security, localization/RTL, accessibility, and testing impact;
- confidence: high, medium, or low;
- recommended action.

State explicitly when a category has no findings. Verify tests instead of
trusting claims, and never attribute pre-existing changes to the reviewed work.

## Pixel-fidelity review

Record the visual reference and viewport. Decide on layout, spacing, typography,
color, component, navigation, state, and RTL fidelity; accessibility impact;
unauthorized deviations; missing states; and screenshot evidence.

Decision: Accept / Accept with documented deviation / Reject for visual
mismatch / Blocked by contract / Blocked by accessibility / Reference unclear.
