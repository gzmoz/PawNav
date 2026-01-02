import 'package:image_picker/image_picker.dart';

import '../entities/edit_post_entity.dart';
import '../repositories/edit_post_repository.dart';

class UpdatePost {
  final EditPostRepository repository;

  UpdatePost(this.repository);

  Future<void> call(
      EditPost post, {
        List<XFile> newImages = const [],
        List<String> removedImages = const [],
      }) async {
    // Yeni fotoğrafları upload et
    final uploadedUrls = await repository.uploadImages(newImages);

    //  Silinen fotoğrafları storage + db’den sil
    await repository.deleteImages(removedImages);

    //  Final image list
    final finalImages = [
      ...post.images.where((url) => !removedImages.contains(url)),
      ...uploadedUrls,
    ];

    // EditPost’u final haliyle güncelle
    final updatedPost = post.copyWith(images: finalImages);

    await repository.updatePost(updatedPost);
  }
}

