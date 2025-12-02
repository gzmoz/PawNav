import 'package:pawnav/features/addPost/domain/entities/add_post_entity.dart';

//PostModel, Domain’deki Post nesnesini Supabase’in anlayacağı forma çeviren adapter
class PostModel extends Post{
  PostModel({
    required super.id,
    required super.userId,
    required super.species,
    required super.breed,
    required super.color,
    required super.gender,
    required super.name,
    required super.description,
    required super.location,
    required super.eventDate,
    required super.images,
    required super.postType
  });

  //bir nesneyi JSON formatına dönüştürmek için kullanılır.
  //dynamic -> Herhangi bir tür olabilir. Type check derleme zamanında değil, çalışma zamanında yapılır.
  Map<String, dynamic> toJson(){ //Bu metot, Supabase’e insert atarken kullanacağın Map (JSON) veriyi hazırlar.
    return{
      "user_id": userId,
      "species": species,
      "breed": breed,
      "color": color,
      "gender": gender,
      "name": name,
      "description": description,
      "location": location,
      "event_date": eventDate.toIso8601String(), //ISO string, tarih–saat bilgisinin dünyada standart kabul edilen tek bir metin (String) formatında yazılmasıdır.
      "images": images,
      "post_type": postType,
    };
  }
}