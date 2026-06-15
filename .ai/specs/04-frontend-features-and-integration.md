# Step 4: Frontend Features & Integration

## Objective
Implement the main application modules in Flutter and connect them to the Go microservices and Firebase Auth.

## Tasks
- [ ] **Authentication Flow**: Implement Google Login via `firebase_auth`. Sync user creation/login with the backend if necessary.
- [ ] **Nursery Module (Listagem de Pesquisas)**:
  - Create the UI to list active surveys using `BentoCard` elements.
  - Integrate with the Go Survey Service to fetch surveys.
- [ ] **Garden Module (Gamificação e Perfil)**:
  - Display user XP ("Drops") and level (Semente, Broto, Árvore).
  - Show the `PlantProgressBar` and update it dynamically based on the current level.
- [ ] **Lab Module (Insights IA e Chat)**:
  - Implement the UI to display the AI-generated markdown summary from `survey_analyses`.
  - Connect to the AI Gateway Service to fetch or request new analysis.
- [ ] **Response Flow**:
  - Implement the survey answering interface.
  - Send the user's responses to the Go Response Service via HTTP (`dio`).
  - Listen for (or optimistically update) the resulting level/XP changes.

## Expected Outcome
A complete, functioning Flutter application that matches the previous React version's functionality while relying on the new Go backend and Dapr infrastructure.
