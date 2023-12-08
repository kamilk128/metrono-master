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

  @override
  void initState() {
    super.initState();

    if (widget.bar == null) {
      barCopy = Bar(
          tempo: 120, meter: (4, 4), repetitions: 1, accents: Bar.generateAccents(4, 1), transition: Transition.jump);
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
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith();

    TextEditingController tempoController = TextEditingController(text: barCopy.tempo.toString());
    TextEditingController meterTopController = TextEditingController(text: barCopy.meter.$1.toString());
    TextEditingController meterBottomController = TextEditingController(text: barCopy.meter.$2.toString());
    TextEditingController accentsController = TextEditingController(text: barCopy.getAccentPosition().toString());
    TextEditingController repetitionsController = TextEditingController(text: barCopy.repetitions.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj takt'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                    TextField(
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
                        contentPadding: const EdgeInsets.all(2),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.tempoRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Text("Metrum", style: headerStyle),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: meterTopController,
                      onChanged: (value) {
                        barCopy.setMeter((int.tryParse(value) ?? 4, barCopy.meter.$2));
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
                        contentPadding: const EdgeInsets.all(2),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.meterTopRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    Container(
                      width: style.fontSize, // Adjust the percentage as needed
                      height: 1.0, // Set the divider thickness
                      color: Colors.black,
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: meterBottomController,
                      onChanged: (value) {
                        barCopy.setMeter((barCopy.meter.$1, int.tryParse(value) ?? 4));
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
                        contentPadding: const EdgeInsets.all(2),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.meterBottomRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Text("Liczba powtórzeń", style: headerStyle),
                    TextField(
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
                        contentPadding: const EdgeInsets.all(2),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.repetitionsRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Text("Pozycja akcentu", style: headerStyle),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: accentsController,
                      onChanged: (value) {
                        barCopy.setAccents(Bar.generateAccents(barCopy.meter.$1, int.tryParse(value) ?? 0));
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
                        hintText: 'Wpisz pozycję akcentu',
                        hintStyle: headerStyle,
                        contentPadding: const EdgeInsets.all(2),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.accentsRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Text("Przejście", style: headerStyle),
                    DropdownButton<Transition>(
                      value: barCopy.transition,
                      onChanged: (value) {
                        setState(() {
                          barCopy.setTransition(value!);
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: Transition.jump,
                          child: Text('Skokowe', style: bodyStyle),
                        ),
                        DropdownMenuItem(
                          value: Transition.linear,
                          child: Text('Liniowe', style: bodyStyle),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  barCopy.setAccents(Bar.generateAccents(barCopy.meter.$1, barCopy.getAccentPosition()));
                  if (widget.bar == null) {
                    widget.rhythm.barList.add(barCopy);
                  } else {
                    widget.bar!.setFromBar(barCopy);
                  }
                  appState.refreshAppState();
                  appState.saveData();
                  Navigator.pop(context);
                },
                child: const Text('Zapisz takt'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
