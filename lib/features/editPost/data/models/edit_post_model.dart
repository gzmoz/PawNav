import '../../domain/entities/edit_post_entity.dart';

class EditPostModel extends EditPost {
  EditPostModel({
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
    required super.postType,
  });

  factory EditPostModel.fromJson(Map<String, dynamic> json) {
    return EditPostModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      species: json['species'] ?? "",
      breed: json['breed'] ?? "",
      color: json['color'] ?? "",
      gender: json['gender'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      location: json['location'] ?? "",
      eventDate: DateTime.parse(json['event_date']),
      images: List<String>.from(json['images'] ?? const []),
      postType: json['post_type'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "species": species,
      "breed": breed,
      "color": color,
      "gender": gender,
      "name": name,
      "description": description,
      "location": location,
      "event_date": eventDate.toIso8601String(),
      "images": images,
      "post_type": postType,
    };
  }

  //uı dan gelen entityi DB’ye uygun modele çevirir
  factory EditPostModel.fromEntity(EditPost post) {
    return EditPostModel(
      id: post.id,
      userId: post.userId,
      species: post.species,
      breed: post.breed,
      color: post.color,
      gender: post.gender,
      name: post.name,
      description: post.description,
      location: post.location,
      eventDate: post.eventDate,
      images: post.images,
      postType: post.postType,
    );
  }
}
