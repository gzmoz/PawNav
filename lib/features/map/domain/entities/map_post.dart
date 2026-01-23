class MapPost {
  final String id;
  final double lat;
  final double lon;
  final String postType;
  final String location;
  final String? name;
  final List<String> images;

  MapPost({
    required this.id,
    required this.lat,
    required this.lon,
    required this.postType,
    required this.location,
    required this.images,
    this.name,
  });
}
