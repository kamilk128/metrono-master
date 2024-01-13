import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/rhythm.dart';
import '../screens/rhythm_view.dart';
import '../widgets/rhythm_row.dart';

class RhythmListView extends StatefulWidget {
  const RhythmListView({Key? key}) : super(key: key);

  @override
  State<RhythmListView> createState() => _RhythmListViewState();
}

class _RhythmListViewState extends State<RhythmListView> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var rhythmList = appState.rhythmList;

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(children: [
        Expanded(
          child: ReorderableListView.builder(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Rhythm rhythm = rhythmList.removeAt(oldIndex);
                rhythmList.insert(newIndex, rhythm);
                appState.saveData();
              });
            },
            itemCount: rhythmList.length,
            itemBuilder: (context, index) {
              return Column(
                key: ValueKey(index),
                children: [
                  RhythmRow(
                    rhythm: rhythmList[index],
                    onClonePressed: () {
                      setState(() {
                        rhythmList.add(Rhythm.fromRhythm(rhythmList[index]));
                        appState.saveData();
                      });
                    },
                    onEditPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RhythmView(
                                  rhythm: rhythmList[index],
                                )),
                      );
                    },
                    onDeletePressed: () {
                      setState(() {
                        appState.deleteRhythm(rhythmList[index]);
                        appState.saveData();
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  appState.addNewRhythm(AppLocalizations.of(context)!.newRhythm);
                });
              },
              child: Icon(Icons.add, color: style.color, size: style.fontSize),
            ),
          ),
        ),
      ]),
    );
  }
}
