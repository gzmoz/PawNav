import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_state.dart';
import 'package:pawnav/features/account/presentations/widgets/my_posts_grid.dart';
import 'package:pawnav/features/account/presentations/widgets/user_rank_card.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
    context.read<MyPostsCubit>().loadMyPosts();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    return Scaffold(
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
            onPressed: () {
              context.push('/menuProfile');
            },
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
                                      ? NetworkImage(user.photoUrl)
                                      : null,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.05,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    UserRankCard(
                                      rankTitle: "Gold Helper",
                                      rankIcon: Icons.workspace_premium,
                                      rankColor: Colors.amber.shade700,
                                    ),
                                    const SizedBox(height: 12),
                                    const Row(
                                      children: [
                                        _StatItem(title: "8", subtitle: "Listings"),
                                        SizedBox(width: 16),
                                        _StatItem(title: "22", subtitle: "Saved"),
                                        SizedBox(width: 16),
                                        _StatItem(title: "8", subtitle: "Successes"),
                                      ],
                                    ),
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

              // 🔥 SCROLL EDEN ASIL İÇERİK
              body: const TabBarView(
                children: [
                  MyPostsGrid(),
                  Center(child: Text("Saved posts will appear here.")),
                  Center(child: Text("Success stories will appear here.")),
                ],
              ),
            ),
          );
        },
      ),
    );
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
