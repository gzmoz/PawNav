import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:pawnav/core/utils/date_formatter.dart';
import 'package:pawnav/core/utils/pet_color_mapper.dart';
import 'package:pawnav/core/utils/post_status.dart';
import 'package:pawnav/core/utils/time_ago.dart';
import 'package:pawnav/features/post/presentations/cubit/post_detail_cubit.dart';
import 'package:pawnav/features/post/presentations/cubit/post_detail_state.dart';
import 'package:pawnav/features/post/presentations/widgets/info_mini_card.dart';
import 'package:pawnav/features/post/presentations/widgets/location_card.dart';
import 'package:pawnav/features/post/presentations/widgets/my_carousel.dart';
import 'package:pawnav/features/post/presentations/widgets/post_owner_card.dart';
import 'package:pawnav/features/post/presentations/widgets/section_card.dart';
import 'package:pawnav/features/post/presentations/widgets/top_info_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPage extends StatefulWidget {
  final String postId;

  const DetailPage({super.key, required this.postId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostDetailCubit>().loadPost(widget.postId);
  }

  String getDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return "No description provided for this post.";
    }
    return description;
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      backgroundColor: AppColors.white5,
      body: BlocListener<PostDetailCubit, PostDetailState>(
        listener: (context, state) {

          if (state is PostDetailLoaded && state.justSaved != null) {
            // SAVED GRID'İ YENİLE
            //context.read<SavedPostsCubit>().loadSavedPosts();
            if (state.justSaved == true) {
              AppSnackbar.success(context, "Saved to your bookmarks");
            } else {
              AppSnackbar.info(context, "Removed from saved");
              Navigator.pop(context, true);
              /*context
                  .read<SavedPostsCubit>()
                  .removeSavedPost(state.post.id);*/
            }

          }

          if (state is PostUnsaved) {
            context.pop(true);
          }

          if (state is PostDeleted) {
            AppSnackbar.success(context, "Post deleted successfully");
            Navigator.pop(context, true);
          }

          if (state is PostDetailError) {
            AppSnackbar.error(context, state.message);
          }

        },
        child: BlocBuilder<PostDetailCubit, PostDetailState>(
          builder: (context, state) {
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
                      fontSize: width * 0.05,
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context,false),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
                  ),
                  actions: [
                    BlocBuilder<PostDetailCubit, PostDetailState>(
                      builder: (context, state) {
                        if (state is! PostDetailLoaded) {
                          return const SizedBox.shrink();
                        }

                        return IconButton(
                          onPressed: () {
                            context
                                .read<PostDetailCubit>()
                                .toggleSave(state.post.id);
                          },
                          icon: Icon(
                            state.isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: state.isSaved
                                ? AppColors.primary
                                : Colors.black,
                          ),
                        );
                      },
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
                          postDate: formatDate(post.eventDate),
                          postedAgo: timeAgo(post.eventDate),
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
                                iconBg: getPetColorBg(post.color),
                                iconColor: getPetColor(post.color),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InfoMiniCard(
                                title: "LAST SEEN",
                                value: formatDate(post.eventDate),
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
                            getDescription(post.description),
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

                        /// OWNER INFO
                        /*PostOwnerCard(
                          name: post.ownerName,
                          username: post.ownerUsername,
                          avatarUrl: post.ownerAvatar,
                        ),*/
                        if (post.owner != null)
                          PostOwnerCard(
                            name: post.owner!.name,
                            username: post.owner!.username,
                            avatarUrl: post.owner!.photoUrl ?? '',
                          ),




                        const SizedBox(height: 20),

                        //owner info
                        if (!state.isOwner)
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final supabase = Supabase.instance.client;

                                final res = await supabase.rpc(
                                  'get_or_create_chat',
                                  params: {
                                    'other_user_id': post.owner!.id,
                                  },
                                );


                                final chatId = res as String;

                                if (!context.mounted) return;
                                context.push('/chat/$chatId');
                              },

                              icon: const Icon(Icons.chat_bubble_outline),
                              label: const Text("Contact Owner"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),


                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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

  void deletePost(BuildContext context) {
    context.read<PostDetailCubit>().delete(widget.postId);
  }

/*void deletePost(BuildContext context) async {
    final cubit = context.read<PostDetailCubit>();

    try {
      await cubit
          .deletePost(widget.postId); // postId içeride tutuluyor varsayımı

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
  }*/
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
