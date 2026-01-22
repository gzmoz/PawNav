class PostFilter {
  final String? postType;
  final String? location;
  final double? radiusKm;
  final String? animal;
  final String? breed;
  final double? lat;
  final double? lon;

  const PostFilter({
    this.postType,
    this.location,
    this.radiusKm,
    this.animal,
    this.breed,
    this.lat,
    this.lon,
  });

  static const empty = PostFilter();
}
