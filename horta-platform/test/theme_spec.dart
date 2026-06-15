import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horta_platform/app/core/theme/app_theme.dart';
import 'package:horta_platform/app/core/theme/theme_notifier.dart';

void main() {
  group('HortaTheme', () {
    test('darkTheme has correct brightness', () {
      expect(HortaTheme.darkTheme.brightness, Brightness.dark);
    });

    test('lightTheme has correct brightness', () {
      expect(HortaTheme.lightTheme.brightness, Brightness.light);
    });

    test('darkTheme scaffold background is near-black', () {
      expect(
        HortaTheme.darkTheme.scaffoldBackgroundColor,
        const Color(0xFF020402),
      );
    });

    test('lightTheme scaffold background is light green-grey', () {
      expect(
        HortaTheme.lightTheme.scaffoldBackgroundColor,
        const Color(0xFFEEF3F1),
      );
    });

    test('both themes share the same primary emerald color', () {
      expect(HortaTheme.darkTheme.primaryColor, HortaTheme.primaryEmerald);
      expect(HortaTheme.lightTheme.primaryColor, HortaTheme.primaryEmerald);
    });

    group('context-aware helpers', () {
      testWidgets('pageText returns white in dark mode', (tester) async {
        late Color result;
        await tester.pumpWidget(
          MaterialApp(
            theme: HortaTheme.lightTheme,
            darkTheme: HortaTheme.darkTheme,
            themeMode: ThemeMode.dark,
            home: Builder(builder: (ctx) {
              result = HortaTheme.pageText(ctx);
              return const SizedBox();
            }),
          ),
        );
        expect(result, HortaTheme.textPrimary);
      });

      testWidgets('pageText returns dark in light mode', (tester) async {
        late Color result;
        await tester.pumpWidget(
          MaterialApp(
            theme: HortaTheme.lightTheme,
            darkTheme: HortaTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: Builder(builder: (ctx) {
              result = HortaTheme.pageText(ctx);
              return const SizedBox();
            }),
          ),
        );
        expect(result, HortaTheme.textOnLight);
      });

      testWidgets('containerBg returns darkSurface in dark mode', (tester) async {
        late Color result;
        await tester.pumpWidget(
          MaterialApp(
            theme: HortaTheme.lightTheme,
            darkTheme: HortaTheme.darkTheme,
            themeMode: ThemeMode.dark,
            home: Builder(builder: (ctx) {
              result = HortaTheme.containerBg(ctx);
              return const SizedBox();
            }),
          ),
        );
        expect(result, HortaTheme.darkSurface);
      });

      testWidgets('containerBg returns white in light mode', (tester) async {
        late Color result;
        await tester.pumpWidget(
          MaterialApp(
            theme: HortaTheme.lightTheme,
            darkTheme: HortaTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: Builder(builder: (ctx) {
              result = HortaTheme.containerBg(ctx);
              return const SizedBox();
            }),
          ),
        );
        expect(result, HortaTheme.cardBackground);
      });
    });
  });

  group('ThemeNotifier', () {
    test('starts in dark mode', () {
      final notifier = ThemeNotifier();
      expect(notifier.mode, ThemeMode.dark);
      expect(notifier.isDark, isTrue);
    });

    test('toggle switches to light mode', () {
      final notifier = ThemeNotifier();
      notifier.toggle();
      expect(notifier.mode, ThemeMode.light);
      expect(notifier.isDark, isFalse);
    });

    test('toggle twice returns to dark mode', () {
      final notifier = ThemeNotifier();
      notifier.toggle();
      notifier.toggle();
      expect(notifier.mode, ThemeMode.dark);
    });

    test('toggle notifies listeners', () {
      final notifier = ThemeNotifier();
      var called = false;
      notifier.addListener(() => called = true);
      notifier.toggle();
      expect(called, isTrue);
    });
  });
}
