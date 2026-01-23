
abstract class AddPostState{}

class AddPostInitial extends AddPostState{} //Ekran ilk açıldığında, hiçbir işlem yok
class AddPostLoading extends AddPostState{} //Kullanıcı “Add Post” butonuna basınca → istek atılırken.
class AddPostSuccess extends AddPostState{} //Supabase’e kayıt başarılı
class AddPostError extends AddPostState{ //Bir exception fırladı
  final String message;
  AddPostError(this.message);
}


