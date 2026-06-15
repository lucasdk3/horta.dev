# Step 2: Go Backend Core & Microservices

## Objective
Implement the backend using Go (1.22+), integrating with Firebase and Dapr, and separate responsibilities into microservices.

## Tasks
- [ ] **Project Initialization**: Initialize the Go module and set up the HTTP framework (Gin-Gonic or Echo).
- [ ] **Firebase SDK Integration**: Integrate `firebase.google.com/go/v4` to connect to Firestore. Ensure it can read/write to `users`, `surveys`, `responses`, and `survey_analyses` collections matching the existing schema.
- [ ] **Dapr SDK Integration**: Integrate the Go Dapr SDK for state management and Pub/Sub events.
- [ ] **Survey Service**: Create the service responsible for CRUD operations on surveys.
- [ ] **Response Service**: Create the service to process user responses and emit "response submitted" events via Dapr Pub/Sub.
- [ ] **Gamification Service**: Create the service that listens to response events (via Dapr Pub/Sub), calculates XP ("Drops") using the formula `Math.floor(Math.sqrt(XP / 100)) + 1`, and updates user levels.
- [ ] **AI Gateway Service**: Implement a proxy for the Gemini 1.5 Flash API. Implement the Token Save strategy (checking `survey_analyses` cache for existing `responseCount`, `lang`, and `countryFilter` before requesting new summaries).

## Expected Outcome
Fully functional Go microservices capable of interacting with the legacy Firestore database, with Dapr handling inter-service events and the AI Gateway optimizing Gemini tokens.
