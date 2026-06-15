# Migration Gap Analysis: React → Flutter

## React Feature Inventory vs Flutter Status

### 🔴 MISSING — Not implemented at all

| React Component/Feature | Equivalent Needed in Flutter |
|---|---|
| `About.tsx` (7 bento cards: O Gap, O Conceito, Creator+LinkedIn+Email, Processo, Nosso Objetivo, Contribuir, Privacy) | `about/` module — entirely missing |
| `Navbar.tsx` (Logo, nav links: Home/About/Contribute/Privacy, Language Switcher PT/EN/ES, Login/UserMenu) | Top `AppBar` — entirely missing in shell; only bottom nav exists |
| `GlobalAssistant.tsx` (FAB chat overlay, AI chatbot, suggestion chips, markdown rendering) | `GlobalAssistantWidget` — entirely missing (FAB not present) |
| `UserMenu.tsx` (avatar, XP progress bar, level badge, stage icon, Drops counter, Impact/Roots stats, Admin badge, logout) | User profile widget — entirely missing |
| `AdminDashboard.tsx` (survey request list, approve/reject/delete actions, status badges) | `admin/` module — entirely missing |
| `SurveyForm.tsx` (country field, text/choice/rating questions, already-voted state, unauthenticated state, XP grant +50, confetti) | Survey answer flow — entirely missing |
| `SurveyTable.tsx` (data table with country, answers per question, date, CSV export button) | Survey data tab — entirely missing |
| `SurveyAI.tsx` (AI summary, country filter dropdown, Recalculate button, cache logic, skeleton loader, markdown) | Survey AI tab — entirely missing |
| `SurveyChat.tsx` (per-survey AI chat, clear button, suggestion chips, markdown, bounce loader) | Survey chat tab — entirely missing |
| `RequestSurveyModal.tsx` (title/category/description form, sends to `survey_requests`) | "Plant Idea" modal — entirely missing |
| `SurveyDetail` screen (tabs: Respond/Data/Presentation/Chat, "Share Pollen" button, back link, response count) | `nursery/survey_detail` screen — entirely missing |
| Footer (Ecosystem: Blooming / Horta v2.0 / Sow Initial Data / Nurtured by Lucas Batista) | Footer — entirely missing |
| Tag filter pill bar on Home (Entire Field + dynamic tags from surveys) | Tag filter — entirely missing |
| Animated hero header (Logo + "Horta / Cultive Conhecimento" h1, subtitle i18n, Plant Idea button, Admin button) | Nursery header is a bare AppBar |
| Empty state on Home ("Garden Bed is Empty" + Sow Seeds button) | Not present |
| i18n / Localization (PT/EN/ES for all strings, `useTranslation`) | No localization — all strings hardcoded in English |
| `Logo.tsx` (SVG logo rendered in Navbar and Home header) | Missing; no logo asset/widget |

---

### 🟡 PARTIAL — Exists but is a placeholder / stub

| Flutter File | What's Missing |
|---|---|
| `nursery_screen.dart` | Hardcoded 3 items. Missing: Firestore/API integration, bento grid layout, tag filter, animated header, survey card design (category, tags, accent colors), navigation to detail |
| `garden_screen.dart` | Hardcoded "Level 3 / 45 drops". Missing: real user data from API, dynamic stage icon (Droplets/Sprout/Tree), dynamic level label |
| `lab_screen.dart` | Stub with spinning loader only. Missing: survey list with AI summaries, country filter, global research chat |
| `login_screen.dart` | Need to verify it triggers Google Sign-In correctly |
| `routes.dart` | Missing routes: `/about`, `/survey/:id`. Missing: About and SurveyDetail pages |
| `main.dart` | Missing: `ApiService` registration, `UserProfileService` registration, locale/i18n |
| `theme.dart` | Missing: `indigo` accent color (used for AI/chat tabs in React), border radius constants (40px bento), surface variants |

---

### ✅ DONE — Correctly implemented

| Item | Status |
|---|---|
| `AuthService` (Google Sign-In → Go backend JWT → secure storage) | ✅ |
| `HortaTheme` (dark background, emerald primary, Inter/Space Grotesk fonts) | ✅ |
| `BentoCard` widget | ✅ (needs radius match: 40px) |
| `PlantProgressBar` widget | ✅ |
| `GoRouter` with shell + auth redirect guard | ✅ (incomplete routes) |
| `GetIt` DI bootstrap in main | ✅ (incomplete registrations) |

