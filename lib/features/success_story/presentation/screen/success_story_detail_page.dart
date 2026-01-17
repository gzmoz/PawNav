import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/features/success_story/data/models/profile_model.dart';
import 'package:pawnav/features/success_story/domain/repositories/success_story_repository.dart';
import 'package:pawnav/features/success_story/presentation/cubit/success_story_detail_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/success_story_detail_state.dart';

class SuccessStoryDetailPage extends StatelessWidget {
  final String storyId;

  const SuccessStoryDetailPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SuccessStoryDetailCubit(
        context.read<SuccessStoryRepository>(),
      )..load(storyId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6FA),
        appBar: AppBar(
          title: const Text("Success Story"),
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
        body: BlocBuilder<SuccessStoryDetailCubit, SuccessStoryDetailState>(
          builder: (context, state) {
            if (state is SuccessStoryDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SuccessStoryDetailError) {
              return Center(child: Text(state.message));
            }

            final s = state as SuccessStoryDetailLoaded;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HERO IMAGE
                  Stack(
                    children: [
                      Image.network(
                        s.coverImageUrl,
                        height: 320,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: _StatusBadge(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  /// PET INFO CARD (floating)
                  Transform.translate(
                    offset: const Offset(0, -120),
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
                        const SizedBox(height: 24),

                        /*_JourneyTimelineCard(
                          lostDate: s.lostDate,
                          reunitedDate: s.reunitedDate,
                          location: "Brookside Park", // şimdilik sabit
                        ),*/


                        const SizedBox(height: 32),

                        Text(
                          s.story.story,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// HEROES
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _HeroesRow(
                      owner: s.owner,
                      hero: s.hero,
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


class _StatusBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC71),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.check, size: 14, color: Colors.white),
          SizedBox(width: 6),
          Text(
            "REUNITED",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/pet_placeholder.png'),
          ),
          const SizedBox(height: 12),
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

  const _HeroesRow({required this.owner, this.hero});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "The Heroes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _HeroTile("The Owner", owner),
            const SizedBox(width: 20),
            if (hero != null) _HeroTile("The Finder", hero!),
          ],
        ),
      ],
    );
  }
}

class _HeroTile extends StatelessWidget {
  final String label;
  final ProfileModel profile;

  const _HeroTile(this.label, this.profile);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: (profile.photoUrl != null && profile.photoUrl!.isNotEmpty)
              ? NetworkImage(profile.photoUrl!)
              : null,
          child: (profile.photoUrl == null || profile.photoUrl!.isEmpty)
              ? const Icon(Icons.person)
              : null,
        ),

        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(profile.displayName, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}


class _JourneyTimelineCard extends StatelessWidget {
  final DateTime lostDate;
  final DateTime reunitedDate;
  final String location;

  const _JourneyTimelineCard({
    required this.lostDate,
    required this.reunitedDate,
    required this.location,
  });

  int get totalDays =>
      reunitedDate.difference(lostDate).inDays.abs();

  String _format(DateTime d) {
    return "${_month(d.month)} ${d.day}";
  }

  String _month(int m) {
    const months = [
      "JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE",
      "JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              const Text(
                "Journey Timeline",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF4B3FAF),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

          /// TIMELINE ITEM 1
          _TimelineRow(
            dotColor: Colors.grey,
            date: _format(lostDate),
            text: "Reported Lost in $location",
          ),

          const SizedBox(height: 12),

          /// TIMELINE ITEM 2
          _TimelineRow(
            dotColor: const Color(0xFF2ECC71),
            date: _format(reunitedDate),
            text: "Safely Reunited with Family",
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final Color dotColor;
  final String date;
  final String text;
  final bool isLast;

  const _TimelineRow({
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




