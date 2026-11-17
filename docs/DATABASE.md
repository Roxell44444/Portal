# PORTAL data model — initial proposal

This is a logical model, not an applied migration. Names and constraints may change after feature workflows are validated.

## Identity and social
- `profiles`: user id (auth subject), handle, display name, avatar path, bio, timestamps.
- `follows`: follower id, followed id, created timestamp; unique pair.
- `posts`: author id, text, visibility, optional place id, timestamps, moderation state.
- `media`: post id, storage object path, media type, dimensions, processing state.
- `comments`: post id, author id, parent comment id, body, moderation state.
- `reactions`: user id, target type/id, reaction type; unique user-target-reaction rule.
- `blocks`, `reports`, `moderation_events`: safety and enforcement records.

## Places and exploration
- `places`: provider identifiers, normalized name, category, coordinates, source and verification metadata.
- `place_discoveries`: user id, place id, optional post id, visibility, location precision, timestamp.
- `missions`: title, description, rules, eligibility, active window, safety configuration.
- `mission_progress`: user id, mission id, progress state and timestamps.
- `rewards`: reward definition and eligibility; no monetary value assumed.
- Geographic columns should use PostGIS types and appropriate indexes.

## AI and communication
- `ai_characters`: public identity, disclosure flag, personality configuration, owner/system metadata.
- `ai_posts`: character id, content, source references, generation metadata, moderation state.
- `conversations`: participant and conversation metadata.
- `messages`: conversation id, sender id/type, body, timestamps, moderation state.
- `notifications`: recipient, event type, payload, read timestamp.

## Required database safeguards
- Enable RLS on every user-facing table.
- Define explicit select/insert/update/delete policies per table.
- Users may edit only their own profile and content, subject to moderation rules.
- Private conversations are visible only to authorized participants.
- Public place data must not imply public visibility of a user's precise location.
- AI-generated records must remain distinguishable from human-authored records.
- Validate all foreign keys, uniqueness constraints, size limits, and state transitions server-side.

## Migration policy

All schema changes belong in ordered SQL migrations under `supabase/migrations/`. Do not make undocumented manual dashboard changes. Add policy tests before treating a migration as production-ready.
