import 'package:pawnav/features/success_story/domain/repositories/post_type_enum.dart';

class SuccessStoryListItemModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final PostType postType;
  final DateTime createdAt;

  SuccessStoryListItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.postType,
    required this.createdAt,
  });

  //string → enum çevirici
  static PostType _mapPostType(String? raw) {
    // posts.post_type değerlerin: Lost / Found / Adoption
    switch ((raw ?? '').toLowerCase()) {
      case 'adoption':
        return PostType.adopted;
      case 'found':
        return PostType.found;
      case 'lost':
      default:
        return PostType.lost;
    }
  }

  static String _buildTitle({
    required String? postTypeRaw,
    required String? petName,
    required String? genderRaw,
  }) {
    final status =
    (postTypeRaw ?? '').toLowerCase() == 'adoption' ? 'Adopted' : 'Reunited';


    final g = (genderRaw ?? '').toLowerCase();
    final pronoun = g == 'male'
        ? 'his'
        : g == 'female'
        ? 'her'
        : 'their';

    final name = (petName == null || petName.trim().isEmpty) ? 'Unknown' : petName.trim();

    //Final title
    return '$status: $name & $pronoun family';
  }

  factory SuccessStoryListItemModel.fromMap(Map<String, dynamic> map) {
    final post = (map['post'] as Map<String, dynamic>?);

    final postTypeRaw = post?['post_type'] as String?;
    final petName = post?['name'] as String?;
    final genderRaw = post?['gender'] as String?;

    final images = post?['images'];
    String imageUrl = '';
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is String) imageUrl = first;
    } else if (images is String && images.isNotEmpty) {
      imageUrl = images;
    }

    return SuccessStoryListItemModel(
      id: map['id'] as String,
      title: _buildTitle(
        postTypeRaw: postTypeRaw,
        petName: petName,
        genderRaw: genderRaw,
      ),
      description: (map['story'] as String?) ?? '',
      imageUrl: imageUrl,
      postType: _mapPostType(postTypeRaw),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
