# PORTAL

**PORTAL** is an Android-first, modular social and exploration platform that connects people, real-world places, visual discovery, AI characters, and location-based experiences.

> Project status: foundation and architecture phase. Features are not considered complete until implemented and tested.

## Product modules

- **PORTAL SOCIAL** — profiles, posts, media, reactions, comments, follows, and messaging.
- **PORTAL MAP** — an interactive world map with public places and opt-in geolocated discoveries.
- **PORTAL VISION** — camera-assisted place recognition using visual signals, OCR, and location context.
- **PORTAL AI** — clearly disclosed AI characters that can interact and contribute sourced information.
- **PORTAL EXPLORATION** — missions, clues, achievements, and community experiences designed around safety.

All modules share PORTAL CORE: identity, permissions, privacy, moderation, place records, and application services.

## Initial technology direction

- Flutter / Dart for the Android application.
- Supabase (PostgreSQL, Auth, Storage, Realtime, Edge Functions) for backend services.
- PostGIS for geographic queries.
- OpenStreetMap-compatible map data with required attribution and a replaceable tile provider.
- On-device ML Kit capabilities where supported; recognition providers remain replaceable.
- GitHub for source control and automated checks.

The stack is provisional until a small technical validation confirms current free-tier limits, Android compatibility, and device performance. No paid service is a prerequisite for the first prototype.

## Repository layout

```text
docs/                 architecture, roadmap, data and security decisions
lib/                  Flutter application source (next implementation stage)
supabase/             SQL migrations and backend functions
test/                 unit, widget and integration tests
assets/               app-owned visual assets
```

## Development principles

1. Build one integrated product, not disconnected demos.
2. Keep modules separated behind shared domain contracts.
3. Protect user data with server-side authorization and database RLS.
4. Never ship service-role keys or private credentials in the mobile app.
5. Make location sharing explicit, optional, and controllable.
6. Clearly label AI-generated content; require evidence for factual place claims.
7. Treat external services as replaceable adapters.
8. Document and test each milestone before calling it complete.

## Getting started

The Flutter application scaffold will be added after the architecture and environment checks. See [Architecture](docs/ARCHITECTURE.md), [Roadmap](docs/ROADMAP.md), [Database plan](docs/DATABASE.md), and [Security](docs/SECURITY.md).

## License

License to be selected before public distribution.
