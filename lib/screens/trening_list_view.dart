import 'package:flutter/material.dart';
import 'package:metrono_master/widgets/trening_row.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'trening_view.dart';

class TreningListView extends StatefulWidget {
  const TreningListView({Key? key}) : super(key: key);

  @override
  State<TreningListView> createState() => _TreningListViewState();
}

class _TreningListViewState extends State<TreningListView> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var treningList = appState.treningList;
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: treningList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  TreningRow(
                    trening: treningList[index],
                    onEditPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TreningView(
                                  trening: treningList[index],
                                )),
                      );
                    },
                    onDeletePressed: () {
                      setState(() {
                        appState.deleteTrening(treningList[index]);
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
              appState.addNewTrening();
            });
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 1, color: Colors.grey),
          ),
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: style.fontSize,
          ),
        ),
      ]),
    );
  }
}
