import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HortaTheme {
  static const Color primaryEmerald = Color(0xFF10B981);
  static const Color darkBackground = Color(0xFF020402);
  static const Color textSecondary = Color(0xFF64748B);

  // Light palette
  static const Color nurseryBackground = Color(0xFFEEF3F1);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2EAE6);
  static const Color textOnLight = Color(0xFF0A0F0D);

  // Dark palette
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF0D1510);
  static const Color darkBorder = Color(0x1AFFFFFF);

  // ── Context-aware helpers ────────────────────────────────────────────────

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Primary text color on the page/scaffold background.
  static Color pageText(BuildContext context) =>
      isDark(context) ? textPrimary : textOnLight;

  /// Background for nav pills, filter bars, and similar containers.
  static Color containerBg(BuildContext context) =>
      isDark(context) ? darkSurface : cardBackground;

  /// Border for nav pills, filter bars, and similar containers.
  static Color containerBorder(BuildContext context) =>
      isDark(context) ? darkBorder : cardBorder;

  /// Background for dark-styled content cards (bento, detail panels).
  static Color darkCardBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF0A0A14) : cardBackground;

  /// Border for dark-styled content cards.
  static Color darkCardBorder(BuildContext context) =>
      isDark(context) ? Colors.white.withValues(alpha: 0.05) : cardBorder;

  // ── Themes ───────────────────────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: nurseryBackground,
      primaryColor: primaryEmerald,
      colorScheme: ColorScheme.light(
        primary: primaryEmerald,
        onPrimary: Colors.white,
        surface: cardBackground,
        onSurface: textOnLight,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          color: textOnLight,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.5,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(color: textOnLight, fontSize: 16),
        bodyMedium: GoogleFonts.spaceGrotesk(color: textSecondary, fontSize: 14),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryEmerald,
      colorScheme: ColorScheme.dark(
        primary: primaryEmerald,
        onPrimary: Colors.white,
        surface: darkSurface,
        onSurface: textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          color: textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.5,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 16),
        bodyMedium: GoogleFonts.spaceGrotesk(color: textSecondary, fontSize: 14),
      ),
    );
  }
}
