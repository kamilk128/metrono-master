import 'package:flutter/material.dart';

import '../models/rhythm.dart';
import '../utils/scale_helper.dart';

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
    final style = theme.textTheme.displaySmall!.copyWith(fontSize: 32.0, color: theme.colorScheme.onBackground);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          rhythm.name,
          style: style,
          textScaler: ScaleHelper.getScaler(rhythm.name, style, 180),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            onEditPressed();
          },
          child: Icon(Icons.edit, color: theme.colorScheme.onSurface, size: style.fontSize),
        ),
        ElevatedButton(
          onPressed: () {
            onDeletePressed();
          },
          child: Icon(Icons.delete, color: theme.colorScheme.onSurface, size: style.fontSize),
        ),
      ]),
    );
  }
}
