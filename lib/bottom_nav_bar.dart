import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/MessagePage.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/data/datasources/post_remote_datasource.dart';
import 'package:pawnav/features/account/data/datasources/profile_remote_datasource.dart';
import 'package:pawnav/features/account/data/repositories/post_repository.dart';
import 'package:pawnav/features/account/data/repositories/profile_repository_impl.dart';
import 'package:pawnav/features/account/domain/repositories/profile_repository.dart';
import 'package:pawnav/features/account/domain/usecases/get_current_profile.dart';
import 'package:pawnav/features/account/presentations/cubit/my_posts_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_cubit.dart';
import 'package:pawnav/features/account/presentations/screens/AccountPage.dart';
import 'package:pawnav/features/addPost/presentation/screen/AddPostPage.dart';
import 'package:pawnav/features/home/data/repositories/recent_activity_repository_impl.dart';
import 'package:pawnav/features/home/presentations/cubit/recent_activity_cubit.dart';
import 'package:pawnav/features/home/presentations/screens/HomePage.dart';
import 'package:pawnav/features/post/presentations/screens/PostPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final screens = const [
    HomePage(),
    PostPage(),
    AddPostPage(),
    MessagePage(),
    AccountPage(),
  ];

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

    return MultiBlocProvider(
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
              PostRemoteDataSource(Supabase.instance.client),
            ),
          ),
        ),

        //RECENT POSTS
        BlocProvider(
          create: (_) => RecentActivityCubit(
            RecentActivityRepositoryImpl(
              Supabase.instance.client,
            ),
          )..fetchRecentPosts(),
        ),

      ],
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          extendBody: true,
          body: screens[index],
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
    );
  }
}




