import 'package:flutter/material.dart';
import 'package:metrono_master/models/takt.dart';

class TaktRow extends StatelessWidget {
  const TaktRow({
    super.key,
    required this.index,
    required this.takt,
    required this.onDeletePressed,
  });

  final int index;
  final Takt takt;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('${index + 1}.', style: style),
        const Spacer(),
        Icon(
          Icons.music_note_rounded,
          color: Colors.black,
          size: style.fontSize,
        ),
        Text('=${takt.bmp}', style: style),
        const Spacer(),
        Text('${takt.metrum.$1}/${takt.metrum.$2}', style: style),
        const Spacer(),
        Text('x${takt.repetitions}', style: style),
        const Spacer(),
        ElevatedButton(
          onPressed: onDeletePressed,
          child: Text('X'),
        ),
      ]),
    );
  }
}
