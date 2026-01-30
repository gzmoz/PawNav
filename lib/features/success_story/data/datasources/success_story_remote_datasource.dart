import 'package:pawnav/features/success_story/data/models/profile_model.dart';
import 'package:pawnav/features/success_story/data/models/success_story_model.dart';
import 'package:pawnav/features/success_story/domain/entities/success_story_detail_entity.dart';
import 'package:pawnav/features/success_story/domain/repositories/post_type_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SuccessStoryRemoteDataSource {
  final SupabaseClient client;

  SuccessStoryRemoteDataSource(this.client);

  Future<Map<String, dynamic>> getPostById(String postId) async {
    final res = await client
        .from('posts')
        .select(
        'id, user_id, name, species, breed, created_at, post_type, images')
        .eq('id', postId)
        .single();
    return res;
  }

  Future<Map<String, dynamic>> getProfileById(String userId) async {
    final res = await client
        .from('profiles')
        .select('id, name, username, photo_url')
        .eq('id', userId)
        .single();
    return res;
  }

  Future<List<Map<String, dynamic>>> searchProfiles(String query) async {
    if (query.trim().isEmpty) return []; //Boş string ile DB’ye istek atma
    final q = query.trim(); //Baş–son boşlukları temizle

    final res = await client
        .from('profiles')
        .select('id, name, username, photo_url')
        .or('name.ilike.%$q%,username.ilike.%$q%')
        .limit(20);

    //ilike → case-insensitive , % → contains
    /* WHERE name ILIKE '%q%'
    *OR username ILIKE '%q%'
    * */

    //Supabase dynamic döndürür
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<void> createSuccessStory({
    required String postId,
    required String ownerId,
    required String story,
    String? heroId,
  }) async {
    // 1 success story oluştur
    await client.from('success_stories').insert({
      'post_id': postId,
      'owner_id': ownerId,
      'hero_id': heroId,
      'story': story,
    });

    //  post'u pasifleştir
    await client
        .from('posts')
        .update({'is_active': false})
        .eq('id', postId);
  }


  /*Future<void> createSuccessStory({
    required String postId,
    required String ownerId,
    required String story,
    String? heroId,
  }) async {
    await client.from('success_stories').insert({
      'post_id': postId,
      'owner_id': ownerId,
      'hero_id': heroId,
      'story': story,
    });
  }*/

  Future<SuccessStoryDetailEntity> getStoryDetail(String storyId) async {
    final response = await client
        .from('success_stories')
        .select('''
        *,
        posts (
          name,
          species,
          breed,
          images,
          post_type,
          created_at,
          location
        ),
        owner:profiles!owner_id(id, name, username, photo_url),
        hero:profiles!hero_id(id, name, username, photo_url)
      ''')
        .eq('id', storyId)
        .single();

    final post = response['posts'];

    final List images = post['images'] ?? [];
    final String coverImageUrl =
    images.isNotEmpty ? images.first as String : '';

    final DateTime lostDate =
    DateTime.parse(post['created_at']);

    final DateTime reunitedDate =
    DateTime.parse(response['created_at']);

    final bool isAdopted =
        post['post_type'] == 'Adopted' ||
            post['post_type'] == 'Reunited';

    final PostType postType =
    parsePostType(post['post_type']);

    final String? location = post['location']; // varsa


    return SuccessStoryDetailEntity(
      postType: postType,
      location: location,
      story: SuccessStoryModel.fromMap(response),
      petName: post['name'],
      species: post['species'],
      breed: post['breed'],
      age: null,
      coverImageUrl: coverImageUrl,
      isAdopted: isAdopted,

      lostDate: lostDate,
      reunitedDate: reunitedDate,

      owner: ProfileModel.fromMap(response['owner']),
      hero: response['hero'] != null
          ? ProfileModel.fromMap(response['hero'])
          : null,
    );
  }

  Future<void> deleteStory(String storyId) async {
    await client
        .from('success_stories')
        .delete()
        .eq('id', storyId);
  }





}