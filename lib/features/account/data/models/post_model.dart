class PostModel{
  final String id;
  final String userId;

  final String? species;
  final String? breed;
  final String? color;
  final String? gender;
  final String? name;
  final String? description;
  final String? location;

  final DateTime? eventDate;
  final List<String>? images;
  final DateTime createdAt;
  final String? postType;

  PostModel({
    required this.id,
    required this.userId,
    this.species,
    this.breed,
    this.color,
    this.gender,
    this.name,
    this.description,
    this.location,
    this.eventDate,
    this.images,
    required this.createdAt,
    this.postType
  });

  /*factory, özel bir constructor türüdür.
  * amac: Var olan verilerden (Map, JSON gibi) nesne üretmek
  * */

  //Backend’den gelen Map (JSON) verisini alır
  //Onu PostModel nesnesine çevirir

  //map, tek bir gönderinin (postun) ham verisidir.
  factory PostModel.fromMap(Map<String, dynamic> map){
    return PostModel(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      species: map['species']?.toString(),
      breed: map['breed']?.toString(),
      color: map['color']?.toString(),
      gender: map['gender']?.toString(),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      location: map['location']?.toString(),
      eventDate: map['event_date'] == null
          ? null
          : DateTime.parse(map['event_date'].toString()),
      images: map['images'] == null
          ? null
          : List<String>.from(map['images']),
      postType: map['post_type']?.toString(),
      createdAt: DateTime.parse(map['created_at'].toString()),
    );
    
  }
}