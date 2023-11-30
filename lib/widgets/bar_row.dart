import 'package:flutter/material.dart';
import 'package:metrono_master/models/bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarRow extends StatelessWidget {
  BarRow({
    super.key,
    required this.index,
    required this.bar,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final int index;
  final Bar bar;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  final Widget jump = SvgPicture.asset(
    "./assets/icons/jump.svg",
    semanticsLabel: 'jump',
    height: 24,
    width: 24,
  );
  final Widget linear = SvgPicture.asset(
    "./assets/icons/linear.svg",
    semanticsLabel: 'linear',
    height: 24,
    width: 24,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(fontSize: 32.0);
    final meterStyle = theme.textTheme.headlineSmall!.copyWith(height: 1.0);

    final transitionIcon = (() {
      switch (bar.transition) {
        case Transition.jump:
          return jump;
        case Transition.linear:
          return linear;
        default:
          return const Icon(Icons.help); // or any default value
      }
    })();

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
        transitionIcon,
        const Spacer(),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEditPressed();
                break;
              case 'delete':
                onDeletePressed();
                break;
              default:
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8.0),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 8.0),
                  Text('remove'),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
