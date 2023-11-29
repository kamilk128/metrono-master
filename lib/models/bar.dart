enum Transition { jump, linear }

class Bar {
  int tempo;
  (int, int) meter;
  int repetitions;
  List<bool> accents;
  Transition transition;

  Bar({
    required this.tempo,
    required this.meter,
    required this.repetitions,
    required this.accents,
    required this.transition,
  });

  Map<String, dynamic> toJson() => {
        'tempo': tempo,
        'meter': {'top': meter.$1, 'bottom': meter.$2},
        'repetitions': repetitions,
        'accents': accents.toString(),
        'transition': transition.toString(),
      };
}
