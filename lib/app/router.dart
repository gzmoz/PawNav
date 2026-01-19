import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider, ReadContext, RepositoryProvider;
import 'package:go_router/go_router.dart';
import 'package:pawnav/bottom_nav_bar.dart';
import 'package:pawnav/features/account/presentations/screens/MenuProfile.dart';
import 'package:pawnav/features/addPost/data/datasources/post_remote_datasource.dart'
    show PostRemoteDataSource;
import 'package:pawnav/features/addPost/data/repositories/post_repository_impl.dart';
import 'package:pawnav/features/addPost/domain/usecases/create_post_usecase.dart';
import 'package:pawnav/features/addPost/presentation/cubit/add_post_cubit.dart';
import 'package:pawnav/features/addPost/presentation/screen/AddPostFormPage.dart'
    hide EditPostFormPage;
import 'package:pawnav/features/addPost/presentation/screen/AddPostPage.dart';
import 'package:pawnav/features/addPost/presentation/screen/select_location_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/additional_info_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/login_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:pawnav/features/badges/data/datasources/badge_remote_datasource.dart';
import 'package:pawnav/features/badges/data/repositories/badge_repository_impl.dart';
import 'package:pawnav/features/badges/domain/usecases/get_all_badges.dart';
import 'package:pawnav/features/badges/domain/usecases/get_user_badges.dart';
import 'package:pawnav/features/badges/presentation/cubit/badge_cubit.dart';
import 'package:pawnav/features/badges/presentation/screen/badges_page.dart';
import 'package:pawnav/features/editPost/data/datasources/edit_post_remote_datasource.dart';
import 'package:pawnav/features/editPost/data/repositories/edit_post_repository_impl.dart';
import 'package:pawnav/features/editPost/domain/usecases/get_post_for_edit.dart';
import 'package:pawnav/features/editPost/domain/usecases/update_post.dart';
import 'package:pawnav/features/editPost/presentation/cubit/edit_post_cubit.dart';
import 'package:pawnav/features/editPost/presentation/screen/edit_post_form_page.dart';
import 'package:pawnav/features/home/data/repositories/home_repository_impl.dart';
import 'package:pawnav/features/home/data/repositories/recent_activity_repository_impl.dart';
import 'package:pawnav/features/home/domain/usecases/get_posts_by_views.dart';
import 'package:pawnav/features/home/presentations/cubit/featured_posts_cubit.dart';
import 'package:pawnav/features/home/presentations/cubit/recent_activity_cubit.dart';
import 'package:pawnav/features/home/presentations/screens/most_viewed_pets_page.dart';
import 'package:pawnav/features/home/presentations/screens/recent_activity_page.dart';
import 'package:pawnav/features/onboarding/presentations/screens/onboarding_screen.dart';
import 'package:pawnav/features/post/data/datasources/post_detail_remote_datasource.dart';
import 'package:pawnav/features/post/data/repositories/post_detail_repository_impl.dart';
import 'package:pawnav/features/post/domain/usecases/add_post_view.dart';
import 'package:pawnav/features/post/domain/usecases/delete_post.dart';
import 'package:pawnav/features/post/domain/usecases/get_post_by_id.dart';
import 'package:pawnav/features/post/domain/usecases/is_post_saved.dart';
import 'package:pawnav/features/post/domain/usecases/toggle_save_post.dart';
import 'package:pawnav/features/post/presentations/cubit/post_detail_cubit.dart';
import 'package:pawnav/features/post/presentations/screens/MapScreen.dart';
import 'package:pawnav/features/post/presentations/screens/PostPage.dart';
import 'package:pawnav/features/post/presentations/screens/my_post_detail_page.dart';
import 'package:pawnav/features/post/presentations/screens/post_detail_page.dart';
import 'package:pawnav/features/success_story/data/datasources/success_story_remote_datasource.dart';
import 'package:pawnav/features/success_story/data/repositories/success_story_repository_impl.dart';
import 'package:pawnav/features/success_story/domain/repositories/success_story_repository.dart';
import 'package:pawnav/features/success_story/domain/usecases/create_success_story.dart';
import 'package:pawnav/features/success_story/domain/usecases/search_profiles.dart';
import 'package:pawnav/features/success_story/presentation/cubit/success_story_detail_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/write_success_story_cubit.dart';
import 'package:pawnav/features/success_story/presentation/screen/success_story_detail_page.dart';
import 'package:pawnav/features/success_story/presentation/screen/write_success_story_page.dart';
import 'package:pawnav/main.dart';
import 'package:pawnav/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/additional_info_screen',
      builder: (context, state) => const AdditionalInfoScreen(),
    ),
    GoRoute(
      path: '/verify_email_screen',
      builder: (context, state) => const VerifyEmailScreen(),
    ),
    /*GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),*/
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/menuProfile',
      builder: (context, state) => const MenuProfile(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/post',
      builder: (context, state) => const PostPage(),
    ),
    GoRoute(
      path: '/addPostBottom',
      builder: (context, state) => const AddPostPage(),
    ),
    GoRoute(
      path: '/my-post/:postId',
      builder: (context, state) {
        final postId = state.pathParameters['postId']!;

        final remote = PostDetailRemoteDataSource(
          Supabase.instance.client,
        );

        //final repository = PostDetailRepositoryImpl(remote);

        final repository = PostDetailRepositoryImpl(
          remote,
          Supabase.instance.client,
        );


        return BlocProvider(
          create: (_) => PostDetailCubit(
            GetPostById(repository),
            DeletePost(repository),
            AddPostView(repository),
            ToggleSavePost(repository),
            IsPostSaved(repository),
            Supabase.instance.client,
          ),
          child: MyPostDetailPage(postId: postId),
        );
      },
    ),
    GoRoute(
      path: '/edit-post/:postId',
      builder: (context, state) {
        final postId = state.pathParameters['postId']!;

        final remote = EditPostRemoteDataSource(
          Supabase.instance.client,
        );

        final repository =
            EditPostRepositoryImpl(remote, Supabase.instance.client);

        return BlocProvider(
          create: (_) => EditPostCubit(
            getPostForEdit: GetPostForEdit(repository),
            updatePost: UpdatePost(repository),
          ),
          child: EditPostFormPage(postId: postId),
        );
      },
    ),
    GoRoute(
      path: "/addPostForm",
      builder: (context, state) {
        final type = state.uri.queryParameters['type'] ?? "Lost";

        return BlocProvider(
          create: (context) => AddPostCubit(
            addPostUseCase: AddPost(
              repository: PostRepositoryImpl(
                remoteDataSource: PostRemoteDataSource(
                  Supabase.instance.client,
                ),
              ),
            ),
          ),
          child: AddPostFormPage(type: type),
        );
      },
    ),
    GoRoute(
      path: "/select-location",
      builder: (context, state) => const SelectLocationScreen(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/badges',
      builder: (context, state) {
        final supabase = Supabase.instance.client;

        final remote = BadgeRemoteDataSource(supabase);
        final repository = BadgeRepositoryImpl(remote, supabase);

        return BlocProvider(
          create: (_) => BadgesCubit(
            getAllBadges: GetAllBadges(repository),
            getUserBadgeIds: GetUserBadgeIds(repository),
          ),
          child: const BadgesPage(),
        );
      },
    ),
    GoRoute(
      path: '/post-detail/:postId',
      builder: (context, state) {
        final postId = state.pathParameters['postId']!;

        final remote = PostDetailRemoteDataSource(
          Supabase.instance.client,
        );

        final repository = PostDetailRepositoryImpl(
          remote,
          Supabase.instance.client,
        );


        //final repository = PostDetailRepositoryImpl(remote);

        return BlocProvider(
          create: (_) => PostDetailCubit(
            GetPostById(repository),
            DeletePost(repository),
            AddPostView(repository),
            ToggleSavePost(repository),
            IsPostSaved(repository),
            Supabase.instance.client,

          )..loadPost(postId),
          child: DetailPage(postId: postId),
        );
      },
    ),
    GoRoute(
      path: '/most-viewed',
      builder: (context, state) {
        final supabase = Supabase.instance.client;

        final homeRepo = HomeRepositoryImpl(supabase);
        final getPostsByViews = GetPostsByViews(homeRepo);

        return BlocProvider(
          create: (_) => FeaturedPostsCubit(
            getPostsByViews,
          )..loadTop(limit: 20),
          child: const MostViewedPetsPage(),
        );
      },
    ),

    GoRoute(
      path: '/write-success-story/:postId',
      builder: (context, state) {
        final postId = state.pathParameters['postId']!;
        final supabase = Supabase.instance.client;

        //  Remote
        final remote = SuccessStoryRemoteDataSource(supabase);

        // Repository
        final repository = SuccessStoryRepositoryImpl(remote);

        return BlocProvider(
          create: (_) => WriteSuccessStoryCubit(
            repo: repository,
            createStory: CreateSuccessStory(repository),
            searchProfiles: SearchProfiles(repository),
            supabase: supabase,
          ),
          child: WriteSuccessStoryPage(postId: postId),
        );
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final tab = state.extra is int ? state.extra as int : 0;
        return HomeScreen(initialIndex: tab);
      },
    ),

    /*GoRoute(
      path: '/home',
      builder: (context, state) {
        final tab = state.extra as int?;
        return HomeScreen(initialIndex: tab ?? 0);
      },
    ),*/
    GoRoute(
      path: '/recent-activity',
      builder: (context, state) {
        final supabase = Supabase.instance.client;
        final repo = RecentActivityRepositoryImpl(supabase);

        return BlocProvider(
          create: (_) => RecentActivityCubit(repo)..fetchAll(),
          child: const RecentActivityPage(),
        );
      },
    ),

    GoRoute(
      path: '/success-story/:storyId',
      builder: (context, state) {
        final storyId = state.pathParameters['storyId']!;
        final supabase = Supabase.instance.client;

        return RepositoryProvider<SuccessStoryRepository>(
          create: (_) => SuccessStoryRepositoryImpl(
            SuccessStoryRemoteDataSource(supabase),
          ),
          child: BlocProvider(
            create: (context) => SuccessStoryDetailCubit(
              context.read<SuccessStoryRepository>(),
            )..load(storyId),
            child: SuccessStoryDetailPage(storyId: storyId),
          ),
        );
      },
    ),






  ],
);
