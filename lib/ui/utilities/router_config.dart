import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_maker/ui/screens/auth/forgot_password.dart';
import 'package:quiz_maker/ui/screens/auth/sign_in.dart';
import 'package:quiz_maker/ui/screens/auth/sign_up.dart';
import 'package:quiz_maker/ui/screens/auth/verify_email.dart';
import 'package:quiz_maker/ui/screens/home.dart';
import 'package:quiz_maker/ui/screens/new_quiz.dart';
import 'package:quiz_maker/ui/screens/play_quiz.dart';
import 'package:quiz_maker/ui/screens/prep_screen.dart';
import 'package:quiz_maker/ui/screens/quiz.dart';
import 'package:quiz_maker/ui/screens/solo_quiz.dart';

import '../../data/constants/route_paths.dart';
import '../../data/models/quiz.dart';

final routerConfig = GoRouter(
  routes: [
    GoRoute(
        path: RoutePaths.root,
        name: RoutePaths.root,
        builder: (context, routerState) => const HomeScreen(),
        routes: [
          GoRoute(
            path: RoutePaths.newQuiz,
            name: RoutePaths.newQuiz,
            builder: (_, routerState) =>
                NewQuizScreen(quiz: routerState.queryParams),
          ),
          GoRoute(
            path: RoutePaths.quiz,
            name: RoutePaths.quiz,
            builder: (_, routerState) => QuestionScreen(
              id: routerState.queryParams['id'],
            ),
          ),
          GoRoute(
            path: RoutePaths.playQuiz,
            name: RoutePaths.playQuiz,
            builder: (_, routerState) => const PlayQuizWidget(),
          ),
          GoRoute(
            path: RoutePaths.prepQuiz,
            name: RoutePaths.prepQuiz,
            builder: (_, routerState) => PrepScreen(
              id: routerState.queryParams['id']!,
            ),
          ),
          GoRoute(
            path: RoutePaths.soloQuiz,
            name: RoutePaths.soloQuiz,
            builder: (_, routerState) => SoloQuiz(
                quiz: routerState.extra as Quiz,
                maker: routerState.queryParams['maker']!,
                quizId: routerState.queryParams['quizId']!),
          ),
        ],
        redirect: (_, routerState) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null || !user.emailVerified) {
            return RoutePaths.signIn;
          }
          return routerState.location;
        }),
    GoRoute(
      path: RoutePaths.signIn,
      name: RoutePaths.signIn,
      builder: (context, routerState) => const SignInScreen(),
      routes: const [],
    ),
    GoRoute(
      path: RoutePaths.signUp,
      name: RoutePaths.signUp,
      builder: (context, routerState) => const SignUpScreen(),
      routes: const [],
    ),
    GoRoute(
      path: RoutePaths.forgotPassword,
      name: RoutePaths.forgotPassword,
      builder: (context, routerState) => const ForgotPasswordScreen(),
      routes: const [],
    ),
    GoRoute(
      path: RoutePaths.sendEmailVerificationLink,
      name: RoutePaths.sendEmailVerificationLink,
      builder: (context, routerState) => const VerifyEmailScreen(),
      routes: const [],
    ),
  ],
);
