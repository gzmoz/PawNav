import 'package:pawnav/features/account/data/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPostRemoteDataSource {
  final SupabaseClient client;

  AccountPostRemoteDataSource (this.client);

  Future<List<PostModel>> getMyPosts(String userId) async{
    final response = await client
        .from('posts')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((e) => PostModel.fromMap(e))
        .toList();

  }
  
}