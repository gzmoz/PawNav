// class HomeSuccessStoryModel {
//   final String title;
//   final String description;
//   final String imageUrl;
//
//   HomeSuccessStoryModel({
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//   });
//
//   factory HomeSuccessStoryModel.fromMap(Map<String, dynamic> map) {
//     final post = map['post'];
//
//     final postType = post['post_type'];
//     final gender = post['gender'];
//
//     final status =
//     postType == 'Adoption' ? 'Adopted' : 'Reunited';
//
//     final pronoun = gender == 'male'
//         ? 'his'
//         : gender == 'female'
//         ? 'her'
//         : 'their';
//
//     return HomeSuccessStoryModel(
//       title: '$status: ${post['name']} & $pronoun family',
//       description: map['story'],
//       imageUrl: (post['images'] as List).isNotEmpty
//           ? post['images'][0]
//           : '',
//     );
//   }
// }

class HomeSuccessStoryModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  HomeSuccessStoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory HomeSuccessStoryModel.fromMap(Map<String, dynamic> map) {
    final post = map['post'];

    final postType = post['post_type'];
    final gender = post['gender'];

    final status =
    postType == 'Adoption' ? 'Adopted' : 'Reunited';

    final pronoun = gender == 'male'
        ? 'his'
        : gender == 'female'
        ? 'her'
        : 'their';

    return HomeSuccessStoryModel(
      id: map['id'], // 👈 success_stories.id
      title: '$status: ${post['name']} & $pronoun family',
      description: map['story'],
      imageUrl: (post['images'] as List).isNotEmpty
          ? post['images'][0]
          : '',
    );
  }
}

