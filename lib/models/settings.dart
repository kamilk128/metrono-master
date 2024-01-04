import 'package:flutter/material.dart';

class Settings {
  ThemeMode theme;
  String sound;
  String language;
  int delay;

  static final List<String> availableLanguages = ['pl', 'en', 'es'];
  static final Settings defaultSettings =
      Settings(theme: ThemeMode.dark, sound: 'Synth_Square_E', language: 'en', delay: 100);

  Settings({
    required this.theme,
    required this.sound,
    required this.language,
    required this.delay,
  });

  Map<String, dynamic> toJson() => {
        'theme': theme == ThemeMode.dark ? 'dark' : 'light',
        'sound': sound,
        'language': language,
        'delay': delay,
      };

  Settings.fromJson(Map<String, dynamic> json)
      : theme = json['theme'] == 'dark' ? ThemeMode.dark : ThemeMode.light,
        sound = json['sound'],
        language = json['language'],
        delay = json['delay'];
}
