import 'package:pawnav/features/addPost/data/datasources/post_remote_datasource.dart';
import 'package:pawnav/features/addPost/data/models/post_model.dart';
import 'package:pawnav/features/addPost/domain/entities/add_post_entity.dart';
import 'package:pawnav/features/addPost/domain/repositories/add_post_repository.dart';


//Domain’deki PostRepository interface’ini gerçekleyen sınıf.
//katmanlar arasındaki kopru, “Domain ile data kaynağı arasında tercümanlık yapan adam.”

class PostRepositoryImpl implements AddPostRepository{
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addPost(Post post) async {
    final model = PostModel(
      id: post.id,
      userId: post.userId,
      species: post.species,
      breed: post.breed,
      color: post.color,
      gender: post.gender,
      name: post.name,
      description: post.description,
      location: post.location,
      eventDate: post.eventDate,
      images: post.images,
      postType: post.postType,
      lat: post.lat,
      lon: post.lon,
    );

    await remoteDataSource.addPost(model);
  }
}