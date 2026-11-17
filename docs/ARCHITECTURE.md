# PORTAL architecture

## 1. System shape

The mobile client is a Flutter application. Supabase is the initial backend candidate. External maps, geocoding, OCR, and AI inference are accessed through adapters so they can be replaced without rewriting product logic.

```text
Flutter UI
  -> Feature presentation (Social / Map / Vision / AI / Exploration)
  -> Shared application services and domain contracts
  -> Repository interfaces
  -> Data adapters
       -> Supabase
       -> Map/geocoding provider
       -> On-device camera and OCR
       -> Optional AI inference provider
```

## 2. Client layers

- **Presentation:** screens, widgets, navigation, state.
- **Application:** use cases and orchestration across modules.
- **Domain:** entities, value objects, repository contracts, validation rules.
- **Data / infrastructure:** Supabase clients, serialization, device APIs, and external providers.

Feature code should depend inward on domain contracts, not directly on vendor SDKs.

## 3. Shared core

Identity, permissions, user settings, privacy controls, moderation, notifications, and place identity are shared capabilities. Cross-feature workflows must use these services rather than duplicating logic.

## 4. Key cross-module workflow

A user chooses to discover a public place:
1. Vision captures an image only after camera permission and user action.
2. Device location is optional context and its precision is minimized.
3. Recognition produces candidate matches, not unquestionable facts.
4. Map resolves the candidate against trusted place data.
5. The user confirms before creating a public discovery or post.
6. Social publishes only the content and location visibility the user selected.
7. AI may add a sourced explanation, clearly labeled as AI-generated.
8. Exploration may associate the discovery with an eligible mission.

## 5. Backend boundaries

Supabase owns authentication, relational data, storage metadata, realtime events, and server-side functions. Authorization is enforced with Row Level Security and server-side validation. The client must never contain a service-role key.

## 6. Geographic design

Store canonical place records separately from user discoveries. Use PostGIS for radius and bounding-box queries. Do not expose a user's live location by default. Public posts should use an explicitly chosen place or coarse location unless the user knowingly selects greater precision.

## 7. AI design

AI character identity, personality configuration, inference provider, and generated content are separate concerns. Every AI account and generated contribution must be visibly disclosed. Factual claims about real places should include source references or be marked unverified. AI must not fabricate visits, human experiences, or real-time observations.

## 8. Replaceability and cost

Avoid coupling core business rules to a single map tile host, geocoder, OCR SDK, or model provider. Prefer local/on-device processing where practical. Before enabling any hosted service, verify its current free-tier limits and operational restrictions.
