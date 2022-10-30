import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:task_manager/page/auth_page.dart';
import 'package:task_manager/providers/theme_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeManager themeManager = ThemeManager();
  runApp(
    MaterialApp(
      theme: themeManager.lightTheme,
      title: 'Список задач',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('ru', 'RU')],
      home: const AuthPage(),
    ),
  );
}
