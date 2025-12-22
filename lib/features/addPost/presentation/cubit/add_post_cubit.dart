import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/addPost/domain/entities/add_post_entity.dart';
import 'package:pawnav/features/addPost/domain/usecases/create_post_usecase.dart';
import 'package:pawnav/features/addPost/presentation/cubit/add_post_state.dart';
import 'package:pawnav/features/post/domain/usecases/get_post_by_id.dart';

/*UI’den gelen Post’u alır.
Doğru sırayla state değiştirir.
Domain usecase’ini çağırır.*/


class AddPostCubit extends Cubit<AddPostState> {
  final AddPost addPostUseCase;

  AddPostCubit({
    required this.addPostUseCase,
  }) : super(AddPostInitial());


  Future<void> submitPost(Post post) async {
    try {
      print("ADD POST START");
      emit(AddPostLoading());

      await addPostUseCase(post);

      print("ADD POST SUCCESS");
      emit(AddPostSuccess());
    } catch (e) {
      print("ADD POST ERROR: $e");
      emit(AddPostError(e.toString()));
    }
  }


/*Future<void> submitPost(Post post) async{
    try{
      emit(AddPostLoading());
      await addPostUseCase(post); //Usecase → Repository → DataSource → Supabase zinciri.
      emit(AddPostSuccess());
    }catch(e){
      emit(AddPostError(e.toString()));
    }

  }*/
}