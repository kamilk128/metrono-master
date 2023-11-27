import 'package:flutter/material.dart';

import '../models/takt.dart';

class EditTaktView extends StatefulWidget {
  const EditTaktView({Key? key}) : super(key: key);

  @override
  _EditTaktViewState createState() => _EditTaktViewState();
}

class _EditTaktViewState extends State<EditTaktView> {
  Takt takt = Takt(bmp: 100, metrum: (4, 4), repetitions: 1, transition: Transition.jump);

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
