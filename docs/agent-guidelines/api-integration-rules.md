# API integration rules

Inspect the authoritative backend OpenAPI/source contract and Postman
collection in `../api` before coding. Read-only inspection does not authorize
modifying that sibling. Never fabricate a route, field, enum, permission,
state, or response shape to satisfy a mockup.

All calls use the centralized `ApiClient` and its Dio instance in
`lib/core/api/api_client.dart`; widgets never call APIs or instantiate `Dio`.
Feature repositories/services own typed request and response DTOs, explicit
serialization/parsing, and domain mapping. Do not leak raw DTOs or raw backend
messages into UI.

Preserve `AuthorizationInterceptor`, `SanitizedLoggingInterceptor`,
`FailureInterceptor`, `RefreshCoordinator`, cancellation tokens, configured
timeouts, request-ID capture, and `AppFailure` mapping. Authentication refresh
must remain serialized when its real endpoint is implemented. User messages
come from generated localization keys, never backend text or technical codes.

Model pagination, sorting, filters, nullability, and errors exactly as the
contract defines. Prefer `/me` endpoints where supported; do not send arbitrary
user identifiers when the authenticated identity is sufficient. Pass
`CancelToken` through cancellable work. Do not silently assume response
envelopes, pagination defaults, time zones, currencies, or identifier formats.

Timeout policy distinguishes safe reads from money-moving writes. Capture
request IDs and idempotency keys; never blindly retry a financial request.

Flutter Web development uses the repository same-origin `/api/` development
proxy. Endpoint constants remain canonical `/api/v1/...` paths and platform
resolution stays inside environment configuration. Native development uses the
direct configured backend URL; staging and production never use the proxy.
Never work around CORS with browser-security changes or unsafe Chrome flags.

## Contract-gap record

When UI needs unsupported behavior, document:

- desired behavior and current API behavior;
- missing field or route;
- security and UX impact;
- safe temporary behavior (often disabled/unavailable, never fake data);
- backend decision required and owner/follow-up.

Authentication UI implementation may not begin until the feature's backend
contract, Visual Reference Contract, state machine, security contract, and
contract gaps are documented. The feature package links these artifacts;
general API guidance must not duplicate or replace them.
