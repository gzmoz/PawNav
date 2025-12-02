import 'package:pawnav/features/addPost/data/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


//DataSource = “Gerçek HTTP isteğini atan yer”.
//Direkt olarak Supabase ile konuşan yer burası.
class PostRemoteDataSource{
  final SupabaseClient supabase;

  PostRemoteDataSource(this.supabase);

  Future<void> addPost(PostModel post) async{
    await supabase.from("posts").insert(post.toJson());
  }

}