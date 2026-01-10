import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/account/data/models/post_model.dart';
import 'package:pawnav/features/account/presentations/cubit/saved_posts_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SavedPostsCubit extends Cubit<SavedPostsState> {
  final SupabaseClient client;

  SavedPostsCubit(this.client) : super(SavedPostsLoading());

  Future<void> loadSavedPosts() async {
    try {
      emit(SavedPostsLoading());

      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        emit(SavedPostsLoaded([]));
        return;
      }

      final res = await client
          .from('saved_posts')
          .select('posts(*)')
          .eq('user_id', userId);

      final posts = (res as List)
          .map((e) => PostModel.fromMap(e['posts']))
          .toList();


      emit(SavedPostsLoaded(posts));
    } catch (e) {
      emit(SavedPostsError(e.toString()));
    }
  }


}
