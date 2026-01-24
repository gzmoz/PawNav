class MapFilter {
  final String? postType;
  final String? animal;
  final String? breed;

  const MapFilter({
    this.postType,
    this.animal,
    this.breed,
  });

  static const empty = MapFilter();
}
