# PORTAL roadmap

Milestones are sequential. A milestone is complete only after its acceptance checks pass.

## M0 — Repository and architecture
- [x] Confirm independent PORTAL repository and default branch.
- [x] Document product modules, architecture, data model, roadmap, and security baseline.
- [x] Add Flutter dependencies, source layout, and Android CI build workflow.
- [ ] Confirm successful CI build on GitHub Actions.

## M1 — App shell and first vertical slice
- [x] Dark PORTAL theme and bottom navigation.
- [x] Login, registration, password reset, and logout integration with Supabase Auth.
- [x] Basic account profile.
- [x] Text post composer and public feed integration.
- [x] Global OSM map, manual place search, optional foreground location, and external map link.
- [x] Save discovered places to the signed-in user's account.
- [ ] Test the full flow against a real Supabase project and Android device.

## M2 — Complete identity and profiles
- [ ] Profile editing, username uniqueness flow, avatar upload.
- [ ] Account privacy controls and account deletion.
- [ ] Auth email-confirmation and recovery flows verified end to end.

## M3 — Social network
- [ ] Photo/video uploads and media processing.
- [ ] Comments, reactions, follows, and feed ranking.
- [ ] Direct messaging and notifications.
- [ ] Reporting, blocking, and moderation workflows.

## M4 — Global map and places
- [ ] Provider abstraction and production geocoder/tile hosting plan.
- [ ] PostGIS indexes and nearby-place queries.
- [ ] Place pages, categories, saved lists, and discovery records.
- [ ] Routing provider and route presentation.
- [ ] Review ODbL attribution and share-alike obligations.

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
- [ ] Safe location rules and abuse prevention.
- [ ] Cross-module discovery-to-mission workflow.

## M8 — Hardening
- [ ] RLS and storage policy tests.
- [ ] Security, privacy, performance, and accessibility review.
- [ ] Unit, widget, integration, and backend tests.

## M9 — Android release candidate
- [ ] Reproducible release build and install test.
- [ ] Privacy disclosures and release documentation.
- [ ] Validate all core flows on a real Android device.

A checkmark means code or documentation exists, not that production readiness has been proven. No milestone is declared complete from code generation alone.
