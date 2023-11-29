import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metrono_master/main.dart';
import 'package:metrono_master/models/trening.dart';
import 'package:provider/provider.dart';

import '../models/takt.dart';

class EditTaktView extends StatefulWidget {
  const EditTaktView({
    Key? key,
    required this.trening,
    this.takt,
  }) : super(key: key);

  final Trening trening;
  final Takt? takt;

  @override
  State<EditTaktView> createState() => _EditTaktViewState();
}

class _EditTaktViewState extends State<EditTaktView> {
  late Takt taktCopy;
  late bool isNew;

  @override
  void initState() {
    super.initState();

    if (widget.takt == null) {
      taktCopy = Takt(bmp: 100, metrum: (4, 4), repetitions: 1, transition: Transition.jump);
    } else {
      taktCopy = Takt.fromTakt(widget.takt!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();
    final hstyle = theme.textTheme.displaySmall!.copyWith(fontSize: 20);
    TextEditingController bmpController = TextEditingController(text: taktCopy.bmp.toString());
    TextEditingController metrum1Controller = TextEditingController(text: taktCopy.metrum.$1.toString());
    TextEditingController metrum2Controller = TextEditingController(text: taktCopy.metrum.$2.toString());
    TextEditingController repetitionsController = TextEditingController(text: taktCopy.repetitions.toString());

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
                Icons.music_note_rounded,
                color: Colors.black,
                size: style.fontSize! / 2.0,
              ),
              Text("bmp", style: hstyle),
              Icon(
                Icons.music_note_rounded,
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
                  controller: bmpController,
                  onChanged: (value) {
                    taktCopy.setBmp(int.tryParse(value) ?? 100);
                  },
                  onTapOutside: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'BMP',
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
              Text("metrum", style: hstyle),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: metrum1Controller,
                  onChanged: (value) {
                    taktCopy.setMetrum((int.tryParse(value) ?? 4, taktCopy.metrum.$2));
                  },
                  onTapOutside: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'n',
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: style,
                ),
              ),
              Text("/", style: style),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: metrum2Controller,
                  onChanged: (value) {
                    taktCopy.setMetrum((taktCopy.metrum.$1, int.tryParse(value) ?? 4));
                  },
                  onTapOutside: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'm',
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: style,
                ),
              ),
              const Spacer(),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("repetitions", style: hstyle),
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
                    taktCopy.setRepetitions(int.tryParse(value) ?? 1);
                  },
                  onTapOutside: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'x',
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
              if (widget.takt == null) {
                widget.trening.taktList.add(taktCopy);
              } else {
                widget.takt!.setFromTakt(taktCopy);
              }
              appState.refresh();
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
