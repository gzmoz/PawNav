import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/account/data/repositories/post_repository.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyPostsCubit extends Cubit<MyPostsState>{
  final PostRepository repository;
  final SupabaseClient client;

  MyPostsCubit({
    required this.repository,
    required this.client
  }) :super(MyPostsInitial());

  Future<void> loadMyPosts() async{
    try{
      emit(MyPostsLoading());

      final user = client.auth.currentUser;

      if(user == null){
        emit(MyPostsError("User not logged in"));
        return;
      }

      final posts = await repository.getMyPosts(user.id);
      emit(MyPostsLoaded(posts));

    }catch(e){
      emit(MyPostsError(e.toString()));
    }
  }


}