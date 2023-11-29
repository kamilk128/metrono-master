import 'package:flutter/material.dart';
import 'models/bar.dart';
import 'models/rhythm.dart';
import 'screens/navigation.dart';
import 'package:provider/provider.dart';

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
        home: Scaffold(
            appBar: AppBar(title: const Text("MetronoMaster")),
            body: const NavigationPage()),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentTraining = 0;

  List<Rhythm> exampleList = [
    Rhythm(name: "Trening 1", barList: [
      Bar(
          tempo: 120,
          meter: (4, 4),
          repetitions: 3,
          accents: [true, false, false, false],
          transition: Transition.jump),
      Bar(
          tempo: 120,
          meter: (4, 4),
          repetitions: 8,
          accents: [true, false, false, false],
          transition: Transition.jump),
      Bar(
          tempo: 120,
          meter: (4, 4),
          repetitions: 4,
          accents: [true, false, false, false],
          transition: Transition.jump),
      Bar(
          tempo: 120,
          meter: (4, 4),
          repetitions: 2,
          accents: [true, false, false, false],
          transition: Transition.jump),
      Bar(
          tempo: 120,
          meter: (6, 8),
          repetitions: 2,
          accents: [true, false, false, false, false, false],
          transition: Transition.jump),
      Bar(
          tempo: 120,
          meter: (4, 4),
          repetitions: 2,
          accents: [true, false, false, false],
          transition: Transition.jump),
      Bar(
          tempo: 120,
          meter: (4, 4),
          repetitions: 2,
          accents: [true, false, false, false],
          transition: Transition.jump),
      Bar(
          tempo: 140,
          meter: (3, 4),
          repetitions: 3,
          accents: [true, false, false],
          transition: Transition.jump),
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

  refresh() {
    notifyListeners();
  }
}
