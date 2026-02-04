import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, ReadContext, RepositoryProvider;
import 'package:go_router/go_router.dart';
import 'package:pawnav/bottom_nav_bar.dart';
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
import 'package:pawnav/features/chat/presentation/cubit/chat_detail_cubit.dart';
import 'package:pawnav/features/chat/presentation/screens/chat_detail_screen.dart';
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
import 'package:pawnav/features/map/data/datasources/map_remote_datasource.dart';
import 'package:pawnav/features/map/domain/repositories/map_repository.dart';
import 'package:pawnav/features/map/presentation/cubit/map_cubit.dart';
import 'package:pawnav/features/map/presentation/screen/MapScreen.dart';
import 'package:pawnav/features/menu/data/datasources/edit_profile_remote_datasource.dart';
import 'package:pawnav/features/menu/data/repositories/edit_profile_repository_impl.dart';
import 'package:pawnav/features/menu/domain/repositories/edit_profile_repository.dart';
import 'package:pawnav/features/menu/domain/usecases/edit_profile_check_username_usecase.dart';
import 'package:pawnav/features/menu/domain/usecases/edit_profile_get_usecase.dart';
import 'package:pawnav/features/menu/domain/usecases/edit_profile_update_usecase.dart';
import 'package:pawnav/features/menu/presentation/cubit/edit_profile_cubit.dart';
import 'package:pawnav/features/menu/presentation/screen/MenuProfile.dart';
import 'package:pawnav/features/menu/presentation/screen/about_pawnav_page.dart';
import 'package:pawnav/features/menu/presentation/screen/app_preferences_screen.dart';
import 'package:pawnav/features/menu/presentation/screen/community_guidlines_page.dart';
import 'package:pawnav/features/menu/presentation/screen/change_password_screen.dart';
import 'package:pawnav/features/menu/presentation/screen/edit_profile_screen.dart';
import 'package:pawnav/features/menu/presentation/screen/email_address_page.dart';
import 'package:pawnav/features/menu/presentation/screen/help_support_screen.dart';
import 'package:pawnav/features/menu/presentation/screen/login_security_screen.dart';
import 'package:pawnav/features/menu/presentation/screen/privacy_policy_screen.dart';
import 'package:pawnav/features/menu/presentation/screen/terms_of_service_screen.dart';
import 'package:pawnav/features/onboarding/presentations/screens/onboarding_screen.dart';
import 'package:pawnav/features/post/data/datasources/post_detail_remote_datasource.dart';
import 'package:pawnav/features/post/data/repositories/post_detail_repository_impl.dart';
import 'package:pawnav/features/post/domain/usecases/add_post_view.dart';
import 'package:pawnav/features/post/domain/usecases/delete_post.dart';
import 'package:pawnav/features/post/domain/usecases/get_post_by_id.dart';
import 'package:pawnav/features/post/domain/usecases/is_post_saved.dart';
import 'package:pawnav/features/post/domain/usecases/toggle_save_post.dart';
import 'package:pawnav/features/post/presentations/cubit/post_detail_cubit.dart';
import 'package:pawnav/features/post/presentations/screens/PostPage.dart';
import 'package:pawnav/features/post/presentations/screens/my_post_detail_page.dart';
import 'package:pawnav/features/post/presentations/screens/post_detail_page.dart';
import 'package:pawnav/features/success_story/data/datasources/success_story_remote_datasource.dart';
import 'package:pawnav/features/success_story/data/repositories/success_story_repository_impl.dart';
import 'package:pawnav/features/success_story/domain/repositories/success_story_repository.dart';
import 'package:pawnav/features/success_story/domain/usecases/create_success_story.dart';
import 'package:pawnav/features/success_story/domain/usecases/search_profiles.dart';
import 'package:pawnav/features/success_story/presentation/cubit/edit_success_story_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/success_story_detail_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/write_success_story_cubit.dart';
import 'package:pawnav/features/success_story/presentation/screen/edit_success_story_page.dart';
import 'package:pawnav/features/success_story/presentation/screen/success_story_detail_page.dart';
import 'package:pawnav/features/success_story/presentation/screen/write_success_story_page.dart';
import 'package:pawnav/features/success_story/view_more/presentation/screens/success_stories_list_page.dart';
import 'package:pawnav/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;

    //public routes
    final authRoutes = [
      '/login',
      '/sign_up',
      '/forgot_password',
      '/verify_email_screen',
      '/privacy-policy',
      '/terms-of-service',
    ];

    final isAuthRoute = authRoutes.contains(state.matchedLocation);

    if (session == null && !isAuthRoute) {
      return '/login';
    }

    if (session != null && isAuthRoute) {
      return '/home';
    }

    return null;
  },

  /*redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final location = state.matchedLocation;

    final isAuthRoute = location == '/login' ||
        location == '/sign_up' ||
        location == '/splash';

    if (session == null && !isAuthRoute) {
      return '/login';
    }

    if (session != null && (location == '/login' || location == '/sign_up')) {
      return '/home';
    }

    return null;
  },
*/

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
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/menuProfile',
      builder: (context, state) => const MenuProfile(),
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
    GoRoute(
      path: '/success-stories',
      builder: (context, state) {
        return const SuccessStoriesListPage();
      },
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => MapCubit(
            MapRepositoryImpl(
              MapRemoteDataSource(Supabase.instance.client),
            ),
          ),
          child: const MapScreen(),
        );
      },
    ),

    GoRoute(
      path: '/edit-profile',
      builder: (context, state) {
        final supabase = Supabase.instance.client;

        // Remote
        final editProfileRemote =
        EditProfileRemoteDataSource(supabase);

        // Repository (INTERFACE TİPİ ÖNEMLİ)
        final EditProfileRepository editProfileRepository =
        EditProfileRepositoryImpl(editProfileRemote);

        return BlocProvider(
          create: (_) => EditProfileMenuCubit(
            EditProfileGetUseCase(editProfileRepository),
            EditProfileUpdateUseCase(editProfileRepository),
            EditProfileCheckUsernameUseCase(supabase),

          )..editProfileLoad(),
          child: const EditProfileScreen(),
        );
      },
    ),

    GoRoute(
      path: '/login-security',
      builder: (_, __) => const LoginSecurityPage(),
    ),
    GoRoute(
      path: '/login-callback',
      builder: (context, state) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),


    GoRoute(
      path: '/email-address',
      builder: (_, __) => const EmailAddressPage(),
    ),

    GoRoute(
      path: '/app-preferences',
      builder: (context, state) {
        return const AppPreferencesPage();
      },
    ),
    GoRoute(
      path: '/community-guidelines',
      builder: (context, state) {
        return const CommunityGuidelinesPage();
      },
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) {
        return const ChangePasswordScreen();
      },
    ),
    GoRoute(
      path: '/support',
      builder: (context, state) => const SupportPage(),
    ),
    GoRoute(
      path: '/about-pawnav',
      builder: (context, state) => const AboutPawNavPage(),
    ),
    GoRoute(
      path: '/terms-of-service',
      builder: (context, state) => const TermsOfServicePage(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyPage(),
    ),
    GoRoute(
      path: '/edit-success-story/:storyId',
      builder: (context, state) {
        final storyId = state.pathParameters['storyId']!;
        final supabase = Supabase.instance.client;

        final repository = SuccessStoryRepositoryImpl(
          SuccessStoryRemoteDataSource(supabase),
        );

        return RepositoryProvider<SuccessStoryRepository>(
          create: (_) => repository,
          child: RepositoryProvider<SearchProfiles>(
            create: (_) => SearchProfiles(repository),
            child: BlocProvider(
              create: (context) => EditSuccessStoryCubit(
                repo: context.read<SuccessStoryRepository>(),
                searchProfiles: context.read<SearchProfiles>(),
                supabase: supabase,
              )..init(storyId),
              child: EditSuccessStoryPage(storyId: storyId),
            ),
          ),
        );
      },
    ),

    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        return BlocProvider(
          create: (_) => ChatDetailCubit(chatId),
          child: ChatDetailScreen(chatId: chatId),
        );
      },
    ),






















  ],
);