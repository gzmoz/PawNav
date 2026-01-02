import 'package:cross_file/cross_file.dart';
import '../entities/edit_post_entity.dart';

abstract class EditPostRepository {
  Future<EditPost> getPostById(String postId);
  Future<void> updatePost(EditPost post);
  Future<List<String>> uploadImages(List<XFile> images);
  Future<void> deleteImages(List<String> imageUrls);

}
