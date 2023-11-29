import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metrono_master/models/trening.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widgets/takt_row.dart';
import 'edit_takt_view.dart';

class TreningView extends StatefulWidget {
  const TreningView({Key? key, required this.trening}) : super(key: key);
  final Trening trening;

  @override
  State<TreningView> createState() => _TreningViewState();
}

class _TreningViewState extends State<TreningView> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var trening = widget.trening;
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();
    TextEditingController nameController = TextEditingController(text: widget.trening.name);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podgląd treningu'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(children: [
          TextField(
            controller: nameController,
            textAlign: TextAlign.center,
            onChanged: (value) {
              widget.trening.name = value;
            },
            onTapOutside: (value) {
              appState.refresh();
            },
            onSubmitted: (value) {
              appState.refresh();
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Trening Name',
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
            child: ListView.builder(
              itemCount: trening.taktList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    TaktRow(
                      index: index,
                      takt: trening.taktList[index],
                      onEditPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditTaktView(
                                    trening: trening,
                                    takt: trening.taktList[index],
                                  )),
                        );
                      },
                      onDeletePressed: () {
                        setState(() {
                          trening.taktList.removeAt(index);
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
                  MaterialPageRoute(builder: (context) => EditTaktView(trening: widget.trening)),
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
