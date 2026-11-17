# PORTAL roadmap

Milestones are sequential. A milestone is complete only after its acceptance checks pass.

## M0 — Repository and architecture
- [x] Confirm independent PORTAL repository and default branch.
- [x] Document product modules and system boundaries.
- [ ] Add Flutter scaffold and automated formatting/analyzer workflow.
- [ ] Record verified toolchain and dependency versions.

**Acceptance:** repository structure is coherent; architecture and security decisions are documented.

## M1 — App shell and design system
- [ ] App entry point, theme, responsive layout.
- [ ] Navigation shell with placeholder routes for the five product modules.
- [ ] Shared loading, empty, error, and permission states.
- [ ] Widget tests for navigation and theme.

## M2 — Identity and profiles
- [ ] Authentication adapter and session handling.
- [ ] Profile creation/editing and account settings.
- [ ] Database migrations and RLS tests.
- [ ] Privacy defaults and account deletion plan.

## M3 — Social foundation
- [ ] Posts, media metadata, comments, reactions, follows.
- [ ] Feed pagination and moderation/report flows.
- [ ] Storage access rules and abuse controls.

## M4 — Map and places
- [ ] Map provider adapter and attribution.
- [ ] Place search and canonical place records.
- [ ] User-confirmed discoveries and privacy-aware geo queries.

## M5 — Vision
- [ ] Camera permission and capture flow.
- [ ] OCR / recognition proof of concept on target Android devices.
- [ ] Candidate matching with confidence and user confirmation.

## M6 — AI characters
- [ ] Character profiles and visible AI disclosure.
- [ ] Provider abstraction and safe generation pipeline.
- [ ] Source-aware place answers and moderation.

## M7 — Exploration
- [ ] Mission definitions, progress, achievements.
- [ ] Safe geofencing rules and abuse prevention.
- [ ] Cross-module discovery-to-mission workflow.

## M8 — Messaging, notifications, and hardening
- [ ] Conversations and message permissions.
- [ ] Notifications and user controls.
- [ ] Security review, performance checks, accessibility.

## M9 — Android release candidate
- [ ] Unit, widget, integration, and backend policy tests.
- [ ] Build reproducibly in CI.
- [ ] Verify install and core flows on a real Android device.
- [ ] Prepare privacy disclosures and release documentation.

No milestone is declared complete based only on code being written.
