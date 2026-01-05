import 'package:pawnav/features/post/domain/entities/post.dart';

/*JSON → Entity çevirir*/
class PostModel extends Post {
  PostModel({required super.id,
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
    required super.postType,
    required super.views});

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      userId: map['user_id'],
      species: map['species'] ?? '',
      breed: map['breed'] ?? '',
      color: map['color'] ?? '',
      gender: map['gender'] ?? 'unknown',
      name: map['name'],
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      eventDate: DateTime.parse(map['event_date']),
      images: map['images'] != null
          ? List<String>.from(map['images'])
          : [],
      postType: map['post_type'] ?? '',
      views: map['views'] ?? 0,
    );
  }

}