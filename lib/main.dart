import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'models/rhythm.dart';
import 'models/settings.dart';
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
          themeMode: provider.settings.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(provider.settings.language),
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
  Settings settings = Settings.defaultSettings;
  List<Rhythm> rhythmList = [];
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
    settings.theme = isOn ? ThemeMode.dark : ThemeMode.light;
    saveData();
    notifyListeners();
  }

  setLanguage(String language) {
    settings.language = language;
    saveData();
    notifyListeners();
  }

  loadData() {
    load().then((value) {
      rhythmList = value.$1;
      settings = value.$2;
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

      String rhythmListString = jsonEncode(rhythmList.map((rhythm) => rhythm.toJson()).toList());
      await prefs.setString('rhythmList', rhythmListString);

      String settingsString = jsonEncode(settings.toJson());
      await prefs.setString('settings', settingsString);
    } catch (e) {
      debugPrint(e as String);
    }
  }

  Future<(List<Rhythm>, Settings)> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String rhythmListString = prefs.getString('rhythmList') ?? '';
      List<Rhythm> loadedRhythmList = rhythmListString.isNotEmpty
          ? jsonDecode(rhythmListString).map<Rhythm>((json) => Rhythm.fromJson(json)).toList()
          : <Rhythm>[];

      String settingsString = prefs.getString('settings') ?? '';
      Settings loadedSettings =
          settingsString.isNotEmpty ? Settings.fromJson(jsonDecode(settingsString)) : Settings.defaultSettings;

      return (loadedRhythmList, loadedSettings);
    } catch (e) {
      debugPrint(e as String);
      return (<Rhythm>[], Settings.defaultSettings);
    }
  }
}
