import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/core/utils/post_status.dart';
import 'package:pawnav/features/account/data/models/post_model.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_state.dart';
import 'package:pawnav/features/account/presentations/cubit/saved_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/saved_posts_state.dart';


class SavedPostsGrid extends StatefulWidget {
  const SavedPostsGrid({super.key});

  static const pageKey = PageStorageKey('saved_posts_grid');

  @override
  State<SavedPostsGrid> createState() => _SavedPostsGridState();
}

class _SavedPostsGridState extends State<SavedPostsGrid>
    with AutomaticKeepAliveClientMixin {

  final _listKey = GlobalKey<AnimatedListState>();
  late List<PostModel> _posts;

  @override
  void initState() {
    super.initState();
    final state = context.read<SavedPostsCubit>().state;
    if (state is SavedPostsLoaded) {
      _posts = List.from(state.posts);
    } else {
      _posts = [];
    }
  }


  @override
  bool get wantKeepAlive => true;

  String? _firstImage(List<String>? images) {
    if (images == null || images.isEmpty) return null;
    return images.first;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          key: SavedPostsGrid.pageKey,
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
                  onTap: () {
                    context.push(
                      '/post-detail/${post.id}',
                    );
                  },

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
