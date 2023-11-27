enum Transition { jump, linearIncrease, linearDecrease }

class Takt {
  int bmp;
  (int, int) metrum;
  int repetitions;
  Transition transition;

  Takt({
    required this.bmp,
    required this.metrum,
    required this.repetitions,
    required this.transition,
  });

  Map<String, dynamic> toJson() => {
        'bmp': bmp,
        'metrum': {'item1': metrum.$1, 'item2': metrum.$2},
        'repetitions': repetitions,
        'transition': transition.toString(), // Convert enum to string
      };
}
