import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/MessagePage.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/data/datasources/account_post_remote_datasource.dart';
import 'package:pawnav/features/account/data/datasources/profile_remote_datasource.dart';
import 'package:pawnav/features/account/data/repositories/account_status_repository_impl.dart';
import 'package:pawnav/features/account/data/repositories/post_repository.dart';
import 'package:pawnav/features/account/data/repositories/profile_repository_impl.dart';
import 'package:pawnav/features/account/domain/repositories/profile_repository.dart';
import 'package:pawnav/features/account/domain/usecases/get_current_profile.dart';
import 'package:pawnav/features/account/presentations/cubit/account_status_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/saved_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/screens/AccountPage.dart';
import 'package:pawnav/features/addPost/presentation/screen/AddPostPage.dart';
import 'package:pawnav/features/home/data/repositories/home_repository_impl.dart';
import 'package:pawnav/features/home/data/repositories/recent_activity_repository_impl.dart';
import 'package:pawnav/features/home/domain/usecases/get_posts_by_views.dart';
import 'package:pawnav/features/home/presentations/cubit/featured_posts_cubit.dart';
import 'package:pawnav/features/home/presentations/cubit/recent_activity_cubit.dart';
import 'package:pawnav/features/home/presentations/screens/HomePage.dart';
import 'package:pawnav/features/home/success_stories/data/home_success_story_remote_ds.dart';
import 'package:pawnav/features/home/success_stories/presentation/cubit/home_success_stories_cubit.dart';
import 'package:pawnav/features/post/data/datasources/post_remote_datasource.dart';
import 'package:pawnav/features/post/data/repositories/post_repository_impl.dart';
import 'package:pawnav/features/post/domain/usecases/get_posts.dart';
import 'package:pawnav/features/post/presentations/cubit/post_list_cubit.dart';
import 'package:pawnav/features/post/presentations/screens/PostPage.dart';
import 'package:pawnav/features/success_story/data/repositories/success_story_repository_impl.dart';
import 'package:pawnav/features/success_story/domain/repositories/success_story_repository.dart';
import 'package:pawnav/features/success_story/presentation/cubit/account_success_stories_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const PostPage();
      case 2:
        return const AddPostPage();
      case 3:
        return const MessagePage();
      case 4:
        return AccountPage(
          key: ValueKey('account-$index'),
        );
      //return const AccountPage();
      default:
        return const HomePage();
    }
  }

  /// Gradient'li icon widget
  Widget navIcon(
    IconData icon,
    int itemIndex,
    double size,
  ) {
    final bool isActive = index == itemIndex;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [Color(0xFF233E96), Color(0xFF3C59C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.black54,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final height = media.size.height;
    final width = media.size.width;
    return MultiRepositoryProvider(
      providers: [
        /// HOME REPOSITORY
        RepositoryProvider<HomeRepositoryImpl>(
          create: (_) => HomeRepositoryImpl(
            Supabase.instance.client,
          ),
        ),

        /// GET POSTS BY VIEWS USE CASE
        RepositoryProvider<GetPostsByViews>(
          create: (context) => GetPostsByViews(
            context.read<HomeRepositoryImpl>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          /// PROFILE
          BlocProvider(
            create: (_) => ProfileCubit(
              GetCurrentProfile(
                repo: ProfileRepositoryImpl(
                  remote: ProfileRemoteDataSource(
                    client: Supabase.instance.client,
                  ),
                ),
              ),
            )..loadProfile(),
          ),

          /// MY POSTS
          BlocProvider(
            create: (_) => MyPostsCubit(
              client: Supabase.instance.client,
              repository: PostRepository(
                AccountPostRemoteDataSource(Supabase.instance.client),
              ),
            ),
          ),

          /// RECENT POSTS
          BlocProvider(
            create: (_) => RecentActivityCubit(
              RecentActivityRepositoryImpl(
                Supabase.instance.client,
              ),
            )..fetchPreview(),
          ),

          /// FEATURED POSTS
          BlocProvider(
            create: (context) => FeaturedPostsCubit(
              context.read<GetPostsByViews>(),
            )..loadTop(limit: 5),
          ),

          BlocProvider(
            create: (_) => SavedPostsCubit(
              Supabase.instance.client,
            )..loadSavedPosts(),
          ),

          /// ACCOUNT STATS (Listings / Saved / Successes)
          BlocProvider(
            create: (_) => AccountStatsCubit(
              AccountStatsRepositoryImpl(
                Supabase.instance.client,
              ),
            )..loadStats(),
          ),

          BlocProvider(
            create: (_) => AccountSuccessStoriesCubit(
              Supabase.instance.client,
            )..loadMySuccessStories(),
          ),

          BlocProvider(
            create: (_) => HomeSuccessStoriesCubit(
              HomeSuccessStoryRemoteDS(Supabase.instance.client),
            ),
          ),

          BlocProvider(
            create: (_) => PostListCubit(
              GetPosts(
                PostRepositoryImpl(
                  PostRemoteDataSource(Supabase.instance.client),
                ),
              ),
            )..load(),
          ),

        ],
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: AppColors.background,
            extendBody: true,
            body: _buildScreen(index),

            // body: screens[index],
            bottomNavigationBar: CurvedNavigationBar(
              height: (height * 0.08).clamp(0.0, 75.0),
              backgroundColor: Colors.transparent,

              /// Gradient burada değil → icon içinde
              buttonBackgroundColor: Colors.transparent,

              items: [
                navIcon(Icons.home_outlined, 0, width * 0.07),
                navIcon(Icons.list, 1, width * 0.07),
                navIcon(Icons.add, 2, width * 0.07),
                navIcon(Icons.messenger_outline_sharp, 3, width * 0.07),
                navIcon(Icons.person_outline, 4, width * 0.07),
              ],
              index: index,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              onTap: (i) {
                setState(() {
                  index = i;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
