import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:pawnav/core/utils/post_status.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_state.dart';


class MyPostsGrid extends StatelessWidget {
  const MyPostsGrid({super.key});


  /*String? _firstImage(String? images) {
    if (images == null || images.isEmpty) return null;
    if (images.contains(',')) {
      return images.split(',').first.trim();
    }
    return images;
  }*/

  String? _firstImage(List<String>? images) {
    if (images == null || images.isEmpty) return null;
    return images.first;
  }




  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MyPostsCubit, MyPostsState>(
      builder: (context, state) {
        if (state is MyPostsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MyPostsError) {
          return Center(child: Text(state.message));
        }

        if (state is! MyPostsLoaded) {
          return const SizedBox.shrink();
        }

        if (state.posts.isEmpty) {
          return const Center(child: Text("NO POSTS FOUND"));
        }


        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: state.posts.length,
          itemBuilder: (context, index) {
            final post = state.posts[index];
            final img = _firstImage(post.images);

            final statusColor = PostStatusStyle.color(post.postType);
            final statusBgColor = PostStatusStyle.background(post.postType);

            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.push('/my-post/${post.id}');
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: img == null
                            ? Container(color: Colors.grey.shade200)
                            : Image.network(img, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            post.postType ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            /*style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),*/
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}


