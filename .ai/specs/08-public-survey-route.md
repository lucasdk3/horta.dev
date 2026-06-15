# SPEC 08 — Public Survey Route (no login required)

> Goal: allow anyone with a link to answer a survey without being logged in.  
> A "Login" button in the top-right corner lets them jump to the authenticated app.

---

## Problem

The current router blocks every route when `!isAuthenticated` and redirects to `/login`.  
There is no way to share a survey link with an external respondent who doesn't have an account.

---

## Solution overview

1. Add a new **public** route `/s/:id` that renders only the survey form tab.
2. Exempt `/s/:id` from the auth redirect guard.
3. Show a lightweight top bar with a **"Login"** button (top-right) in place of the full `MainShell` navbar.
4. Anonymous form submissions are allowed — the API already accepts responses without a user token (respondent is stored as `null` / `anonymous`).

---

## Router changes

**File:** `lib/app/core/router/app_router.dart`

```dart
redirect: (context, state) {
  final authService = GetIt.I<AuthService>();
  final isAuth = authService.isAuthenticated;
  final path = state.uri.toString();

  final publicPaths = {'/login'};
  final isPublic = publicPaths.contains(path) ||
      path.startsWith('/s/');          // ← new public prefix

  if (!isAuth && !isPublic) return '/login';
  if (isAuth && path == '/login') return '/nursery';
  return null;
},
routes: [
  GoRoute(path: '/login', builder: (_, __) => const LoginPage()),

  // ── Public survey respond route ──────────────────────────────
  GoRoute(
    path: '/s/:id',
    builder: (_, state) =>
        PublicSurveyPage(surveyId: state.pathParameters['id']!),
  ),

  // ── Authenticated shell ──────────────────────────────────────
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) => MainShell(child: child),
    routes: [
      GoRoute(path: '/nursery', builder: (_, __) => const NurseryScreen()),
      GoRoute(
        path: '/survey/:id',
        builder: (_, state) =>
            SurveyDetailScreen(surveyId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/garden', builder: (_, __) => const GardenScreen()),
      GoRoute(path: '/lab',     builder: (_, __) => const LabScreen()),
      GoRoute(path: '/about',   builder: (_, __) => const AboutPage()),
      GoRoute(path: '/admin',   builder: (_, __) => const AdminDashboard()),
    ],
  ),
],
```

> **Import rule (Spec 07 §8):** replace the 7 direct imports in `app_router.dart`  
> with `_exports.dart` imports per module. Do this in the same PR.

---

## New file — `PublicSurveyPage`

**Path:** `lib/app/modules/nursery/presenter/public_survey_page.dart`  
**Max lines:** 120

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/horta_logo.dart';
import '../domain/entities/survey.dart';
import '../domain/entities/survey_response.dart';
import 'widgets/survey_form_tab.dart';

class PublicSurveyPage extends StatefulWidget {
  const PublicSurveyPage({super.key, required this.surveyId});
  final String surveyId;

  @override
  State<PublicSurveyPage> createState() => _PublicSurveyPageState();
}

class _PublicSurveyPageState extends State<PublicSurveyPage> {
  Survey? _survey;
  List<SurveyResponse> _responses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Use NurseryRepository / ApiService via GetIt — anonymous call (no auth header needed)
    final api = GetIt.I<ApiService>();
    try {
      final [surveyData, responsesData] = await Future.wait([
        api.getSurveyById(widget.surveyId),
        api.getSurveyResponses(widget.surveyId),
      ]);
      setState(() {
        _survey = Survey.fromJson(surveyData as Map<String, dynamic>);
        _responses = (responsesData as List<Map<String, dynamic>>)
            .map(SurveyResponse.fromJson)
            .toList();
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HortaTheme.darkBackground,
      body: Column(
        children: [
          _PublicTopBar(surveyTitle: _survey?.title.get(context.locale.languageCode)),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_survey == null)
            const Expanded(child: Center(child: Text('Survey not found', style: TextStyle(color: Colors.white54))))
          else
            Expanded(
              child: SurveyFormTab(
                survey: _survey!,
                responses: _responses,
                onSuccess: _load,
              ),
            ),
        ],
      ),
    );
  }
}
```

---

## New widget — `_PublicTopBar`

**Lives in:** `public_survey_page.dart` (private widget, same file, keeps page ≤ 120 lines total)

```dart
class _PublicTopBar extends StatelessWidget {
  const _PublicTopBar({this.surveyTitle});
  final String? surveyTitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            const HortaLogo(size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                surveyTitle ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.go('/login'),
              style: TextButton.styleFrom(
                foregroundColor: HortaTheme.primaryEmerald,
              ),
              child: const Text('Login', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## `_exports.dart` update

Add to `lib/app/modules/nursery/presenter/_exports.dart`:

```dart
export 'public_survey_page.dart';
```

---

## Sharing a survey link

When a survey is shared (e.g. from `SurveyDetailScreen`'s **Share** button), the URL generated must use `/s/:id`, not `/survey/:id`:

```dart
// in SurveyDetailScreen — share button handler
final shareUrl = 'https://horta.dev/s/${survey.id}';
Clipboard.setData(ClipboardData(text: shareUrl));
```

---

## Anonymous submission contract (API)

- `POST /surveys/:id/responses` must accept requests **without** a `Authorization` header.
- The backend stores `respondentId: null` for anonymous responses.
- No changes needed to `SurveyFormTab` — it already calls `ApiService.submitResponse()` which forwards the token only if present.

> If `ApiService` currently always attaches the auth header, add a nullable override:  
> `Future<void> submitResponse(String surveyId, Map<String, dynamic> answers, {bool anonymous = false})`

---

## Checklist

- [ ] Update `app_router.dart` — add public `/s/:id` route + fix imports to use `_exports.dart`
- [ ] Create `nursery/presenter/public_survey_page.dart` (≤ 120 lines)
- [ ] Export from `nursery/presenter/_exports.dart`
- [ ] Update **Share** button in `SurveyDetailScreen` to copy `/s/:id` URL
- [ ] Confirm `POST /surveys/:id/responses` works without auth token (backend contract)
- [ ] Add i18n key `survey.login_cta` → `"Login"` in all 3 translation files

---

## Out of scope

- Rate limiting / CAPTCHA for anonymous submissions (post-MVP)
- Showing the respondent count or analysis tabs to anonymous users
- Social/embed preview metadata (OG tags) — web only, not Flutter concern
