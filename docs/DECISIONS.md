# PORTAL architecture decisions

## ADR-001 — Android-first Flutter client
**Status:** provisional, accepted for prototype.

Flutter provides a single maintainable client codebase for the initial Android target. Revisit only if device testing shows a material blocker.

## ADR-002 — Supabase as initial backend candidate
**Status:** provisional.

PostgreSQL, Auth, Storage, Realtime, and server-side functions cover the prototype's initial needs. Current free-tier limits, inactivity behavior, regional availability, and data residency must be checked before deployment. The architecture keeps backend access behind repositories.

## ADR-003 — Replaceable map and AI providers
**Status:** accepted.

No core domain logic should depend on a single map tile host, geocoder, OCR SDK, or AI model provider.

## ADR-004 — Explicit user control of location
**Status:** accepted.

No background tracking in the initial release. Publishing a discovery requires a user action and a clear choice of location visibility.

## ADR-005 — AI identity disclosure
**Status:** accepted.

AI characters and generated contributions must be clearly identified as AI, not represented as human users.
