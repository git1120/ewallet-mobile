# Definition of Done

A change is complete only when every applicable item is satisfied and evidenced.

- [ ] Architecture and dependency direction remain compliant.
- [ ] Backend contract is followed; gaps are documented.
- [ ] Existing design-system tokens/components are used or correctly extended.
- [ ] English, Dari, and Pashto are complete; RTL and mixed direction are safe.
- [ ] Accessibility, 48×48 targets, semantics, focus, reflow, reduced motion,
      and 200% text scale are addressed.
- [ ] Security/storage rules are followed and sensitive logs are redacted.
- [ ] Applicable loading, empty, error, offline, restricted, session, pending,
      partial, cancellation, and unknown states are implemented.
- [ ] Tests cover changed behavior and failure/risk paths.
- [ ] Agent-rule validator passes.
- [ ] Formatting is clean, analyzer is clean, and all tests pass.
- [ ] Relevant build and runtime smoke check pass.
- [ ] Limitations and contract gaps are disclosed.
- [ ] No unrelated files or sibling repositories changed.
- [ ] No Git repository was initialized and no commit was created unless asked.

Use `./tool/quality_gate.sh --build-web` for the standard full static gate.
Runtime checks are still required when behavior or UI changes.
