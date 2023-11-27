import 'takt.dart';

class Trening {
  String name;
  List<Takt> taktList;

  Trening({
    required this.name,
    required this.taktList,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'taktList': taktList.map((takt) => takt.toJson()).toList(),
      };
}
