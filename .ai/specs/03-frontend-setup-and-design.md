# Step 3: Flutter Frontend Setup & Design System

## Objective
Bootstrap the Flutter project (Web, Android, iOS) and implement the core architecture and "Horta DNA" design system.

## Tasks
- [ ] **Project Initialization**: Create a new Flutter project (SDK ^3.24.0) supporting Web, Android, and iOS.
- [ ] **Folder Structure**: Implement the structured layout:
  - `lib/app/core/` (Interfaces, DI, Network, Theme)
  - `lib/app/data/` (Models/DTOs, API Clients)
  - `lib/app/domain/` (Repositories, Entities, UseCases)
  - `lib/app/modules/` (Bloc, Widgets, Screens)
- [ ] **Core Dependencies Setup**:
  - `flutter_bloc` for state management.
  - `get_it` for Dependency Injection.
  - `go_router` for navigation.
  - `dio` for HTTP requests to the Go API.
  - `firebase_auth` for Google Social Login.
- [ ] **Design System Implementation**:
  - Set up `ThemeData` enforcing dark mode (`#020402`).
  - Define color tokens: Primary `Emerald-500` (`#10b981`), Surface `white.withValues(alpha:0.05)`.
  - Configure `google_fonts` using Inter and Space Grotesk.
- [ ] **Core Widgets**:
  - Implement `BentoCard` (borderRadius: 40.0, backdrop blur, white/5 border).
  - Implement `PlantProgressBar` (Emerald gradient for "Drops").

## Expected Outcome
A clean Flutter foundation with routing, state management, DI, and a fully configured theme matching the Horta visual identity.
