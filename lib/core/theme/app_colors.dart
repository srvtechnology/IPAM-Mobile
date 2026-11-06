import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppColors {
  // Institutional Brand Colors
  static const Color emeraldDarker = AppTheme.emeraldDarker; // 0xFF022C22
  static const Color emeraldDeep = AppTheme.emeraldDeep;     // 0xFF044E3D
  static const Color jadeAccent = AppTheme.jadeAccent;       // 0xFF059669
  static const Color jadeSoft = AppTheme.jadeSoft;           // 0xFFE6F4EA
  static const Color goldWarm = AppTheme.goldWarm;           // 0xFFD97706
  static const Color goldLight = AppTheme.goldLight;         // 0xFFFEF3C7
  static const Color charcoal = AppTheme.charcoal;           // 0xFF0F172A

  // Screenshot UI Palette (Dark Mode)
  static const Color darkBackground = Color(0xFF080C15);
  static const Color darkCard = Color(0xFF0F172A);
  static const Color darkCardBorder = Color(0xFF1E293B);
  static const Color darkPillBg = Color(0xFF1E293B);
  static const Color darkTealPillBg = Color(0xFF042F2C);
  static const Color darkTealPillBorder = Color(0xFF065F46);
  static const Color darkTealPillText = Color(0xFF10B981);
  static const Color darkOrangePillBg = Color(0xFF451A03);
  static const Color darkOrangePillText = Color(0xFFF59E0B);
  static const Color goldHighlight = Color(0xFFFBBF24);
  static const Color tealHighlight = Color(0xFF14B8A6);

  // Neutral Colors (Light)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // Neutral Colors (Dark)
  static const Color backgroundDark = Color(0xFF080C15);
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color cardDark = Color(0xFF0F172A);
  static const Color borderDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Semantic Colors
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [emeraldDeep, jadeAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient institutionalGradient = LinearGradient(
    colors: [emeraldDarker, emeraldDeep],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFB45309), goldWarm, Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Theme-aware helpers
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color background(BuildContext context) =>
      isDark(context) ? backgroundDark : backgroundLight;

  static Color surface(BuildContext context) =>
      isDark(context) ? surfaceDark : surfaceLight;

  static Color card(BuildContext context) =>
      isDark(context) ? cardDark : cardLight;

  static Color border(BuildContext context) =>
      isDark(context) ? borderDark : borderLight;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? textPrimaryDark : textPrimaryLight;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? textSecondaryDark : textSecondaryLight;

  static Color textTertiary(BuildContext context) =>
      isDark(context) ? textTertiaryDark : textTertiaryLight;

  static Color pillBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

  static Color pillText(BuildContext context) =>
      isDark(context) ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

  static Color verifiedBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF064E3B) : const Color(0xFFE6F4EA);

  static Color verifiedText(BuildContext context) =>
      isDark(context) ? const Color(0xFF34D399) : const Color(0xFF044E3D);

  static Color tealPillBg(BuildContext context) =>
      isDark(context) ? darkTealPillBg : const Color(0xFFE6F4EA);

  static Color tealPillBorder(BuildContext context) =>
      isDark(context) ? darkTealPillBorder : const Color(0xFFA7F3D0);

  static Color tealPillText(BuildContext context) =>
      isDark(context) ? darkTealPillText : emeraldDeep;

  static Color orangePillBg(BuildContext context) =>
      isDark(context) ? darkOrangePillBg : const Color(0xFFFEF3C7);

  static Color orangePillBorder(BuildContext context) =>
      isDark(context) ? const Color(0xFF78350F) : const Color(0xFFFDE68A);

  static Color orangePillText(BuildContext context) =>
      isDark(context) ? darkOrangePillText : goldWarm;

  static Color cardBorder(BuildContext context) =>
      isDark(context) ? darkCardBorder : borderLight;

  static List<BoxShadow> cardShadow(BuildContext context) => [
        BoxShadow(
          color: isDark(context)
              ? Colors.black.withValues(alpha: 0.25)
              : const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: isDark(context) ? 8 : 10,
          offset: const Offset(0, 3),
        ),
      ];
}
