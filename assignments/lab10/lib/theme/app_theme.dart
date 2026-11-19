import 'package:flutter/material.dart';

/// Credit for the design this theme is taken from (shown in the app and NOTES.md).
abstract final class DesignCredit {
  static const name = 'Bloom PlantCare App';
  static const author = 'DS Jayawardhana & Amasha Terani';
  static const link =
      'https://www.figma.com/community/file/1534445735365222713/bloom-plantcare-app';
  static const licence = 'CC BY 4.0';
}

/// Spacing scale read from the Figma file (8 pt grid with a 4 pt half step).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Corner radii used by the design: large cards, buttons, small tiles.
abstract final class AppRadius {
  static const double card = 20;
  static const double button = 16;
  static const double small = 12;
}

/// Colours taken from the Bloom design.
abstract final class _Palette {
  static const forest = Color(0xFF1F5C2E); // primary dark green
  static const leaf = Color(0xFF4E9B4F); // secondary green
  static const mint = Color(0xFFDCEFD8); // light green containers
  static const background = Color(0xFFF3F8F1); // page background
  static const track = Color(0xFFE4EEE2); // bars and dividers
  static const ink = Color(0xFF1C2A1F); // main text
  static const muted = Color(0xFF6B7A6E); // secondary text
  static const amber = Color(0xFFF2A93B); // accent icons
  static const error = Color(0xFFC0392B);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: _Palette.forest).copyWith(
    primary: _Palette.forest,
    onPrimary: Colors.white,
    primaryContainer: _Palette.mint,
    onPrimaryContainer: _Palette.forest,
    secondary: _Palette.leaf,
    onSecondary: Colors.white,
    tertiary: _Palette.amber,
    surface: Colors.white,
    onSurface: _Palette.ink,
    onSurfaceVariant: _Palette.muted,
    surfaceContainerHighest: _Palette.track,
    outlineVariant: _Palette.track,
    error: _Palette.error,
  );

  const textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16, height: 1.4),
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
    bodySmall: TextStyle(fontSize: 12, height: 1.3),
    labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  );

  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.button),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: _Palette.background,
    textTheme: textTheme.apply(
      bodyColor: _Palette.ink,
      displayColor: _Palette.ink,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _Palette.background,
      foregroundColor: _Palette.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: _Palette.ink),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: buttonShape,
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: buttonShape,
        foregroundColor: _Palette.forest,
        side: const BorderSide(color: _Palette.forest),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _Palette.forest,
        textStyle: textTheme.labelLarge,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _Palette.mint,
      labelStyle: textTheme.labelMedium?.copyWith(color: _Palette.forest),
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: _Palette.mint,
      labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? _Palette.forest
              : _Palette.muted,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _Palette.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.small),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.small),
        borderSide: const BorderSide(color: _Palette.forest, width: 1.5),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _Palette.forest,
      linearTrackColor: _Palette.track,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
