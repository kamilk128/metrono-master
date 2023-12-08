import 'dart:math';

import 'package:flutter/material.dart';
import 'package:metrono_master/custom_timer.dart';
import 'package:metrono_master/screens/rhythm_list_view.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

import '../main.dart';
import '../models/bar.dart';
import '../models/rhythm.dart';

class MetronomeV2 extends StatefulWidget {
  const MetronomeV2({Key? key}) : super(key: key);

  @override
  State<MetronomeV2> createState() => _MetronomeV2State();
}

class _MetronomeV2State extends State<MetronomeV2> {
  Rhythm? currentRhythm;
  Bar? currentBar;
  int currentNote = 0;
  bool pause = true;
  bool tick = false;
  CustomTimer? tickTimer;

  final player = AudioPlayer();

  Future<void> onTick() async {
    await player.setUrl('asset:./assets/sounds/Synth_Square_E_${currentBar!.accents[currentNote] ? 'hi' : 'lo'}.wav');
    player.play();
    tick = true;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 100), () {
      tick = false;
      currentNote = (currentNote + 1) % currentBar!.meter.$1;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    tickTimer = CustomTimer(const Duration(milliseconds: 1000), onTick);
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
      currentRhythm ??= rhythmList[0];
      currentBar ??= currentRhythm!.barList[0];
    }

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();
    final headerStyle = theme.textTheme.titleLarge!.copyWith();
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<Rhythm>(
            value: currentRhythm,
            onChanged: (value) {
              setState(() {
                currentRhythm = value!;
                currentBar = currentRhythm!.barList[0];
                currentNote = 0;
                tickTimer!.changeTempo(currentBar!.tempo, currentBar!.meter.$2);
                pause = true;
              });
            },
            items: appState.rhythmList
                .where((rhythm) => rhythm.barList.isNotEmpty)
                .map((rhythm) => DropdownMenuItem<Rhythm>(
                      value: rhythm,
                      child: Text(rhythm.name, style: style),
                    ))
                .toList(),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text("Aktualne tempo", style: bodyStyle),
                  Row(
                    children: [
                      Icon(Icons.music_note, color: Colors.black, size: style.fontSize),
                      Text('=${currentBar!.tempo}', style: style),
                    ],
                  ),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                spacing: -5,
                children: [
                  Text("Aktualne metrum", style: bodyStyle),
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
                          color: i + j == currentNote && tick ? Colors.teal : Colors.grey,
                          shape: BoxShape.circle,
                        )))
            ]),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(pause ? "Start" : "Stop", style: headerStyle),
                  IconButton(
                    icon: Icon(pause ? Icons.play_arrow : Icons.pause, size: style.fontSize! * 2),
                    onPressed: () {
                      setState(() {
                        pause = !pause;
                        tickTimer!.changeTempo(currentBar!.tempo, currentBar!.meter.$2);
                        pause ? tickTimer!.stopTimer() : tickTimer!.startTimer();
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Restart", style: headerStyle),
                  IconButton(
                    icon: Icon(Icons.restart_alt, size: style.fontSize! * 2),
                    onPressed: () {
                      setState(() {
                        currentNote = 0;
                        tickTimer!.changeTempo(currentBar!.tempo, currentBar!.meter.$2);
                        tickTimer!.startTimer();
                        pause = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
