import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metrono_master/main.dart';
import 'package:metrono_master/models/rhythm.dart';
import 'package:provider/provider.dart';

import '../models/bar.dart';

class EditBarView extends StatefulWidget {
  const EditBarView({
    Key? key,
    required this.rhythm,
    this.bar,
  }) : super(key: key);

  final Rhythm rhythm;
  final Bar? bar;

  @override
  State<EditBarView> createState() => _EditBarViewState();
}

class _EditBarViewState extends State<EditBarView> {
  late Bar barCopy;
  late bool isNew;

  @override
  void initState() {
    super.initState();

    if (widget.bar == null) {
      barCopy = Bar(
          tempo: 100,
          meter: (4, 4),
          repetitions: 1,
          accents: [false, false, false, false],
          transition: Transition.jump);
    } else {
      barCopy = Bar.fromBar(widget.bar!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();
    final headerStyle = theme.textTheme.headlineSmall!.copyWith();

    TextEditingController tempoController =
        TextEditingController(text: barCopy.tempo.toString());
    TextEditingController meterTopController =
        TextEditingController(text: barCopy.meter.$1.toString());
    TextEditingController meterBottomController =
        TextEditingController(text: barCopy.meter.$2.toString());
    TextEditingController repetitionsController =
        TextEditingController(text: barCopy.repetitions.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj takt'),
      ),
      body: Column(
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note,
                color: Colors.black,
                size: style.fontSize! / 2.0,
              ),
              Text("Tempo", style: headerStyle),
              Icon(
                Icons.music_note,
                color: Colors.black,
                size: style.fontSize! / 2.0,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: tempoController,
                  onChanged: (value) {
                    barCopy.setTempo(int.tryParse(value) ?? 100);
                  },
                  onTapOutside: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Wpisz tempo',
                    hintStyle: headerStyle,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: style,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Metrum", style: headerStyle),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: meterTopController,
                  onChanged: (value) {
                    barCopy
                        .setMeter((int.tryParse(value) ?? 4, barCopy.meter.$2));
                  },
                  onTapOutside: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Wpisz górne metrum',
                    hintStyle: headerStyle,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: style,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: meterBottomController,
                  onChanged: (value) {
                    barCopy
                        .setMeter((barCopy.meter.$1, int.tryParse(value) ?? 4));
                  },
                  onTapOutside: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Wpisz dolne metrum',
                    hintStyle: headerStyle,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: style,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Liczba powtórzeń", style: headerStyle),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: repetitionsController,
                  onChanged: (value) {
                    barCopy.setRepetitions(int.tryParse(value) ?? 1);
                  },
                  onTapOutside: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Wpisz liczbę powtórzeń',
                    hintStyle: headerStyle,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: style,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              if (widget.bar == null) {
                widget.rhythm.barList.add(barCopy);
              } else {
                widget.bar!.setFromBar(barCopy);
              }
              appState.refresh();
              Navigator.pop(context);
            },
            child: const Text('Zapisz takt'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
