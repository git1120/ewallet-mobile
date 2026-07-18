# Implementation workflow

1. Read `AGENTS.md` and task-specific instructions.
2. Inspect the repository, relevant implementation, tests, and decisions.
3. Inspect the authoritative backend contract when applicable.
4. Identify existing tokens and `Iba*` components for UI work.
5. Identify security, privacy, localization, RTL, and accessibility constraints.
6. Define the smallest complete implementation boundary and states.
7. Record contract gaps instead of inventing behavior.
8. Implement the smallest complete vertical slice using existing abstractions.
9. Add or update proportionate tests.
10. Run `dart format --output=none --set-exit-if-changed .`.
11. Run `flutter --no-version-check analyze`.
12. Run `flutter --no-version-check test`.
13. Run the relevant build and runtime smoke check.
14. Review changed files/repository status for unrelated work.
15. Report exact evidence, limitations, and deferred gaps.

Run `dart run tool/validate_agent_rules.dart` or the complete
`./tool/quality_gate.sh` during validation. Never run `flutter upgrade`.
Avoid unnecessary clarification when repository and contract evidence resolves
the question. If validation cannot run or fails, say exactly why; incomplete
validation is not completion.
