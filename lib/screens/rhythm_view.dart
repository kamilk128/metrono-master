import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/bar.dart';
import '../models/rhythm.dart';
import '../screens/edit_bar_view.dart';
import '../widgets/bar_row.dart';

class RhythmView extends StatefulWidget {
  const RhythmView({Key? key, required this.rhythm}) : super(key: key);
  final Rhythm rhythm;

  @override
  State<RhythmView> createState() => _RhythmViewState();
}

class _RhythmViewState extends State<RhythmView> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var rhythm = widget.rhythm;
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(color: theme.colorScheme.onBackground);
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith();
    String copiedRhythmName = String.fromCharCodes(widget.rhythm.name.runes);
    TextEditingController nameController = TextEditingController(text: copiedRhythmName);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rhythmPreview),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(children: [
          TextField(
            controller: nameController,
            textAlign: TextAlign.center,
            onChanged: (value) {
              copiedRhythmName = value;
            },
            onTapOutside: (value) {
              appState.refreshAppState();
            },
            onSubmitted: (value) {
              widget.rhythm.name = copiedRhythmName;
              appState.refreshAppState();
              appState.saveData();
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!.inputRhythmName,
            ),
            style: style,
          ),
          Divider(
            color: theme.primaryColor,
            thickness: 1,
          ),
          Expanded(
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Bar bar = rhythm.barList.removeAt(oldIndex);
                  rhythm.barList.insert(newIndex, bar);
                  appState.saveData();
                });
              },
              itemCount: rhythm.barList.length,
              itemBuilder: (context, index) {
                return Column(
                  key: ValueKey(index),
                  children: [
                    BarRow(
                      index: index,
                      bar: rhythm.barList[index],
                      previousBar: index > 0 ? rhythm.barList[index - 1] : rhythm.barList.last,
                      onClonePressed: () {
                        setState(() {
                          rhythm.barList.add(Bar.fromBar(rhythm.barList[index]));
                          appState.saveData();
                        });
                      },
                      onEditPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBarView(
                              rhythm: rhythm,
                              bar: rhythm.barList[index],
                            ),
                          ),
                        );
                      },
                      onDeletePressed: () {
                        setState(() {
                          rhythm.barList.removeAt(index);
                          appState.saveData();
                        });
                      },
                    ),
                    Divider(
                      color: theme.primaryColor,
                      thickness: 1,
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditBarView(rhythm: widget.rhythm)),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.addAnotherBar,
                style: bodyStyle,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
