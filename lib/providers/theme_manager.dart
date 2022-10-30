import 'package:flutter/material.dart';

class ThemeManager {
  ThemeData lightTheme = ThemeData(
    fontFamily: 'Gotham',
    primaryColor: const Color(0xFF3B378E),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 5.0,
      backgroundColor: Color(0xFF3B378E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
    colorScheme: ThemeData().colorScheme.copyWith(
          secondary: const Color(0xFF3B378E),
          primary: const Color(0xFF3B378E),
        ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFF3B378E).withOpacity(0.1),
      filled: true,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
  );

  ThemeData darkTheme = ThemeData(
    fontFamily: 'Gotham',
  );
}
