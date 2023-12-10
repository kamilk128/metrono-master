import 'package:flutter/material.dart';
import 'package:metrono_master/widgets/rhythm_row.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';
import 'rhythm_view.dart';

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
          child: ListView.builder(
            itemCount: rhythmList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  RhythmRow(
                    rhythm: rhythmList[index],
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
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                appState.addNewRhythm(AppLocalizations.of(context)!.newRhythm);
              });
            },
            child: Icon(Icons.add, color: style.color, size: style.fontSize),
          ),
        ),
      ]),
    );
  }
}
