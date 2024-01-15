import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/bar.dart';
import '../models/rhythm.dart';

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
        title: Text(AppLocalizations.of(context)!.editBar),
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
                          Icons.speed,
                          size: style.fontSize! / 2.0,
                        ),
                        Text(' ${AppLocalizations.of(context)!.tempo} ', style: headerStyle),
                        Icon(
                          Icons.speed,
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
                        contentPadding: const EdgeInsets.all(2.0),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.tempoRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    Divider(
                      color: theme.primaryColor,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_bottom,
                          size: style.fontSize! / 2.0,
                        ),
                        Text(' ${AppLocalizations.of(context)!.meter} ', style: headerStyle),
                        Icon(
                          Icons.hourglass_bottom,
                          size: style.fontSize! / 2.0,
                        ),
                      ],
                    ),
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
                        hintText: AppLocalizations.of(context)!.enterUpperMeter,
                        hintStyle: headerStyle,
                        contentPadding: const EdgeInsets.all(2.0),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Bar.meterTopRange.$2.toString().length),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: style,
                    ),
                    Container(
                      width: style.fontSize,
                      height: 1.0,
                      color: theme.colorScheme.onBackground,
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
                        hintText: AppLocalizations.of(context)!.enterLowerMeter,
                        hintStyle: headerStyle,
                        contentPadding: const EdgeInsets.all(2.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.repeat,
                          size: style.fontSize! / 2.0,
                        ),
                        Text(' ${AppLocalizations.of(context)!.numberOfRepeats} ', style: headerStyle),
                        Icon(
                          Icons.repeat,
                          size: style.fontSize! / 2.0,
                        ),
                      ],
                    ),
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
                        contentPadding: const EdgeInsets.all(2.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.numbers,
                          size: style.fontSize! / 2.0,
                        ),
                        Text(' ${AppLocalizations.of(context)!.accentPosition} ', style: headerStyle),
                        Icon(
                          Icons.numbers,
                          size: style.fontSize! / 2.0,
                        ),
                      ],
                    ),
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
                        contentPadding: const EdgeInsets.all(2.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: style.fontSize! / 2.0,
                        ),
                        Text(' ${AppLocalizations.of(context)!.transition} ', style: headerStyle),
                        Icon(
                          Icons.trending_up,
                          size: style.fontSize! / 2.0,
                        ),
                      ],
                    ),
                    DropdownButton<Transition>(
                      value: barCopy.transition,
                      onChanged: (value) {
                        setState(() {
                          barCopy.setTransition(value!);
                        });
                      },
                      alignment: AlignmentDirectional.center,
                      items: [
                        DropdownMenuItem(
                          value: Transition.jump,
                          alignment: AlignmentDirectional.center,
                          child: Text(AppLocalizations.of(context)!.jump, style: bodyStyle),
                        ),
                        DropdownMenuItem(
                          value: Transition.linear,
                          alignment: AlignmentDirectional.center,
                          child: Text(AppLocalizations.of(context)!.linear, style: bodyStyle),
                        ),
                        DropdownMenuItem(
                          value: Transition.corrected,
                          alignment: AlignmentDirectional.center,
                          child: Text(AppLocalizations.of(context)!.corrected, style: bodyStyle),
                        )
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
                child: Text(AppLocalizations.of(context)!.saveBar, style: bodyStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
