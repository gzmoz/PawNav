import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/services/badge_service.dart';
import 'package:pawnav/features/account/data/models/account_status_model.dart';
import 'package:pawnav/features/account/presentations/cubit/account_status_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_state.dart';
import 'package:pawnav/features/account/presentations/cubit/saved_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/widgets/my_posts_grid.dart';
import 'package:pawnav/features/account/presentations/widgets/saved_posts_grid.dart';
import 'package:pawnav/features/account/presentations/widgets/user_rank_card.dart';
import 'package:pawnav/features/badges/domain/logic/rank_calculator.dart';
import 'package:pawnav/features/success_story/data/datasources/success_story_remote_datasource.dart';
import 'package:pawnav/features/success_story/data/repositories/success_story_repository_impl.dart';
import 'package:pawnav/features/success_story/domain/repositories/success_story_repository.dart';
import 'package:pawnav/features/success_story/presentation/cubit/account_success_stories_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/account_success_stories_state.dart';
import 'package:pawnav/features/success_story/presentation/widgets/success_stories_grid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _earnedBadgeCount = 0;
  bool _loadingBadges = true;

  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
    context.read<MyPostsCubit>().loadMyPosts();
    // context.read<BadgesCubit>().load();
    context.read<SavedPostsCubit>().loadSavedPosts();
    context.read<AccountStatsCubit>().loadStats();

    _loadBadgeCount();
  }

  Future<void> _loadBadgeCount() async {
    final service = BadgeService();
    final count = await service.getEarnedBadgeCount();

    setState(() {
      _earnedBadgeCount = count;
      _loadingBadges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // final int earnedBadgeCount = 1; // şimdilik
    if (_loadingBadges) {
      return const SizedBox(); // veya shimmer
    }

    final rank = RankCalculator.calculate(_earnedBadgeCount);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SuccessStoryRepository>(
          create: (_) => SuccessStoryRepositoryImpl(
            SuccessStoryRemoteDataSource(Supabase.instance.client),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AccountSuccessStoriesCubit>(
            create: (context) => AccountSuccessStoriesCubit(
              Supabase.instance.client,
            )..loadMySuccessStories(),
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.white5,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return Text(
                    state.profile.username,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () async {
                  final result = await context.push('/menuProfile');

                  if (result == true) {
                    // Edit Profile başarılı
                    context.read<ProfileCubit>().loadProfile();

                    // İstersen ekstra şeyler:
                    // ScaffoldMessenger.of(context).showSnackBar(...)
                  }
                },

                /*onPressed: () {
                  context.push('/menuProfile');
                },*/
              ),
            ],
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileError) {
                return Center(child: Text(state.message));
              }

              if (state is! ProfileLoaded) {
                return const SizedBox.shrink();
              }

              final user = state.profile;

              return DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            children: [
                              // PROFILE HEADER
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.02,
                                  left: size.width * 0.05,
                                  right: size.width * 0.05,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: size.width * 0.15,
                                      backgroundImage: user.photoUrl.isNotEmpty
                                          ? (user.photoUrl.startsWith('http')
                                          ? NetworkImage(user.photoUrl)
                                          : FileImage(File(user.photoUrl)) as ImageProvider)
                                          : null,
                                      backgroundColor: Colors.grey.shade200,
                                    ),

                                    /*CircleAvatar(
                                      radius: size.width * 0.15,
                                      backgroundImage: user.photoUrl.isNotEmpty
                                          ? NetworkImage(user.photoUrl)
                                          : null,
                                      backgroundColor: Colors.grey.shade200,
                                    ),*/
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.width * 0.05,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        //badge

                                        UserRankCard(
                                          rank: rank,
                                          onTap: () {
                                            context.push('/badges');
                                          },
                                        ),

                                        const SizedBox(height: 12),
                                        BlocBuilder<AccountStatsCubit,
                                            AccountStats?>(
                                          builder: (context, stats) {
                                            if (stats == null) {
                                              return const SizedBox.shrink();
                                            }

                                            return Row(
                                              children: [
                                                _StatItem(
                                                  title:
                                                      stats.listings.toString(),
                                                  subtitle: "Listings",
                                                ),
                                                const SizedBox(width: 16),
                                                _StatItem(
                                                  title: stats.saved.toString(),
                                                  subtitle: "Saved",
                                                ),
                                                const SizedBox(width: 16),
                                                _StatItem(
                                                  title: stats.successes
                                                      .toString(),
                                                  subtitle: "Successes",
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        /*const Row(
                                          children: [
                                            _StatItem(title: "8", subtitle: "Listings"),
                                            SizedBox(width: 16),
                                            _StatItem(title: "22", subtitle: "Saved"),
                                            SizedBox(width: 16),
                                            _StatItem(title: "8", subtitle: "Successes"),
                                          ],
                                        ),*/
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // TAB BAR
                              const TabBar(
                                indicatorColor: AppColors.primary,
                                labelColor: AppColors.primary,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(icon: Icon(Icons.apps)),
                                  Tab(icon: Icon(Icons.bookmark)),
                                  Tab(icon: Icon(Icons.emoji_events)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },

                  //  SCROLL EDEN ASIL İÇERİK

                  body: TabBarView(
                    children: [
                      const MyPostsGrid(),
                      const SavedPostsGrid(),
                      BlocBuilder<AccountSuccessStoriesCubit, AccountSuccessStoriesState>(
                        builder: (context, state) {
                          final key = state is AccountSuccessStoriesLoaded
                              ? ValueKey(state.stories.length)
                              : const ValueKey('loading');

                          return SuccessStoriesGrid(key: key);
                        },
                      ),

                      //SuccessStoriesGrid(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  void _reloadSuccessStories() {
    context.read<AccountSuccessStoriesCubit>().loadMySuccessStories();
  }

}

class _StatItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