---

## Clean Architecture Folder Structure to Create

```
lib/app/
├── core/
│   ├── di/
│   │   └── injection.dart          ← register all singletons
│   ├── network/
│   │   └── api_service.dart        ← Dio + JWT interceptor
│   ├── router/
│   │   └── app_router.dart         ← moved from routes.dart
│   ├── storage/
│   │   └── storage_service.dart    ← wrap FlutterSecureStorage
│   ├── theme/
│   │   └── app_theme.dart          ← moved from theme.dart
│   ├── l10n/
│   │   ├── app_localizations.dart
│   │   ├── arb/app_pt.arb
│   │   ├── arb/app_en.arb
│   │   └── arb/app_es.arb
│   └── widgets/
│       ├── bento_card.dart
│       ├── plant_progress_bar.dart
│       ├── horta_logo.dart          ← NEW
│       └── global_assistant.dart    ← NEW (FAB overlay)
│
├── modules/
│   ├── auth/
│   │   ├── auth_binds.dart
│   │   ├── data/
│   │   │   ├── auth_datasource.dart
│   │   │   └── auth_datasource_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/user_profile.dart
│   │   │   └── repositories/auth_repository.dart
│   │   └── presenter/
│   │       ├── login_screen.dart    ← existing
│   │       └── cubits/
│   │           ├── auth_cubit.dart
│   │           └── auth_state.dart
│   │
│   ├── about/                       ← NEW MODULE
│   │   └── presenter/
│   │       ├── about_page.dart
│   │       └── widgets/
│   │           ├── about_bento_card.dart
│   │           └── creator_card.dart
│   │
│   ├── nursery/
│   │   ├── nursery_binds.dart
│   │   ├── data/
│   │   │   ├── survey_datasource.dart
│   │   │   └── survey_datasource_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/survey.dart
│   │   │   ├── entities/survey_question.dart
│   │   │   └── repositories/survey_repository.dart
│   │   └── presenter/
│   │       ├── nursery_screen.dart  ← refactor
│   │       ├── survey_detail_screen.dart  ← NEW
│   │       ├── widgets/
│   │       │   ├── survey_card.dart
│   │       │   ├── tag_filter_bar.dart     ← NEW
│   │       │   ├── survey_form_tab.dart    ← NEW
│   │       │   ├── survey_table_tab.dart   ← NEW
│   │       │   ├── survey_ai_tab.dart      ← NEW
│   │       │   ├── survey_chat_tab.dart    ← NEW
│   │       │   └── request_survey_modal.dart ← NEW
│   │       └── cubits/
│   │           ├── survey_cubit.dart
│   │           └── survey_state.dart
│   │
│   ├── garden/
│   │   ├── data/
│   │   │   └── user_datasource_impl.dart
│   │   ├── domain/
│   │   │   └── entities/user_profile.dart
│   │   └── presenter/
│   │       ├── garden_screen.dart  ← refactor
│   │       └── cubits/
│   │           ├── garden_cubit.dart
│   │           └── garden_state.dart
│   │
│   └── lab/
│       └── presenter/
│           └── lab_screen.dart     ← refactor (global AI + chat)
│
└── main.dart
```

---

## Implementation Priority Order

1. **Domain entities** (Survey, Question, UserProfile, SurveyRequest) — unblock everything
2. **ApiService** (Dio + JWT interceptor) + DI injection.dart
3. **NurseryScreen refactor** (real data + bento grid + tag filter)
4. **SurveyDetailScreen** (4 tabs: Form, Table, AI, Chat)
5. **AboutPage** (7 bento cards with all text/links)
6. **Navbar/AppBar** (logo, links, language switcher, user menu)
7. **UserMenu** (avatar, XP bar, level, admin badge)
8. **GlobalAssistant FAB** (chat overlay)
9. **AdminDashboard** (survey requests CRUD)
10. **GardenScreen refactor** (real data)
11. **LabScreen refactor** (real data)
12. **i18n** (PT/EN/ES strings)
