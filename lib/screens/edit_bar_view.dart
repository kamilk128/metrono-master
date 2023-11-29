import 'package:flutter/material.dart';

import '../models/bar.dart';

class EditBarView extends StatefulWidget {
  const EditBarView({Key? key}) : super(key: key);

  @override
  State<EditBarView> createState() => _EditBarViewState();
}

class _EditBarViewState extends State<EditBarView> {
  Bar bar = Bar(
      tempo: 100,
      meter: (4, 4),
      repetitions: 1,
      accents: [false, false, false, false],
      transition: Transition.jump);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
