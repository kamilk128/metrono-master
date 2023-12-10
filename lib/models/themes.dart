import 'package:flutter/material.dart';

class Themes {
  //-------------DARK THEME SETTINGS----
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromRGBO(38, 50, 56, 1),
      onPrimary: Colors.white,
      secondary: Colors.purple,
      onSecondary: Colors.white,
      primaryContainer: Color.fromRGBO(38, 50, 56, 1),
      error: Colors.black,
      onError: Colors.white,
      background: Color.fromARGB(255, 30, 36, 38),
      onBackground: Colors.white,
      surface: Color.fromRGBO(38, 50, 56, 1),
      onSurface: Colors.white,
    ),
  );

  //-------------light THEME SETTINGS----
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 158, 174, 183),
      onPrimary: Colors.white,
      secondary: Color.fromRGBO(255, 111, 0, 1),
      onSecondary: Colors.black,
      primaryContainer: Color.fromARGB(255, 158, 174, 183),
      error: Colors.black,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Color.fromARGB(255, 158, 174, 183),
      onSurface: Colors.white,
    ),
  );
}
