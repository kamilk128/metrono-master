enum Transition { jump, linear }

class Bar {
  int tempo;
  (int, int) meter;
  int repetitions;
  List<bool> accents;
  Transition transition;

  static (int, int) tempoRange = (30, 220);
  static (int, int) meterRange = (1, 64);
  static (int, int) repetitionsRange = (1, 99);
  static (int, int) accentsRange = meterRange;

  Bar({
    required this.tempo,
    required this.meter,
    required this.repetitions,
    required this.accents,
    required this.transition,
  });

  Bar.fromBar(Bar bar)
      : tempo = bar.tempo,
        meter = bar.meter,
        repetitions = bar.repetitions,
        accents = bar.accents,
        transition = bar.transition;

  setFromBar(Bar bar) {
    tempo = bar.tempo;
    meter = bar.meter;
    repetitions = bar.repetitions;
    accents = bar.accents;
    transition = bar.transition;
  }

  setTempo(int newTempo) {
    tempo = newTempo.clamp(Bar.tempoRange.$1, Bar.tempoRange.$2);
  }

  setMeter((int, int) newMeter) {
    meter = (
      newMeter.$1.clamp(Bar.meterRange.$1, Bar.meterRange.$2),
      newMeter.$2.clamp(Bar.meterRange.$1, Bar.meterRange.$2)
    );
  }

  setRepetitions(int newRepetitions) {
    repetitions = newRepetitions.clamp(Bar.repetitionsRange.$1, Bar.repetitionsRange.$2);
  }

  setAccents(List<bool> newAccents) {
    accents = newAccents;
  }

  int getAccentPosition() {
    return accents.indexOf(true) + 1;
  }

  static List<bool> generateAccents(int length, int position) {
    return List<bool>.generate(length, (int index) => index + 1 == position ? true : false, growable: false);
  }

  setTransition(Transition newTransition) {
    transition = newTransition;
  }

  Map<String, dynamic> toJson() => {
        'tempo': tempo,
        'meter': {'top': meter.$1, 'bottom': meter.$2},
        'repetitions': repetitions,
        'accents': accents.toString(),
        'transition': transition.toString(),
      };

  Bar.fromJson(Map<String, dynamic> json)
      : tempo = json['tempo'],
        meter = (json['meter']['top'], json['meter']['bottom']),
        repetitions = json['repetitions'],
        accents = List<bool>.from(
            json['accents'].substring(1, json['accents'].length - 1).split(',').map((e) => e.trim() == 'true')),
        transition = _stringToTransition(json['transition']);

  // Add this helper function to convert a string to the Transition enum
  static Transition _stringToTransition(String transition) {
    switch (transition) {
      case 'Transition.jump':
        return Transition.jump;
      case 'Transition.linear':
        return Transition.linear;
      default:
        throw ArgumentError('Invalid transition string: $transition');
    }
  }
}
