# Screen implementation specification

Before a complex screen, record a matrix with each state, trigger/data source,
visible content, allowed primary/secondary actions, navigation, announcement,
and recovery. Every screen must consider:

- purpose, entry conditions, authoritative data source, primary action,
  secondary actions, and back/cancel navigation;
- loading, empty, error, offline, restricted, session-expired, disabled,
  read-only, success, pending, partial-data, retry, and cancellation;
- responsive layout, accessibility, localization, RTL and mixed-direction data;
- analytics/logging necessity and privacy, including masking;
- whether an uncertain result requires status recovery rather than retry.

Not every state needs a distinct visual, but every state must be intentionally
handled or marked not applicable. Never infer success from navigation or a
local animation.

For forms define initial, focused, valid, invalid, submitting, server validation
failure, duplicate-submission prevention, session failure, success, recoverable
failure, and—where an operation may have reached the server—unknown outcome.
Associate errors with fields, retain safe input after recoverable errors, clear
secrets at appropriate lifecycle boundaries, and focus/announce the first
actionable error.
