import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:go_router/go_router.dart';
import 'package:pawnav/bottom_nav_bar.dart';
import 'package:pawnav/features/account/domain/usecases/get_current_profile.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_cubit.dart';
import 'package:pawnav/features/account/presentations/screens/AccountPage.dart';
import 'package:pawnav/features/account/presentations/screens/MenuProfile.dart';
import 'package:pawnav/features/addPost/data/datasources/post_remote_datasource.dart' show PostRemoteDataSource;
import 'package:pawnav/features/addPost/data/repositories/post_repository_impl.dart';
import 'package:pawnav/features/addPost/domain/usecases/create_post_usecase.dart';
import 'package:pawnav/features/addPost/presentation/cubit/add_post_cubit.dart';
import 'package:pawnav/features/addPost/presentation/screen/AddPostFormPage.dart';
import 'package:pawnav/features/addPost/presentation/screen/AddPostPage.dart';
import 'package:pawnav/features/addPost/presentation/screen/select_location_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/additional_info_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/login_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:pawnav/features/onboarding/presentations/screens/onboarding_screen.dart';
import 'package:pawnav/features/post/presentations/screens/MapScreen.dart';
import 'package:pawnav/features/post/presentations/screens/PostPage.dart';
import 'package:pawnav/features/post/presentations/screens/my_post_detail_page.dart';
import 'package:pawnav/main.dart';
import 'package:pawnav/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final router = GoRouter(
  initialLocation: '/splash',
    routes: [

      GoRoute(
          path: '/splash',
          builder: (context,state) => const SplashScreen(),
      ),

      GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
          path: '/sign_up',
          builder: (context,state) => const SignUpScreen(),
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
        path: '/home',
        builder: (context, state) => const HomeScreen(),
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

      /*GoRoute(
        path: '/addPostForm',
        builder: (context, state){
          final type = state.uri.queryParameters['type'] ?? "Lost";
          return AddPostFormPage(type: type);
        },
      ),*/

      GoRoute(
        path: "/addPostForm",
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? "Lost";

          return BlocProvider(
            create: (context) => AddPostCubit(
              AddPost(
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

      /*
      * :postId → dinamik parametre
      URL’den veri almanı sağlar
      **/
      GoRoute(
        path: '/my-post/:postId',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return MyPostDetailPage(postId: postId); // sayfanın constructor'ında al
        },
      ),




    ],

);

