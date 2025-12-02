//Uygulamadaki bir “post”un temel tanımı
/*Domain’de bu sınıf sadece “Veri + anlam” taşır.
JSON’dan, Supabase’ten, Flutter widget’larından haberi yok.*/
class Post{
  final String id; //post id
  final String userId; //Kimin eklediğini belirliyor
  final String species;
  final String breed;
  final String color;
  final String gender;
  final String? name;
  final String description;
  final String location;
  final DateTime eventDate;
  final List<String> images;
  final String postType;

  Post({
    required this.id,
    required this.userId,
    required this.species,
    required this.breed,
    required this.color,
    required this.gender,
    required this.name,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.images,
    required this.postType,
  });
}