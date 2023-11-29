enum Transition { jump, linearIncrease, linearDecrease }

class Takt {
  int bmp;
  (int, int) metrum;
  int repetitions;
  Transition transition;

  static (int, int) bmpRange = (30, 220);
  static (int, int) metrumRange = (1, 99);
  static (int, int) repetitionsRange = (1, 99);

  Takt({
    required this.bmp,
    required this.metrum,
    required this.repetitions,
    required this.transition,
  });

  Takt.fromTakt(Takt takt)
      : bmp = takt.bmp,
        metrum = takt.metrum,
        repetitions = takt.repetitions,
        transition = takt.transition;

  setFromTakt(Takt takt) {
    bmp = takt.bmp;
    metrum = takt.metrum;
    repetitions = takt.repetitions;
    transition = takt.transition;
  }

  setBmp(int newBmp) {
    bmp = newBmp.clamp(Takt.bmpRange.$1, Takt.bmpRange.$2);
  }

  setMetrum((int, int) newMetrum) {
    metrum = (
      newMetrum.$1.clamp(Takt.metrumRange.$1, Takt.metrumRange.$2),
      newMetrum.$2.clamp(Takt.metrumRange.$1, Takt.metrumRange.$2)
    );
  }

  setRepetitions(int newRepetitions) {
    repetitions = newRepetitions.clamp(Takt.repetitionsRange.$1, Takt.repetitionsRange.$2);
  }

  Map<String, dynamic> toJson() => {
        'bmp': bmp,
        'metrum': {'item1': metrum.$1, 'item2': metrum.$2},
        'repetitions': repetitions,
        'transition': transition.toString(), // Convert enum to string
      };
}
