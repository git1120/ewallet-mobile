# Read-only review

Review mode must not modify files.

## Scope

Identify the change, repository boundary, base/reference, and exclusions.

## Evidence inspected

List files, contracts, decisions, repository status, tests, and no-write
validation commands. Separate pre-existing changes from reviewed work.

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
