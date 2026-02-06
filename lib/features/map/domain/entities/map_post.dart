class MapPost {
  final String id;
  final double lat;
  final double lon;
  final String postType;
  final String location;
  final String? name;
  final List<String> images;
  final bool isActive;

  MapPost({
    required this.id,
    required this.lat,
    required this.lon,
    required this.postType,
    required this.location,
    required this.images,
    required this.isActive,
    this.name,
  });
}