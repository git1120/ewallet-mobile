# States and feedback

- Loading/skeleton: preserve layout where useful, exclude decorative skeletons
  from semantics, announce meaningful waits, respect reduced motion.
- Empty: explain what is absent and offer only a valid next action.
- Error/offline: calm localized cause/recovery; never expose backend text.
- Pending/processing/unknown: distinct wording; never collapse into failure or
  success. Unknown financial outcomes route to status lookup.
- Success: only after authoritative confirmation; show the next safe action.
- Warning: state consequence and action, not color alone.
- Restricted/locked/suspended/closed: use the precise server state, limit
  available actions, avoid disclosing internal rules.

Keep existing safe content during partial refresh when accurate, mark stale or
partial data, and prevent actions that depend on missing facts. Use
`IbaAlertBanner`, badges, message states, loading, and skeleton components when
their contracts fit.
