import 'package:flutter/material.dart';
import 'package:metrono_master/models/trening.dart';
//import 'package:provider/provider.dart';
//import '../main.dart';
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
    //var appState = context.watch<MyAppState>();
    //var trening = appState.treningList[appState.currentTrenning];
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
              setState(() {
                widget.trening.name = value;
              });
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Trening Name',
            ),
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
                      onDeletePressed: () {
                        // Delete the current Takt when the "Next" button is pressed
                        setState(() {
                          trening.taktList.removeAt(index);
                          //var treningListJson = appState.treningList.map((trening) => trening.toJson()).toList();
                          //print(jsonEncode(treningListJson));
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
                  MaterialPageRoute(builder: (context) => const EditTaktView()),
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
