import 'package:flutter/material.dart';
import 'models/takt.dart';
import 'models/trening.dart';
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
        home: Scaffold(appBar: AppBar(title: const Text("Metronome")), body: const NavigationPage()),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentTrenning = 0;

  List<Trening> treningList = [
    Trening(name: "Trening 1", taktList: [
      Takt(bmp: 120, metrum: (4, 4), repetitions: 3, transition: Transition.jump),
      Takt(bmp: 120, metrum: (4, 4), repetitions: 8, transition: Transition.jump),
      Takt(bmp: 120, metrum: (4, 4), repetitions: 4, transition: Transition.jump),
      Takt(bmp: 120, metrum: (4, 4), repetitions: 2, transition: Transition.jump),
      Takt(bmp: 120, metrum: (6, 8), repetitions: 2, transition: Transition.jump),
      Takt(bmp: 120, metrum: (4, 4), repetitions: 2, transition: Transition.jump),
      Takt(bmp: 120, metrum: (4, 4), repetitions: 2, transition: Transition.jump),
      Takt(bmp: 140, metrum: (3, 4), repetitions: 3, transition: Transition.jump),
    ])
  ];

  addNewTrening() {
    treningList.add(Trening(name: 'newTrening', taktList: []));
    notifyListeners();
  }

  addNewTakt(Trening trening, Takt takt) {
    trening.taktList.add(takt);
  }

  deleteTakt(Trening trening, Takt takt) {
    trening.taktList.remove(takt);
  }

  deleteTrening(Trening trening) {
    treningList.remove(trening);
    notifyListeners();
  }

  refresh() {
    notifyListeners();
  }
}
