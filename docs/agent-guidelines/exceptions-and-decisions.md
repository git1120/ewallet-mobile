# Exceptions and decisions

Agents must not silently bypass a repository rule. Before implementing an
exception, create or update an accepted decision record containing:

- rule being bypassed and exact reason;
- alternatives evaluated and why each was rejected;
- security, privacy, financial-correctness, UX, accessibility, localization,
  and technical-debt impact as applicable;
- narrow file/feature/platform scope;
- expiration condition or dated follow-up with owner;
- approval required and approving role/person.

The current task may explicitly authorize a narrow exception. Otherwise,
security, backend-contract, SDK, repository-boundary, and financial-retry
exceptions require human approval before implementation. A temporary exception
must fail safely and must not be copied as a general pattern.

## Design Deviation Record

No agent may approve its own visual deviation.

```text
Reference ID:
Reference path:
Affected screen or component:
Affected region:
Approved behavior:
Proposed deviation:
Reason:
Security impact:
Accessibility impact:
Localization/RTL impact:
Responsive impact:
Alternatives evaluated:
Temporary or permanent:
Approval required from:
Approval status:
Follow-up:
```
