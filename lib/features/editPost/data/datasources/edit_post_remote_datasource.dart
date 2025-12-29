import 'package:pawnav/features/editPost/data/models/edit_post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPostRemoteDataSource {
  final SupabaseClient supabase;

  EditPostRemoteDataSource(this.supabase);

  /// Tek post çek (edit için)
  Future<EditPostModel> getPostById(String postId) async {
    final data = await supabase
        .from('posts')
        .select()
        .eq('id', postId)
        .single();

    return EditPostModel.fromJson(data);
  }

  /// Update
  Future<void> updatePost(EditPostModel post) async {
    await supabase
        .from('posts')
        .update(post.toJson())
        .eq('id', post.id);
  }
}
