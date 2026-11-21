import 'package:flutter/material.dart';

class AppColors {
  static const yellow = Color.fromRGBO(254, 206, 1, 1);

  static const _lavender = Color.fromRGBO(216, 210, 253, 1);
  static const _lightGrey = Color.fromRGBO(245, 247, 249, 1);
  static const _darkLavender = Color.fromRGBO(58, 54, 89, 1);
  static const _darkGrey = Color.fromRGBO(38, 40, 44, 1);

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // Product cards alternate between two colors.
  static Color card(BuildContext context, int index) {
    if (_isDark(context)) {
      return index.isEven ? _darkLavender : _darkGrey;
    }
    return index.isEven ? _lavender : _lightGrey;
  }

  // Background for panels, unselected chips and the cart total bar.
  static Color panel(BuildContext context) =>
      _isDark(context) ? _darkGrey : _lightGrey;
}

class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Lato',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.yellow,
        primary: AppColors.yellow,
        onPrimary: Colors.black,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: isDark
          ? const Color.fromRGBO(24, 25, 28, 1)
          : Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: const Color.fromRGBO(119, 119, 119, 1),
        hintStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        titleMedium: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        bodySmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
