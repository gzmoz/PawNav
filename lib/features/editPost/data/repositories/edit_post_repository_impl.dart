import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:pawnav/features/editPost/data/datasources/edit_post_remote_datasource.dart';
import 'package:pawnav/features/editPost/data/models/edit_post_model.dart';
import 'package:pawnav/features/editPost/domain/entities/edit_post_entity.dart';
import 'package:pawnav/features/editPost/domain/repositories/edit_post_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPostRepositoryImpl implements EditPostRepository {
  final EditPostRemoteDataSource remote;
  final SupabaseClient supabase;

  EditPostRepositoryImpl(this.remote, this.supabase);

  @override
  Future<EditPost> getPostById(String postId) async {
    final model = await remote.getPostById(postId);
    return model;
  }

  @override
  Future<void> updatePost(EditPost post) async {
    await supabase
        .from('posts')
        .update({
      'name': post.name,
      'description': post.description,
      'species': post.species,
      'breed': post.breed,
      'color': post.color,
      'gender': post.gender,
      'location': post.location,
      'event_date': post.eventDate.toIso8601String(),
      'images': post.images,
    })
        .eq('id', post.id);
  }

  @override
  Future<void> deleteImages(List<String> imageUrls) async {
    for (final url in imageUrls) {
      final path = _extractPathFromUrl(url);

      await supabase.storage
          .from('post_images')
          .remove([path]);
    }
  }

  @override
  Future<List<String>> uploadImages(List<XFile> images) async {
    final List<String> urls = [];

    for (final img in images) {
      final ext = img.path.split('.').last;
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final path = 'posts/$fileName';

      await supabase.storage
          .from('post_images')
          .upload(path, File(img.path));

      final url =
      supabase.storage.from('post_images').getPublicUrl(path);

      urls.add(url);
    }

    return urls;
  }

  @override
  Future<void> deletePost(String postId) async {
    // DB kaydını sil
    await supabase
        .from('posts')
        .delete()
        .eq('id', postId);
  }


  /*@override
  Future<void> updatePost(EditPost post) async {
    final model = EditPostModel.fromEntity(post);
    await remote.updatePost(model);
  }*/

  String _extractPathFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.pathSegments.sublist(2).join('/');
    // bucketName + posts/xxx.jpg → posts/xxx.jpg
  }
}

