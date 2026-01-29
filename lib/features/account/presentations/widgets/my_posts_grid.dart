import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/core/utils/post_status.dart';
import 'package:pawnav/features/account/presentations/cubit/account_status_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_state.dart';
import 'package:pawnav/features/success_story/presentation/cubit/account_success_stories_cubit.dart';

class MyPostsGrid extends StatelessWidget {
  const MyPostsGrid({super.key});

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

            final statusBgColor = PostStatusStyle.background(post.postType);

            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () async {
                      final result = await context.push<Object?>(
                        '/my-post/${post.id}',
                      );

                      /*final result = await context.push<bool>(
                        '/my-post/${post.id}',
                      );*/

                      if (result == true) {
                        context.read<MyPostsCubit>().loadMyPosts();
                        context.read<AccountStatsCubit>().refresh();
                      }
                      if (result == 'post_deleted') {
                        context.read<MyPostsCubit>().loadMyPosts();
                        context.read<AccountStatsCubit>().refresh();
                        context.read<AccountSuccessStoriesCubit>().loadMySuccessStories();
                      }
                    },

                    /*onTap: () async {
                    final shouldRefresh = await context.push<bool>(
                      '/my-post/${post.id}',
                    );

                    if (shouldRefresh == true) {
                      context.read<MyPostsCubit>().loadMyPosts();
                    }

                    final deleted = await context.push<bool>(
                      '/my-post/${post.id}',
                    );

                    if (deleted == true) {
                      context.read<MyPostsCubit>().loadMyPosts();
                      context.read<AccountStatsCubit>().loadStats();
                    }

                    *//*AccountPage → DetailPage’e gider
                      Bekler (await)
                      DetailPage kapanınca geri dönen sonucu alır
                      Eğer true ise:
                      “Liste artık geçersiz”
                      Yeniden fetch et*//*
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
