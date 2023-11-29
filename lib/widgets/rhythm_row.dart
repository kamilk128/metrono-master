import 'package:flutter/material.dart';

import '../models/rhythm.dart';

class RhythmRow extends StatelessWidget {
  const RhythmRow({
    Key? key,
    required this.rhythm,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  final Rhythm rhythm;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(fontSize: 32.0);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(rhythm.name, style: style),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            onEditPressed();
          },
          child: Icon(
            Icons.edit,
            color: Colors.black,
            size: style.fontSize,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onDeletePressed();
          },
          child: Icon(
            Icons.delete,
            color: Colors.black,
            size: style.fontSize,
          ),
        ),
      ]),
    );
  }
}
