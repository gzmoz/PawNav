import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:pawnav/core/utils/post_status.dart';
import 'package:pawnav/features/post/presentations/cubit/post_detail_cubit.dart';
import 'package:pawnav/features/post/presentations/cubit/post_detail_state.dart';
import 'package:pawnav/features/post/presentations/widgets/info_mini_card.dart';
import 'package:pawnav/features/post/presentations/widgets/location_card.dart';
import 'package:pawnav/features/post/presentations/widgets/my_carousel.dart';
import 'package:pawnav/features/post/presentations/widgets/section_card.dart';
import 'package:pawnav/features/post/presentations/widgets/top_info_card.dart';

class MyPostDetailPage extends StatefulWidget {
  final String postId;

  const MyPostDetailPage({super.key, required this.postId});

  @override
  State<MyPostDetailPage> createState() => _MyPostDetailPageState();
}

class _MyPostDetailPageState extends State<MyPostDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostDetailCubit>().loadPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Scaffold(
      backgroundColor: AppColors.white5,
      body: BlocBuilder<PostDetailCubit, PostDetailState>(
        builder: (context, state) {
          if (state is PostDeleted) {
            Navigator.pop(context, true);
            // listeye dön
            /*“Ben kapanıyorum ama sana şunu söylüyorum:
            Burada bir değişiklik oldu”*/
          }
          if (state is PostDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostDetailError) {
            return Center(child: Text(state.message));
          }

          if (state is! PostDetailLoaded) {
            return const SizedBox.shrink();
          }

          final post = state.post;

          final statusColor = PostStatusStyle.color(post.postType);
          final statusBg = PostStatusStyle.background(post.postType);
          final genderUI = getGenderUI(post.gender);

          return CustomScrollView(
            slivers: [
              /// APP BAR
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "Post Detail",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: width* 0.05,
                  ),
                ),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share, color: Colors.black),
                  ),
                ],
              ),

              /// CAROUSEL
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: MyCarousel(
                    images: post.images,
                    statusText: post.postType.toUpperCase(),
                    statusColor: statusColor,
                    statusBg: statusBg,
                  ),
                ),
              ),

              /// CONTENT
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                  child: Column(
                    children: [
                      /// TOP INFO
                      TopInfoCard(
                        name: post.name ?? '',
                        breed: post.breed,
                        views: post.views,
                        postedAgo: post.eventDate.toString(),
                      ),

                      const SizedBox(height: 12),

                      /// INFO CARDS
                      Row(
                        children: [
                          Expanded(
                            child: InfoMiniCard(
                              title: "SPECIES",
                              value: post.species,
                              icon: Icons.pets,
                              iconBg: const Color(0xFFE9EDFF),
                              iconColor: const Color(0xFF3B5BDB),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InfoMiniCard(
                              title: "GENDER",
                              value: post.gender,
                              icon: genderUI.icon,
                              iconBg: genderUI.bgColor,
                              iconColor: genderUI.iconColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: InfoMiniCard(
                              title: "COLOR",
                              value: post.color,
                              icon: Icons.palette,
                              iconBg: const Color(0xFFFFF1E6),
                              iconColor: const Color(0xFFFF7A00),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InfoMiniCard(
                              title: "LAST SEEN",
                              value: post.eventDate.toString(),
                              icon: Icons.calendar_month,
                              iconBg: const Color(0xFFFFE9E9),
                              iconColor: const Color(0xFFE03131),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// ABOUT
                      SectionCard(
                        title: "About ${post.name ?? ''}",
                        icon: Icons.description_outlined,
                        child: Text(
                          post.description,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: width * 0.035,
                            height: 1.35,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// LOCATION
                      LocationCard(
                        title: "Last Seen Location",
                        address: post.location,
                      ),

                      const SizedBox(height: 20),

                      /// OWNER ACTIONS
                      const Text(
                        "OWNER ACTIONS",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 15),

                      /// MARK AS REUNITED
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.celebration_outlined),
                          label: const Text("Mark as Reunited!"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF18B394),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// EDIT + DELETE
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final updated = await context.push<bool>(
                                    '/edit-post/${post.id}',
                                  );

                                  if (updated == true) {
                                    context.read<PostDetailCubit>().loadPost(post.id);
                                    AppSnackbar.success(context, "Post updated successfully");
                                  }
                                },
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text("Edit Post"),
                              ),

                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                /*onPressed: () {
                                  context.read<PostDetailCubit>().delete(widget.postId);
                                },*/
                                onPressed: () => showDeleteDialog(context),

                                icon: const Icon(Icons.delete_outline),
                                label: const Text("Delete Post"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: BorderSide(color: Colors.red.shade200),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Delete post?",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            "Are you sure you want to permanently delete this post? "
                "This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // dialog kapat
                deletePost(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void deletePost(BuildContext context) async {
    final cubit = context.read<PostDetailCubit>();

    try {
      await cubit.deletePost(widget.postId); // postId içeride tutuluyor varsayımı

      // SUCCESS SNACK
      AppSnackbar.success(
        context,
        "Post deleted successfully",
      );

      // AccountPage’e sinyal gönder
      Navigator.pop(context, true);
    } catch (e) {
      AppSnackbar.error(
        context,
        "Failed to delete post. Please try again.",
      );
    }
  }


}

/// ---------------- GENDER UI ----------------

class GenderUIData {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const GenderUIData({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}

GenderUIData getGenderUI(String? gender) {
  switch (gender?.toLowerCase()) {
    case "female":
      return const GenderUIData(
        icon: Icons.female,
        bgColor: Color(0xFFFFE4EC),
        iconColor: Color(0xFFE91E63),
      );
    case "male":
      return const GenderUIData(
        icon: Icons.male,
        bgColor: Color(0xFFE9EDFF),
        iconColor: Color(0xFF3B5BDB),
      );
    default:
      return const GenderUIData(
        icon: Icons.help_outline,
        bgColor: Color(0xFFF1F3F5),
        iconColor: Color(0xFF868E96),
      );
  }
}
