import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/features/success_story/data/models/profile_model.dart';
import 'package:pawnav/features/success_story/domain/repositories/post_type_enum.dart';
import 'package:pawnav/features/success_story/domain/repositories/success_story_repository.dart';
import 'package:pawnav/features/success_story/presentation/cubit/account_success_stories_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/success_story_detail_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/success_story_detail_state.dart';

class SuccessStoryDetailPage extends StatelessWidget {
  final String storyId;

  const SuccessStoryDetailPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SuccessStoryDetailCubit(
        context.read<SuccessStoryRepository>(),
      )..load(storyId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6FA),
        appBar: AppBar(
          title: const Text("Success Story"),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocListener<SuccessStoryDetailCubit, SuccessStoryDetailState>(
          listener: (context, state) {
            if (state is SuccessStoryDeleted) {
              // SADECE DETAIL PAGE KAPAT
              context.pop('story_deleted');
              //Navigator.pop(context,true);
            }
          },
          child: BlocBuilder<SuccessStoryDetailCubit, SuccessStoryDetailState>(
            buildWhen: (previous, current) {
              // Deleted state UI'ı rebuild ETMESİN
              return current is! SuccessStoryDeleted;
            },
            builder: (context, state) {
              if (state is SuccessStoryDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SuccessStoryDetailError) {
                return Center(child: Text(state.message));
              }

              if (state is! SuccessStoryDetailLoaded) {
                return const SizedBox.shrink();
              }

              final s = state;


              /*if (state is SuccessStoryDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }
          
              if (state is SuccessStoryDetailError) {
                return Center(child: Text(state.message));
              }
              final s = state as SuccessStoryDetailLoaded;*/


          
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 420, // 320 image + ~100 card overlap
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.network(
                            s.coverImageUrl,
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: StatusBadge(postType: s.postType),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _PetInfoCard(
                                petName: s.petName,
                                breed: s.breed,
                                species: s.species,
                                onViewPost: () {
                                  context.push('/post-detail/${s.story.postId}');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    const SizedBox(height: 20),
          
                    /// STORY
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "The Journey Home",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            s.story.story,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
          
                          TimelineWithBackground(
                            lostDate: s.lostDate,
                            reunitedDate: s.reunitedDate,
                            initialText: s.initialTimelineText,
                            finalText: s.finalTimelineText,
                          ),
          
                        ],
                      ),
                    ),
          
                    const SizedBox(height: 30),
          
                    /// HEROES
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _HeroesRow(
                        owner: s.owner,
                        hero: s.hero,
                      ),
                    ),
          
                    const SizedBox(height: 30),
          
                    /// EDIT + DELETE
                    if (s.isOwner)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25, right: 10, left: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    // edit flow
                                  },
                                  icon: const Icon(Icons.edit_outlined),
                                  label: const Text("Edit Story"),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    showDeleteDialog(
                                      context,
                                      onConfirm: () {
                                        context
                                            .read<SuccessStoryDetailCubit>()
                                            .deleteStory(storyId);
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text("Delete Story"),
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
                      ),

                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 25, right: 10, left:10),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: SizedBox(
                    //           height: 52,
                    //           child: OutlinedButton.icon(
                    //             onPressed: () async {
                    //
                    //             },
                    //             icon: const Icon(Icons.edit_outlined),
                    //             label: const Text("Edit Story"),
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(width: 12),
                    //       Expanded(
                    //         child: SizedBox(
                    //           height: 52,
                    //           child: OutlinedButton.icon(
                    //             /*onPressed: () {
                    //                   context.read<PostDetailCubit>().delete(widget.postId);
                    //                 },*/
                    //             onPressed: () {
                    //               showDeleteDialog(
                    //                 context,
                    //                 onConfirm: () {
                    //                   context.read<SuccessStoryDetailCubit>()
                    //                       .deleteStory(storyId);
                    //                 },
                    //               );
                    //             },
                    //
                    //             icon: const Icon(Icons.delete_outline),
                    //             label: const Text("Delete Story"),
                    //             style: OutlinedButton.styleFrom(
                    //               foregroundColor: Colors.red,
                    //               side:
                    //               BorderSide(color: Colors.red.shade200),
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(14),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


class _PetInfoCard extends StatelessWidget {
  final String petName;
  final String breed;
  final String species;
  final VoidCallback onViewPost;

  const _PetInfoCard({
    required this.petName,
    required this.breed,
    required this.species,
    required this.onViewPost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          /*const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/pet_placeholder.png'),
          ),*/
          const SizedBox(height: 8),
          Text(
            petName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$breed • $species",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onViewPost,
              icon: const Icon(Icons.description_outlined),
              label: const Text("View Original Post"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F1F6),
                foregroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroesRow extends StatelessWidget {
  final ProfileModel owner;
  final ProfileModel? hero;

  const _HeroesRow({
    required this.owner,
    this.hero,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "The Heroes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _HeroMiniCard(
                title: "The Owner",
                profile: owner,
              ),
              const Icon(
                Icons.favorite,
                color: Color(0xFFD1CDE8),
                size: 22,
              ),
              if (hero != null)
                _HeroMiniCard(
                  title: "The Finder",
                  profile: hero!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroMiniCard extends StatelessWidget {
  final String title;
  final ProfileModel profile;

  const _HeroMiniCard({
    required this.title,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: const Color(0xFFF2F2F7),
          backgroundImage:
              (profile.photoUrl != null && profile.photoUrl!.isNotEmpty)
                  ? NetworkImage(profile.photoUrl!)
                  : null,
          child: (profile.photoUrl == null || profile.photoUrl!.isEmpty)
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          profile.displayName,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}


class JourneyTimelineCard extends StatelessWidget {
  final DateTime lostDate;
  final DateTime reunitedDate;
  final String initialText;
  final String finalText;

  const JourneyTimelineCard({
    super.key,
    required this.lostDate,
    required this.reunitedDate,
    required this.initialText,
    required this.finalText,
  });

  int get totalDays => reunitedDate.difference(lostDate).inDays.abs();

  String _dateLabel(DateTime d) {
    const months = [
      "JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE",
      "JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"
    ];
    return "${months[d.month - 1]} ${d.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Journey Timeline",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4B3FAF),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4B3FAF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$totalDays DAYS TOTAL",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _TimelineItem(
            dotColor: Colors.grey,
            date: _dateLabel(lostDate),
            text: initialText,
          ),

          const SizedBox(height: 12),

          _TimelineItem(
            dotColor: const Color(0xFF358C5A),
            date: _dateLabel(reunitedDate),
            text: finalText,
            isLast: true,
          ),
        ],
      ),
    );
  }
}


class _TimelineItem extends StatelessWidget {
  final Color dotColor;
  final String date;
  final String text;
  final bool isLast;

  const _TimelineItem({
    required this.dotColor,
    required this.date,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TimelineWithBackground extends StatelessWidget {
  final DateTime lostDate;
  final DateTime reunitedDate;
  final String initialText;
  final String finalText;

  const TimelineWithBackground({
    super.key,
    required this.lostDate,
    required this.reunitedDate,
    required this.initialText,
    required this.finalText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9E6F7),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: JourneyTimelineCard(
            lostDate: lostDate,
            reunitedDate: reunitedDate,
            initialText: initialText,
            finalText: finalText,
          ),
        ),
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  final PostType postType;

  const StatusBadge({super.key, required this.postType});

  Color get backgroundColor {
    switch (postType) {
      case PostType.lost:
        return const Color(0xFF2B6A94);
      case PostType.found:
        return const Color(0xFF2B6A94);
      case PostType.adopted:
        return const Color(0xFF358C5A);
    }
  }

  IconData get icon {
    switch (postType) {
      case PostType.lost:
        return Icons.search;
      case PostType.found:
        return Icons.pets;
      case PostType.adopted:
        return Icons.check;
    }
  }

  String get label {
    switch (postType) {
      case PostType.adopted:
        return "ADOPTED";
      case PostType.lost:
      case PostType.found:
        return "REUNITED";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}


void showDeleteDialog(
    BuildContext context, {
      required VoidCallback onConfirm,
    }) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Delete story?",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          "Are you sure you want to permanently delete this success story? "
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
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}





