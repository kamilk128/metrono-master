import 'package:flutter/material.dart';
import 'package:metrono_master/models/bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarRow extends StatelessWidget {
  BarRow({
    super.key,
    required this.index,
    required this.bar,
    required this.previousBar,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final int index;
  final Bar bar;
  final Bar? previousBar;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  static SvgPicture jumpImage = SvgPicture.asset(
    "./assets/icons/jump.svg",
    semanticsLabel: 'jump',
    height: 32,
    width: 32,
  );
  static SvgPicture linearImage = SvgPicture.asset(
    "./assets/icons/linear.svg",
    semanticsLabel: 'linear',
    height: 32,
    width: 32,
  );

  final Widget jumpIncreaseIcon = jumpImage;
  final Widget jumpDecreaseIcon = Transform.flip(flipX: true, child: jumpImage);
  final Widget linearIncreaseIcon = linearImage;
  final Widget linearDecreaseIcon = Transform.flip(flipX: true, child: linearImage);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(fontSize: 32.0);
    final meterStyle = theme.textTheme.headlineSmall!.copyWith(height: 1.0);

    final transitionIcon = (() {
      if (previousBar == null || bar.tempo == previousBar!.tempo) {
        return const SizedBox(height: 32, width: 32);
      }
      switch (bar.transition) {
        case Transition.jump:
          if (bar.tempo > previousBar!.tempo) {
            return jumpIncreaseIcon;
          } else {
            return jumpDecreaseIcon;
          }
        case Transition.linear:
          if (bar.tempo > previousBar!.tempo) {
            return linearIncreaseIcon;
          } else {
            return linearDecreaseIcon;
          }
        default:
          return const Icon(Icons.help);
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
        Wrap(
          direction: Axis.vertical,
          spacing: -5,
          children: [
            Text('>', style: meterStyle),
            Text('${bar.getAccentPosition()}', style: meterStyle),
          ],
        ),
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
                  Text('Edytuj'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 8.0),
                  Text('Usuń'),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
