# Implementation workflow

1. Read `AGENTS.md` and task-specific instructions.
2. Inspect the repository, relevant implementation, tests, and decisions.
3. Inspect the authoritative backend contract when applicable.
4. For UI, locate the manifest record and open the exact image.
5. Inspect related component/flow references; record viewport and state.
6. Compare visible elements with tokens/`Iba*` components and record gaps.
7. Identify security, privacy, localization, RTL, and accessibility constraints.
8. Define the smallest complete implementation boundary and states.
9. Record contract gaps instead of inventing behavior.
10. Implement without visual reinterpretation; add proportionate tests.
11. Run the reference resolver smoke check.
12. Capture an equivalent-viewport screenshot where possible, compare, and
    record deviations.
13. Update the design-reference status register.
14. Run format, rule validation, analyze, tests, build, and runtime smoke.
15. Review status and report exact evidence, limitations, and deferred gaps.

Run `dart run tool/validate_agent_rules.dart` or the complete
`./tool/quality_gate.sh` during validation. Never run `flutter upgrade`.
Avoid unnecessary clarification when repository and contract evidence resolves
the question. If validation cannot run or fails, say exactly why; incomplete
validation is not completion.
