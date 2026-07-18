# Screen patterns

Select a pattern, then apply the complete state specification in
`docs/agent-guidelines/screen-implementation-specification.md`.

- **Authentication / secure action:** credential input, attempt/lock state,
  server authorization, session failure, privacy lifecycle.
- **Simple form:** concise purpose, fields, local validation, server errors,
  one primary submit.
- **Review and confirm:** immutable reviewed facts, explicit edit/back,
  authorization only after current quote/details.
- **Financial transaction:** entry → validation/quote → review → authorization
  → single submission → confirmed/pending/unknown → status/receipt.
- **List and filter:** server-backed paging/filter/sort, loading/empty/error/
  partial/offline, stable selection.
- **Detail:** authoritative status, actions gated by permission/status, masked
  identifiers, refresh and partial data.
- **Settings:** current value, persisted/server source, accessible controls,
  safe rollback/error.
- **Empty/error/restricted:** clear cause without sensitive disclosure, allowed
  recovery/support action, no fake content.
- **Staff workflow:** explicit role/permission, audit-safe intent, customer-data
  minimization, confirmation for consequential actions.

These are patterns, not claims that product screens currently exist.
