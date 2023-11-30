import 'package:flutter/material.dart';
import 'package:metrono_master/widgets/rhythm_row.dart';
import 'package:provider/provider.dart';

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
    var rhythmList = appState.exampleList;
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
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              appState.addNewRhythm();
            });
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 1, color: Colors.grey),
          ),
          child: Icon(Icons.add, color: Colors.black, size: style.fontSize),
        ),
        ElevatedButton(
          onPressed: () {
            appState.save().then((value) => null);
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 1, color: Colors.grey),
          ),
          child: const Text("save"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              appState.load().then((value) => {appState.exampleList = value});
            });
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 1, color: Colors.grey),
          ),
          child: const Text("load"),
        ),
      ]),
    );
  }
}
