class Post {
  final String id;
  final String userId;

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

  final int views;

  Post(
      {required this.id,
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
      required this.views});
}
