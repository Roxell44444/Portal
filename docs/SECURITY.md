# PORTAL security and privacy baseline

## Non-negotiable rules
- Never commit passwords, access tokens, signing keys, service-role keys, or private credentials.
- Mobile clients use only public client configuration and user-scoped sessions.
- Enforce authorization in PostgreSQL RLS and trusted server-side functions; UI checks are not security boundaries.
- Validate uploads, content size/type, ownership, and rate limits.
- Provide block, report, and moderation mechanisms before opening user-generated content broadly.

## Location and camera
- Ask permission at the moment a feature needs it and explain why.
- Camera and location access are optional; core browsing should remain usable without them.
- Do not collect background location for the initial release.
- Let users preview and choose location precision before publishing.
- Do not reveal home, school, or other sensitive routine locations through public missions or profiles.
- Store only the precision and duration needed for the feature; define retention and deletion behavior.

## AI transparency
- Clearly label AI characters and AI-generated posts/messages.
- Do not present generated content as a real person's experience or verified live observation.
- Preserve source references for factual place information.
- Add rate limits, moderation, and user reporting to AI interactions.

## Operational safeguards
- Keep secrets in backend environment configuration.
- Use separate development and production environments.
- Review database policies and storage rules as part of every relevant change.
- Provide account export/deletion planning before public launch.
- Do not claim compliance or security certification without an actual review.
