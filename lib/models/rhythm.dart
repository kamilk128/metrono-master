import 'bar.dart';

class Rhythm {
  String name;
  List<Bar> barList;

  Rhythm({
    required this.name,
    required this.barList,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'barList': barList.map((bar) => bar.toJson()).toList(),
      };
}
