import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';

import 'app/core/di/injection.dart';
import 'app/core/router/app_router.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/theme/theme_notifier.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.stg;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupInjection();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const HortaApp(),
    ),
  );
}

class HortaApp extends StatefulWidget {
  const HortaApp({super.key});

  @override
  State<HortaApp> createState() => _HortaAppState();
}

class _HortaAppState extends State<HortaApp> {
  final _themeNotifier = GetIt.I<ThemeNotifier>();

  @override
  void initState() {
    super.initState();
    _themeNotifier.addListener(_onThemeChange);
  }

  void _onThemeChange() => setState(() {});

  @override
  void dispose() {
    _themeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: F.title,
      debugShowCheckedModeBanner: true,
      theme: HortaTheme.lightTheme,
      darkTheme: HortaTheme.darkTheme,
      themeMode: _themeNotifier.mode,
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
