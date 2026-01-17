enum PostType {
  lost,
  found,
  adopted,
}
PostType parsePostType(String value) {
  switch (value.toLowerCase()) {
    case 'lost':
      return PostType.lost;
    case 'found':
      return PostType.found;
    case 'adopted':
    case 'adoption':
      return PostType.adopted;
    default:
      throw Exception('Unknown post type: $value');
  }
}



