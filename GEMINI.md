# Project Instructions (GEMINI.md)

This file contains foundational mandates, conventions, and workflows for the `gestion-vinted` project.

## Project Vision
A 100% serverless Flutter application for Vinted inventory management with P2P synchronization (BLE/Wi-Fi Direct).

## Stack Technique
- **Framework:** Flutter (Multiplatform: Android, iOS, Windows, macOS)
- **UI/Animations:** `flutter_animate`
- **Database:** Isar (Offline-first, high performance)
- **State Management:** Riverpod
- **Connectivity:** `flutter_blue_plus` (BLE), `nsd` (Service discovery)

## Architecture & Conventions
- **Pattern:** Clean Architecture / Feature-based layering.
- **Rules:**
  - Strict separation of Business Logic (Domain/Data) and UI (Presentation).
  - Every entity must include `updatedAt` (DateTime) for conflict resolution.
  - No server-side dependencies; all sync is P2P.
  - Follow SOLID principles.

## Workflows
- Iterate step-by-step; do not implement large chunks of code at once.
- Maintain comprehensive documentation for P2P protocols.


