class EditPost {
  final String id;
  final String userId;

  final String species;
  final String breed;
  final String color;
  final String gender;

  final String name;
  final String description;
  final String location;
  final DateTime eventDate;

  final List<String> images;
  final String postType;

  EditPost({
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

  /*
  * copyWith, mevcut EditPost nesnesini bozmadan,
sadece istediğin alanları değiştirerek yeni bir EditPost üretir.*/
  /// UI tarafında küçük değişiklikler için yardımcı
  EditPost copyWith({
    String? species,
    String? breed,
    String? color,
    String? gender,
    String? name,
    String? description,
    String? location,
    DateTime? eventDate,
    List<String>? images,
  }) {
    return EditPost(
      id: id,
      userId: userId,
      species: species ?? this.species,
      //“Eğer species gönderildiyse onu kullan,
      // gönderilmediyse mevcut değeri koru”
      breed: breed ?? this.breed,
      color: color ?? this.color,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      eventDate: eventDate ?? this.eventDate,
      images: images ?? this.images,
      postType: postType,
    );
  }
}
