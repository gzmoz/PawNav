class RecentPostModel {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final DateTime createdAt;
  final String postType;

  RecentPostModel({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.createdAt,
    required this.postType,
  });

  factory RecentPostModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'];

    return RecentPostModel(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      location: json['location'] ?? '',
      imageUrl: images is List && images.isNotEmpty
          ? images.first
          : '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      postType: json['post_type'] ?? '',
    );
  }


}
