import 'package:flutter/material.dart';

class Themes {
  //-------------DARK THEME SETTINGS----
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromRGBO(38, 50, 56, 1),
      onPrimary: Colors.white,
      secondary: Colors.lime,
      onSecondary: Colors.white,
      primaryContainer: Color.fromRGBO(38, 50, 56, 1),
      error: Colors.black,
      onError: Colors.white,
      background: Color.fromRGBO(30, 36, 38, 1),
      onBackground: Colors.white,
      surface: Color.fromRGBO(38, 50, 56, 1),
      onSurface: Colors.white,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.lime,
      selectionColor: Colors.lime,
      selectionHandleColor: Colors.lime,
    ),
  );

  //-------------light THEME SETTINGS----
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromRGBO(158, 174, 183, 1),
      onPrimary: Colors.white,
      secondary: Colors.purple,
      onSecondary: Colors.black,
      primaryContainer: Color.fromRGBO(158, 174, 183, 1),
      error: Colors.black,
      onError: Colors.white,
      background: Color.fromRGBO(230, 230, 230, 1),
      onBackground: Colors.black,
      surface: Color.fromRGBO(158, 174, 183, 1),
      onSurface: Colors.white,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.purple,
      selectionColor: Colors.purple,
      selectionHandleColor: Colors.purple,
    ),
  );
}
