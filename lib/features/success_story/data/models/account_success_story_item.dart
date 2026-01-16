import 'package:pawnav/features/success_story/data/models/success_story_model.dart';

class AccountSuccessStoryItem {
  final SuccessStoryModel story;
  final String petName;
  final String? imageUrl;
  final bool isAdopted;

  AccountSuccessStoryItem({
    required this.story,
    required this.petName,
    required this.imageUrl,
    required this.isAdopted,
  });
}
