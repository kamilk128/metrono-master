import 'package:flutter/material.dart';
import 'package:metrono_master/models/bar.dart';

class BarRow extends StatelessWidget {
  const BarRow({
    super.key,
    required this.index,
    required this.bar,
    required this.onDeletePressed,
  });

  final int index;
  final Bar bar;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();
    final meterStyle = theme.textTheme.headlineSmall!.copyWith(height: 1.0);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('${index + 1}.', style: style),
        const Spacer(),
        Icon(Icons.music_note, color: Colors.black, size: style.fontSize),
        Text('=${bar.tempo}', style: style),
        const Spacer(),
        Column(
          children: [
            Text('${bar.meter.$1}', style: meterStyle),
            Text('${bar.meter.$2}', style: meterStyle),
          ],
        ),
        const Spacer(),
        Text('x${bar.repetitions}', style: style),
        const Spacer(),
        ElevatedButton(
          onPressed: onDeletePressed,
          child: Icon(Icons.delete, color: Colors.black, size: style.fontSize),
        ),
      ]),
    );
  }
}
