import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metrono_master/custom_timer.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/bar.dart';
import '../models/rhythm.dart';

class MetronomeV2 extends StatefulWidget {
  const MetronomeV2({Key? key}) : super(key: key);

  @override
  State<MetronomeV2> createState() => _MetronomeV2State();
}

class _MetronomeV2State extends State<MetronomeV2> {
  Rhythm? currentRythm;
  Bar? currentBar;
  bool pause = true;
  CustomTimer? tickTimer;

  void onTick() {
    SystemSound.play(SystemSoundType.click);
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
    currentRythm ??= appState.rythmList[0];
    currentBar ??= currentRythm!.barList[0];
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();
    final headerStyle = theme.textTheme.titleLarge!.copyWith();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<Rhythm>(
            value: currentRythm,
            onChanged: (value) {
              setState(() {
                currentRythm = value!;
                currentBar = currentRythm!.barList[0];
                tickTimer!.changeTempo(currentBar!.tempo);
                pause = true;
              });
            },
            items: appState.rythmList
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
            children: [
              Column(
                children: [
                  Text("Aktualne tempo", style: headerStyle),
                  Row(
                    children: [
                      Icon(Icons.music_note, color: Colors.black, size: style.fontSize),
                      Text('=${currentBar!.tempo}', style: style),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Aktualne metrum", style: headerStyle),
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
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        )))
            ]),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(pause ? "Play" : "Stop", style: headerStyle),
                  IconButton(
                    icon: Icon(pause ? Icons.play_arrow : Icons.pause, size: style.fontSize! * 2),
                    onPressed: () {
                      setState(() {
                        pause = !pause;
                        tickTimer!.changeTempo(currentBar!.tempo);
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
