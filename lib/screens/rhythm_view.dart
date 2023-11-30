import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metrono_master/models/rhythm.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/bar.dart';
import '../widgets/bar_row.dart';
import 'edit_bar_view.dart';

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
    final style = theme.textTheme.displaySmall!.copyWith();
    TextEditingController nameController = TextEditingController(text: widget.rhythm.name);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podgląd rytmu'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(children: [
          TextField(
            controller: nameController,
            textAlign: TextAlign.center,
            onChanged: (value) {
              widget.rhythm.name = value;
            },
            onTapOutside: (value) {
              appState.refresh();
            },
            onSubmitted: (value) {
              appState.refresh();
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Wpisz nazwę rytmu',
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(12),
            ],
            style: style,
          ),
          const Divider(
            color: Colors.black,
            thickness: 1, // Adjust the thickness as needed
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
                        });
                      },
                    ),
                    const Divider(
                      color: Colors.black,
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
              style: ElevatedButton.styleFrom(
                side: const BorderSide(width: 1, color: Colors.grey),
              ),
              child: const Text('Dodaj kolejny takt'),
            ),
          ),
        ]),
      ),
    );
  }
}
