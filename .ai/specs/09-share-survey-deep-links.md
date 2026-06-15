# SPEC 09 — Share Survey Button + Web Deep Links

> Goal: let users copy a public survey link directly from the survey card, and make every authenticated route work as a web deep link (unauthenticated visitors are redirected to login and sent back to the original URL after signing in).

---

## Problem 1 — No share affordance on SurveyCard

The share button only exists inside `SurveyDetailScreen`. A user browsing the nursery grid has no quick way to copy and send a survey link without opening it first.

## Problem 2 — Deep links break after login

When an unauthenticated user visits `horta.dev/survey/abc` directly (e.g. from a bookmark or shared URL), the router redirects to `/login`. After a successful login, `LoginPage` hard-codes `context.go('/nursery')`, losing the original destination.

---

## Solution 1 — Share button on `SurveyCard`

### What changes

**File:** `lib/app/modules/nursery/presenter/widgets/survey_card.dart`

- Replace the decorative `Icons.water_drop` container in the bottom-right with a tappable share icon.
- Tapping it copies `https://horta.dev/s/${survey.id}` to the clipboard.
- Shows a `SnackBar` with `'Link copied!'`.
- `GestureDetector` with `behavior: HitTestBehavior.opaque` prevents the tap from bubbling up to the card's `onTap` (which navigates to the detail screen).

```dart
// bottom row — right side (replaces the water_drop container)
GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () {
    Clipboard.setData(ClipboardData(
      text: 'https://horta.dev/s/${widget.survey.id}',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied!'), duration: Duration(seconds: 2)),
    );
  },
  child: Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha:0.04),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha:0.05)),
    ),
    child: Icon(Icons.ios_share, color: widget.accent, size: 20),
  ),
)
```

**Required import:** `import 'package:flutter/services.dart';`

---

## Solution 2 — Web deep link routing

### Redirect guard — `app_router.dart`

When an unauthenticated user hits a protected route, encode the original path as a `?from=` query parameter on the login redirect so it can be restored after login.

```dart
redirect: (context, state) {
  final authService = GetIt.I<AuthService>();
  final isAuth = authService.isAuthenticated;
  final uriPath = state.uri.path;       // '/survey/abc' — no query string
  final isPublic = uriPath == '/login' || uriPath.startsWith('/s/');

  if (!isAuth && !isPublic) {
    return '/login?from=${Uri.encodeComponent(uriPath)}';
  }
  if (isAuth && uriPath == '/login') {
    final from = state.uri.queryParameters['from'];
    return (from != null && from.isNotEmpty) ? from : '/nursery';
  }
  return null;
},
```

Also update the `/login` route builder to forward `from`:

```dart
GoRoute(
  path: '/login',
  builder: (_, state) =>
      LoginPage(from: state.uri.queryParameters['from']),
),
```

### `LoginPage` — accept `from` parameter

**File:** `lib/app/modules/auth/presenter/login_page.dart`

```dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) context.go(from ?? '/nursery');
          if (state is AuthError) { /* snackbar */ }
        },
        child: const _LoginBody(),
      ),
    );
  }
}
```

> `_LoginBody` stays `const` — it has no dependency on `from`.

---

## Route table (after changes)

| URL pattern | Auth required | Notes |
|---|---|---|
| `/login` | No | Shows `?from=` param when redirected |
| `/s/:id` | No | Public survey — anonymous form only |
| `/nursery` | Yes | Deep-linkable: `/login?from=%2Fnursery` |
| `/survey/:id` | Yes | Deep-linkable: `/login?from=%2Fsurvey%2Fabc` |
| `/garden` | Yes | Deep-linkable |
| `/lab` | Yes | Deep-linkable |
| `/about` | Yes | Deep-linkable |
| `/admin` | Yes | Deep-linkable |

---

## Checklist

- [ ] `survey_card.dart` — replace water_drop with share icon button
- [ ] `app_router.dart` — redirect uses `state.uri.path`, encodes `?from=`, login builder passes `from`
- [ ] `login_page.dart` — accept `from` param, `context.go(from ?? '/nursery')` on success
