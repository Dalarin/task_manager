import 'package:flutter/material.dart';

class ThemeManager {
  ThemeData lightTheme = ThemeData(
    fontFamily: 'Gotham',
    primaryColor: const Color(0xFF3B378E),
    primaryColorLight: const Color(0xFF6D61BF),
    primaryColorDark: const Color(0xFF001160),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF3B378E),
      behavior: SnackBarBehavior.floating,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(
        const Color(0xFF3B378E),
      ),
    ),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color(0xFF3B378E),
          secondary: const Color(0xFF3B378E),
        ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Gotham',
  );
}
