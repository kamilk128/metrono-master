import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/takt_row.dart';
import 'package:provider/provider.dart';

import 'edit_takt_view.dart';

class TreningViewPage extends StatefulWidget {
  const TreningViewPage({Key? key}) : super(key: key);

  @override
  State<TreningViewPage> createState() => _TreningViewPageState();
}

class _TreningViewPageState extends State<TreningViewPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var trening = appState.treningList[appState.currentTrenning];
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(children: [
        Text(trening.name, style: style),
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
              // Set the background color here
              backgroundColor: Colors.grey, // Replace with your desired color
            ),
            child: const Text('Dodaj kolejny takt'),
          ),
        ),
      ]),
    );
  }
}
