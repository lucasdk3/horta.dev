# Spec: Missing Implementation & Feature Parity (React → Flutter)

This document outlines the remaining tasks to reach 100% parity with the legacy React implementation and finalize the premium "Horta DNA" refinement.

## 1. UI Components & Features

### 1.1 About Page: Missing LinkedIn/Socials
- **Missing**: The `Linkedin` and `Mail` action buttons/components in the creator section are not fully implemented or differ from the React version.
- **Task**: Add the `Linkedin` and `Email` buttons to `AboutPage.dart` with consistent styling (Hover effects, glassmorphism icons).
- **Ref**: `legacy_react/src/components/About.tsx` (lines 94-114).

### 1.2 Global Assistant (AI Bot)
- **Missing**: The `GlobalAssistant` component is a floating/global AI bot that exists across all pages in React.
- **Task**: Implement a `GlobalAssistant` widget in Flutter that can be toggled globally (perhaps integrated into the `HortaNavbar` or as a `Stack` overlay in `AppRouter`).
- **Ref**: `legacy_react/src/components/GlobalAssistant.tsx`.

### 1.3 Request Survey Modal ("Plant Idea")
- **Missing**: The "Plant Idea" button in React opens a modal to submit a new survey suggestion.
- **Task**: Implement `RequestSurveyModal` in Flutter and wire it to the `NurseryScreen` (Plant Idea button) and the `/api/v1/survey-requests/` POST endpoint.
- **Ref**: `legacy_react/src/components/RequestSurveyModal.tsx`.

### 1.4 Footer Refinement
- **Missing**: The Flutter footer is simpler than the React one.
- **Task**: Update `HortaFooter` to include "Ecosystem: Blooming", "Horta v2.0", and the "Nurtured by Lucas Batista" credits with matching typography.
- **Ref**: `legacy_react/src/App.tsx` (lines 376-385).

---

## 2. Localization (i18n)

While many screens have been localized, the following areas still require `.tr()` integration and JSON mapping:

### 2.1 Survey Table Tab
- **Task**: Localize "TOTAL RESPONSES", "COUNTRY", "DATE", "Export CSV", and "No responses yet".
- **Dynamic**: Ensure question labels use `q.label.get(context.locale.languageCode)`.

### 2.2 Lab Screen (AI Research Hub)
- **Task**: Full localization of the `LabScreen` (titles, descriptions, research categories).

### 2.3 Admin Dashboard
- **Task**: Localize the `AdminDashboard` labels (Survey Requests, Status badges, Approve/Reject tooltips).

### 2.4 Error & Feedback Messages
- **Task**: Localize all `SnackBar` messages (e.g., "+50 XP earned!", "Failed to submit", "Request Sent").

---

## 3. Missing Logic & Parity

### 3.1 Voted Status
- **Issue**: The "Already Responded" check in `SurveyFormTab` is currently a hardcoded `false`.
- **Task**: Implement logic to check if the current user UID is present in the `responses` list for a specific survey.

### 3.2 CSV Export
- **Task**: Implement the CSV export functionality in `SurveyTableTab` using the `csv` and `path_provider` (or web equivalent) packages.

---

## 4. Design System Consistency

### 4.1 Accent Colors
- **Issue**: React uses a rotation of accent colors (`red`, `blue`, `pink`, `orange`, `purple`, `yellow`) for survey cards. Flutter currently uses a single accent color or less variety.
- **Task**: Port the `getAccentColor` logic to the `NurseryScreen` card rendering.

### 4.2 Typography
- **Task**: Ensure `Space Grotesk` is applied to *all* headings and `Inter` to all body text consistently across new modules.
