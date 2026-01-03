import 'package:pawnav/features/badges/domain/entities/badge_entity.dart';

//API’den gelen JSON’u parse eder
//Domain katmanının beklediği BadgeEntity’yi üretir
/*Dış dünyadan gelen düzensiz JSON verisini, uygulamanın kullanacağı BadgeModel nesnesine dönüştür*/
class BadgeModel extends BadgeEntity {
  BadgeModel(
      {required super.id,
      required super.key,
      required super.name,
      required super.description,
      required super.iconUrl});

  factory BadgeModel.fromJson(Map<String,dynamic>json){
    return BadgeModel(
        id: json['id'] as String,
        key: json['key'] as String,
        name: json['name'] as String,
        description: (json['description'] ?? '') as String,
        iconUrl: (json['icon_url'] ?? '') as String,
    );
  }
}
