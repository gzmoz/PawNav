import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/core/utils/post_status.dart';
import 'package:pawnav/features/account/presentations/cubit/saved_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/saved_posts_state.dart';

class SavedPostsGrid extends StatelessWidget {
  const SavedPostsGrid({super.key});

  String? _firstImage(List<String>? images) {
    if (images == null || images.isEmpty) return null;
    return images.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPostsCubit, SavedPostsState>(
      builder: (context, state) {
        if (state is SavedPostsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SavedPostsError) {
          return Center(child: Text(state.message));
        }

        if (state is! SavedPostsLoaded) {
          return const SizedBox.shrink();
        }

        if (state.posts.isEmpty) {
          return const Center(
            child: Text("NO SAVED POSTS"),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          // padding: const EdgeInsets.all(12),
          padding: EdgeInsets.fromLTRB(
            12,
            12,
            12,
            12 +
                MediaQuery.of(context).padding.bottom +
                kBottomNavigationBarHeight,
          ),

          //  NestedScrollView ile uyumlu: kendi scroll’u olsun
          physics: const AlwaysScrollableScrollPhysics(),
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
                  onTap: () async {
                    final removed = await context.push<bool>(
                      '/post-detail/${post.id}',
                    );

                    if (removed == true) {
                      context
                          .read<SavedPostsCubit>()
                          .removeSavedPost(post.id);
                    }


                    /*if (removed == true) {
                      context.read<SavedPostsCubit>().loadSavedPosts();
                      // veya aşağıda anlatacağım optimistic remove
                    }*/
                  },

                  /*onTap: () {
                    context.push(
                      '/post-detail/${post.id}',
                    );
                  },*/

                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: img == null
                            ? Container(color: Colors.grey.shade200)
                            : Image.network(
                                img,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.low,
                              ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
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
