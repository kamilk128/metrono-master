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

  Rhythm.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        barList = (json['barList'] as List<dynamic>).map((barJson) => Bar.fromJson(barJson)).toList();
}
