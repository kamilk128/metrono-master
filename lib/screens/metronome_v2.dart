import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/bar.dart';
import '../models/rhythm.dart';
import '../models/settings.dart';
import '../screens/rhythm_list_view.dart';
import '../utils/custom_timer.dart';
import '../utils/scale_helper.dart';

class MetronomeV2 extends StatefulWidget {
  const MetronomeV2({Key? key}) : super(key: key);

  @override
  State<MetronomeV2> createState() => _MetronomeV2State();
}

class _MetronomeV2State extends State<MetronomeV2> {
  Rhythm? currentRhythm;
  Bar? currentBar;
  int currentNote = -1;
  int currentRepetition = 1;
  double currentTempo = -1;
  double previousBarTempo = -1;
  int barIndex = 0;
  bool pause = true;
  bool tick = false;
  CustomTimer? tickTimer;
  Settings? settings;

  Stopwatch stopwatch = Stopwatch()..start();
  Duration lastTick = const Duration();

  final player = AudioPlayer();

  Future<void> onTick() async {
    if (currentNote + 1 == currentBar!.meter.$1) {
      currentNote = 0;
      if (currentRepetition != currentBar!.repetitions) {
        currentRepetition++;
      } else {
        currentRepetition = 1;
        if (barIndex + 1 == currentRhythm!.barList.length) {
          barIndex = 0;
        } else {
          barIndex++;
        }
        currentBar = currentRhythm!.barList[barIndex];
        if (currentBar!.transition == Transition.jump) {
          currentTempo = currentBar!.tempo.toDouble();
          tickTimer!.changeTempo(currentTempo.round(), currentBar!.meter.$2, restart: true);
        } else if (currentBar!.transition == Transition.linear) {
          previousBarTempo = currentTempo;
        } else if (currentBar!.transition == Transition.corrected) {
          previousBarTempo = currentTempo;
        }
      }
    } else {
      currentNote++;
    }
    double tempoFactor = (currentBar!.tempo - previousBarTempo) / (currentBar!.repetitions * currentBar!.meter.$1);
    if (currentBar!.transition == Transition.linear) {
      currentTempo += tempoFactor;
      tickTimer!.changeTempo(currentTempo.round(), currentBar!.meter.$2, restart: true);
    } else if (currentBar!.transition == Transition.corrected) {
      currentTempo +=
          tempoFactor * ((currentBar!.tempo + previousBarTempo + tempoFactor) / 2) / (currentTempo + tempoFactor);
      tickTimer!.changeTempo(currentTempo.round(), currentBar!.meter.$2, restart: true);
    }

    debugPrint('onTick: ${stopwatch.elapsed - lastTick}');
    lastTick = stopwatch.elapsed;
    await player
        .setUrl('asset:./assets/sounds/${settings!.sound}_${currentBar!.accents[currentNote] ? 'hi' : 'lo'}.wav');
    player.play();
    Future.delayed(Duration(milliseconds: settings!.delay), () {
      tick = true;
      setState(() {});
      Future.delayed(const Duration(milliseconds: 100), () {
        tick = false;
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    tickTimer = CustomTimer(const Duration(milliseconds: 1000), onTick);
    final provider = Provider.of<MyAppState>(context, listen: false);
    settings = provider.settings;
  }

  @override
  void dispose() {
    tickTimer?.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var rhythmList = appState.rhythmList.where((rhythm) => rhythm.barList.isNotEmpty).toList();
    if (rhythmList.isEmpty) {
      return const RhythmListView();
    } else {
      currentRhythm ??= rhythmList.contains(appState.lastRhythm) ? appState.lastRhythm : rhythmList[0];
      currentBar ??= currentRhythm!.barList[barIndex];
      appState.lastRhythm = currentRhythm;
      if (previousBarTempo == -1 || currentTempo == -1) {
        previousBarTempo = currentRhythm!.barList.last.tempo.toDouble();
        if (currentBar!.transition == Transition.jump) {
          currentTempo = currentBar!.tempo.toDouble();
        } else if (currentBar!.transition == Transition.linear) {
          currentTempo = previousBarTempo;
        } else if (currentBar!.transition == Transition.corrected) {
          currentTempo = previousBarTempo;
        }
      }
    }

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(color: theme.colorScheme.onBackground);
    final headerStyle = theme.textTheme.titleLarge!.copyWith(color: theme.colorScheme.onBackground);
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onBackground);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.primaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              color: theme.primaryColor,
            ),
            child: DropdownButton<Rhythm>(
              isExpanded: true,
              value: currentRhythm,
              alignment: AlignmentDirectional.center,
              onChanged: (value) {
                setState(() {
                  appState.lastRhythm = value!;
                  currentRhythm = value;
                  barIndex = 0;
                  currentBar = currentRhythm!.barList[barIndex];
                  currentNote = -1;
                  currentRepetition = 1;
                  previousBarTempo = currentRhythm!.barList.last.tempo.toDouble();
                  if (currentBar!.transition == Transition.jump) {
                    currentTempo = currentBar!.tempo.toDouble();
                  } else if (currentBar!.transition == Transition.linear) {
                    currentTempo = previousBarTempo;
                  } else if (currentBar!.transition == Transition.corrected) {
                    currentTempo = previousBarTempo;
                  }
                  tickTimer!.changeTempo(currentTempo.round(), currentBar!.meter.$2);
                  pause = true;
                });
              },
              items: appState.rhythmList
                  .where((rhythm) => rhythm.barList.isNotEmpty)
                  .map((rhythm) => DropdownMenuItem<Rhythm>(
                        value: rhythm,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          rhythm.name,
                          style: style,
                          textScaler: ScaleHelper.getScaler(rhythm.name, style, 240),
                        ),
                      ))
                  .toList(),
              underline: Container(),
              iconSize: 48,
              dropdownColor: theme.primaryColor,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(AppLocalizations.of(context)!.tempo, style: bodyStyle),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "./assets/icons/music-note-quarter.svg",
                        semanticsLabel: 'music-note-quarter',
                        height: style.fontSize,
                        width: style.fontSize,
                        colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
                      ),
                      Text('= ${currentTempo.round()}', style: style),
                    ],
                  ),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                spacing: -5,
                children: [
                  Text(AppLocalizations.of(context)!.meter, style: bodyStyle),
                  Text('${currentBar!.meter.$1}', style: headerStyle),
                  Text('${currentBar!.meter.$2}', style: headerStyle),
                ],
              ),
            ],
          ),
          const Spacer(),
          for (int j = 0; j < currentBar!.meter.$1; j += min(currentBar!.meter.$2, 8))
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (int i = 0; i < min(currentBar!.meter.$2, 8) && i + j < currentBar!.meter.$1; i++)
                Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                        width: currentBar!.accents[i + j] ? 45.0 : 30.0,
                        height: currentBar!.accents[i + j] ? 45.0 : 30.0,
                        decoration: BoxDecoration(
                          color: i + j == currentNote && tick
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.onSecondary,
                          shape: BoxShape.circle,
                        )))
            ]),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(pause ? AppLocalizations.of(context)!.start : AppLocalizations.of(context)!.stop,
                      style: headerStyle),
                  IconButton(
                    icon: Icon(pause ? Icons.play_arrow : Icons.pause, size: style.fontSize! * 2),
                    color: theme.colorScheme.onBackground,
                    onPressed: () {
                      setState(() {
                        pause = !pause;
                        tickTimer!.changeTempo(currentTempo.round(), currentBar!.meter.$2);
                        pause ? tickTimer!.stopTimer() : tickTimer!.startTimer();
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text(AppLocalizations.of(context)!.restart, style: headerStyle),
                  IconButton(
                    icon: Icon(
                      Icons.restart_alt,
                      size: style.fontSize! * 2,
                      color: theme.colorScheme.onBackground,
                    ),
                    onPressed: () {
                      setState(() {
                        barIndex = 0;
                        currentBar = currentRhythm!.barList[barIndex];
                        currentNote = -1;
                        currentRepetition = 1;
                        previousBarTempo = currentRhythm!.barList.last.tempo.toDouble();
                        if (currentBar!.transition == Transition.jump) {
                          currentTempo = currentBar!.tempo.toDouble();
                        } else if (currentBar!.transition == Transition.linear) {
                          currentTempo = previousBarTempo;
                        } else if (currentBar!.transition == Transition.corrected) {
                          currentTempo = previousBarTempo;
                        }
                        tickTimer!.changeTempo(currentTempo.round(), currentBar!.meter.$2);
                        tickTimer!.startTimer();
                        pause = false;
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
