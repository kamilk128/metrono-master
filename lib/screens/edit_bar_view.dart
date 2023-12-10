import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metrono_master/main.dart';
import 'package:metrono_master/models/rhythm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final style = theme.textTheme.displaySmall!.copyWith(color: theme.colorScheme.onBackground);
    final headerStyle = theme.textTheme.headlineSmall!.copyWith(color: theme.colorScheme.onBackground);
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onBackground);

    TextEditingController tempoController = TextEditingController(text: barCopy.tempo.toString());
    TextEditingController meterTopController = TextEditingController(text: barCopy.meter.$1.toString());
    TextEditingController meterBottomController = TextEditingController(text: barCopy.meter.$2.toString());
    TextEditingController accentsController = TextEditingController(text: barCopy.getAccentPosition().toString());
    TextEditingController repetitionsController = TextEditingController(text: barCopy.repetitions.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editTact),
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
                          size: style.fontSize! / 2.0,
                        ),
                        Text(AppLocalizations.of(context)!.tempo, style: headerStyle),
                        Icon(
                          Icons.music_note,
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
                        hintText: AppLocalizations.of(context)!.enterTempo,
                        hintStyle: headerStyle,
                        contentPadding: const EdgeInsets.all(2),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.tempoRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    Divider(
                      color: theme.primaryColor,
                      // color: Color.fromARGB(255, 44, 44, 44),
                      thickness: 1,
                    ),
                    Text(AppLocalizations.of(context)!.meter, style: headerStyle),
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
                        hintText: AppLocalizations.of(context)!.enterUpperMetro,
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
                      color: Colors.white,
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
                        hintText: AppLocalizations.of(context)!.enterLowerMetro,
                        hintStyle: headerStyle,
                        contentPadding: const EdgeInsets.all(2),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.meterBottomRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    Divider(
                      color: theme.primaryColor,
                      thickness: 1,
                    ),
                    Text(AppLocalizations.of(context)!.numberOfRepeats, style: headerStyle),
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
                        hintText: AppLocalizations.of(context)!.enterNumberOfRepeats,
                        hintStyle: headerStyle,
                        contentPadding: const EdgeInsets.all(2),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.repetitionsRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    Divider(
                      color: theme.primaryColor,
                      thickness: 1,
                    ),
                    Text(AppLocalizations.of(context)!.accentPosition, style: headerStyle),
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
                        hintText: AppLocalizations.of(context)!.enterAccentPosition,
                        hintStyle: headerStyle,
                        contentPadding: const EdgeInsets.all(2),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.accentsRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    Divider(
                      color: theme.primaryColor,
                      thickness: 1,
                    ),
                    Text(AppLocalizations.of(context)!.transition, style: headerStyle),
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
                          child: Text(AppLocalizations.of(context)!.jumping, style: bodyStyle),
                        ),
                        DropdownMenuItem(
                          value: Transition.linear,
                          child: Text(AppLocalizations.of(context)!.linear, style: bodyStyle),
                        ),
                      ],
                      underline: Container(),
                    ),
                    Divider(
                      color: theme.primaryColor,
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
                child: Text(AppLocalizations.of(context)!.saveTact, style: bodyStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
