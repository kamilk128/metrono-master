import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'models/rhythm.dart';
import 'models/themes.dart';
import 'screens/navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      builder: (context, _) {
        final provider = Provider.of<MyAppState>(context);
        return MaterialApp(
          title: 'MetronoMaster',
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          themeMode: provider.themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(provider.activeLanguage),
          home: const SafeArea(
            child: Scaffold(
              body: NavigationPage(),
            ),
          ),
        );
      },
    );
  }
}

class MyAppState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  String activeLanguage = 'pl';
  List<Rhythm> rhythmList = [];
  List<String> languages = ['pl', 'en', 'es'];
  // List<Rhythm> rhythmList = [
  //   Rhythm(name: "Trening 1", barList: [
  //     Bar(tempo: 120, meter: (4, 4), repetitions: 3, accents: Bar.generateAccents(4, 1), transition: Transition.jump),
  //     Bar(tempo: 120, meter: (4, 4), repetitions: 8, accents: Bar.generateAccents(4, 1), transition: Transition.jump),
  //     Bar(tempo: 120, meter: (4, 4), repetitions: 4, accents: Bar.generateAccents(4, 1), transition: Transition.jump),
  //     Bar(tempo: 120, meter: (4, 4), repetitions: 2, accents: Bar.generateAccents(6, 0), transition: Transition.jump),
  //     Bar(tempo: 120, meter: (6, 8), repetitions: 2, accents: Bar.generateAccents(6, 1), transition: Transition.jump),
  //     Bar(tempo: 120, meter: (4, 4), repetitions: 2, accents: Bar.generateAccents(4, 2), transition: Transition.jump),
  //     Bar(tempo: 120, meter: (4, 4), repetitions: 2, accents: Bar.generateAccents(4, 3), transition: Transition.jump),
  //     Bar(tempo: 140, meter: (3, 4), repetitions: 3, accents: Bar.generateAccents(3, 1), transition: Transition.jump),
  //   ])
  // ];

  MyAppState() {
    loadData();
  }

  toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  setLanguage(String language) {
    activeLanguage = language;

    notifyListeners();
  }

  loadData() {
    load().then((value) {
      rhythmList = value;
      notifyListeners();
    });
  }

  saveData() {
    save().then((value) => null);
  }

  addNewRhythm(String rhythmName) {
    rhythmList.add(Rhythm(name: rhythmName, barList: []));
    notifyListeners();
  }

  deleteRhythm(Rhythm rhythm) {
    rhythmList.remove(rhythm);
    notifyListeners();
  }

  refreshAppState() {
    notifyListeners();
  }

  Future<void> save() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String jsonString = jsonEncode(rhythmList.map((rhythm) => rhythm.toJson()).toList());

      await prefs.setString('rhythmList', jsonString);
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<List<Rhythm>> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String jsonString = prefs.getString('rhythmList') ?? '';

      if (jsonString.isNotEmpty) {
        List<dynamic> jsonList = jsonDecode(jsonString);
        List<Rhythm> loadedList = jsonList.map((json) => Rhythm.fromJson(json)).toList();
        return loadedList;
      }
      // ignore: empty_catches
    } catch (e) {}

    return []; // Return an empty list if there's an error or no data is found
  }
}
