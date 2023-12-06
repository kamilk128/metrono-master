import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'models/bar.dart';
import 'models/rhythm.dart';
import 'screens/navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'MetronoMaster',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        home: Scaffold(appBar: AppBar(title: const Text("MetronoMaster")), body: const NavigationPage()),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentTraining = 0;

  List<Rhythm> exampleList = [
    Rhythm(name: "Trening 1", barList: [
      Bar(tempo: 120, meter: (4, 4), repetitions: 3, accents: Bar.generateAccents(4, 1), transition: Transition.jump),
      Bar(tempo: 120, meter: (4, 4), repetitions: 8, accents: Bar.generateAccents(4, 1), transition: Transition.jump),
      Bar(tempo: 120, meter: (4, 4), repetitions: 4, accents: Bar.generateAccents(4, 1), transition: Transition.jump),
      Bar(tempo: 120, meter: (4, 4), repetitions: 2, accents: Bar.generateAccents(6, 0), transition: Transition.jump),
      Bar(tempo: 120, meter: (6, 8), repetitions: 2, accents: Bar.generateAccents(6, 1), transition: Transition.jump),
      Bar(tempo: 120, meter: (4, 4), repetitions: 2, accents: Bar.generateAccents(4, 2), transition: Transition.jump),
      Bar(tempo: 120, meter: (4, 4), repetitions: 2, accents: Bar.generateAccents(4, 3), transition: Transition.jump),
      Bar(tempo: 140, meter: (3, 4), repetitions: 3, accents: Bar.generateAccents(3, 1), transition: Transition.jump),
    ])
  ];

  addNewRhythm() {
    exampleList.add(Rhythm(name: 'Nowy rytm', barList: []));
    notifyListeners();
  }

  deleteRhythm(Rhythm rhythm) {
    exampleList.remove(rhythm);
    notifyListeners();
  }

  Future<void> save() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String jsonString = jsonEncode(exampleList.map((rhythm) => rhythm.toJson()).toList());

      await prefs.setString('rhythmList', jsonString);
    } catch (e) {
      print('Error: $e');
    }
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
    } catch (e) {
      print('Error: $e');
    }

    return []; // Return an empty list if there's an error or no data is found
  }

  refresh() {
    notifyListeners();
  }
}
