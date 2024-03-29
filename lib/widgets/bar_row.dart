import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/bar.dart';

class BarRow extends StatelessWidget {
  BarRow({
    super.key,
    required this.index,
    required this.bar,
    required this.previousBar,
    required this.onClonePressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final int index;
  final Bar bar;
  final Bar? previousBar;
  final VoidCallback onClonePressed;
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
  static SvgPicture correctedImage = SvgPicture.asset(
    "./assets/icons/corrected.svg",
    semanticsLabel: 'corrected',
    height: 32,
    width: 32,
  );

  final Widget jumpIncreaseIcon = jumpImage;
  final Widget jumpDecreaseIcon = Transform.flip(flipX: true, child: jumpImage);
  final Widget linearIncreaseIcon = linearImage;
  final Widget linearDecreaseIcon = Transform.flip(flipX: true, child: linearImage);
  final Widget correctedIncreaseIcon = correctedImage;
  final Widget correctedDecreaseIcon = Transform.flip(flipX: true, child: correctedImage);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(fontSize: 32.0, color: theme.colorScheme.onBackground);
    final meterStyle = theme.textTheme.headlineSmall!.copyWith(height: 1.0, color: theme.colorScheme.onBackground);

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
        case Transition.corrected:
          if (bar.tempo > previousBar!.tempo) {
            return correctedIncreaseIcon;
          } else {
            return correctedDecreaseIcon;
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
        SvgPicture.asset(
          "./assets/icons/music-note-quarter.svg",
          semanticsLabel: 'music-note-quarter',
          height: style.fontSize,
          width: style.fontSize,
          colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
        ),
        Text('= ${bar.tempo}'.padRight(5), style: style),
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
            Text(bar.getAccentPosition() > 9 ? ' >' : '>', style: meterStyle),
            Text('${bar.getAccentPosition()}', style: meterStyle),
          ],
        ),
        const Spacer(),
        transitionIcon,
        const Spacer(),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'clone':
                onClonePressed();
                break;
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
            PopupMenuItem<String>(
              value: 'clone',
              child: Row(
                children: [
                  Icon(
                    Icons.copy,
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8.0),
                  Text(AppLocalizations.of(context)!.clone),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8.0),
                  Text(AppLocalizations.of(context)!.edit),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8.0),
                  Text(AppLocalizations.of(context)!.delete),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
