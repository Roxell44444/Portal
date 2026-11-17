# PORTAL

**PORTAL** is an Android-first social discovery platform connecting people, real-world places, visual discovery, AI characters, and location-based experiences.

> Current phase: first functional foundation. Some product modules are still planned and are not represented as complete.

## Product modules

- **PORTAL SOCIAL** — profiles, posts, media, reactions, comments, follows, and messaging.
- **PORTAL MAP** — worldwide map, place search, optional device location, and saved places.
- **PORTAL VISION** — camera-assisted place recognition and OCR.
- **PORTAL AI** — disclosed AI characters with sourced factual information.
- **PORTAL EXPLORATION** — missions, clues, achievements, and community experiences.

All modules share PORTAL CORE: identity, permissions, privacy, moderation, place records, and application services.

## Implemented in the first code foundation

- Flutter application structure and Android build workflow.
- Supabase email registration, login, password reset, and logout integration.
- Basic user profile.
- Text post creation and public feed.
- OpenStreetMap-based world map, Nominatim place search, optional foreground location, external map links, and saved places schema.
- Initial PostgreSQL schema with Row Level Security policies.

Vision, AI characters, missions, messaging, comments, reactions, and media upload are not implemented yet.

## Technology

- Flutter / Dart
- Supabase Auth and PostgreSQL
- OpenStreetMap map tiles and Nominatim search for the prototype
- PostGIS-ready geographic architecture
- GitHub Actions for Android builds

The public OSM tile and Nominatim services have usage policies and are not unlimited production infrastructure. Before global scale, PORTAL must use a provider with an appropriate quota or self-hosted services, with attribution and caching requirements respected.

## Build

See [docs/SETUP.md](docs/SETUP.md) for Supabase setup, GitHub Actions secrets, and APK build instructions.

## Architecture and planning

- [Architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Database plan](docs/DATABASE.md)
- [Security](docs/SECURITY.md)
- [Setup](docs/SETUP.md)

## Security principles

Location access is optional and requested only when the user invokes the feature. No background tracking is enabled. Never place Supabase service-role keys in the mobile app.
