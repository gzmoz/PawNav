import 'package:go_router/go_router.dart';
import 'package:pawnav/bottom_nav_bar.dart';
import 'package:pawnav/features/account/presentations/screens/MenuProfile.dart';
import 'package:pawnav/features/auth/presentation/screens/additional_info_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/login_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:pawnav/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:pawnav/features/onboarding/presentations/screens/onboarding_screen.dart';
import 'package:pawnav/features/post/presentations/screens/MapScreen.dart';
import 'package:pawnav/splash_screen.dart';

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


    ],

);