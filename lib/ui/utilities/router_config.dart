import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_maker/ui/screens/auth.dart';
import 'package:quiz_maker/ui/screens/new_question.dart';
import 'package:quiz_maker/ui/screens/new_quiz.dart';
import 'package:quiz_maker/ui/screens/play_quiz.dart';

import '../../data/constants/route_paths.dart';
import '../screens/home.dart';

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
            path: RoutePaths.newQuestion,
            name: RoutePaths.newQuestion,
            builder: (_, routerState) => NewQuestionScreen(
              params: routerState.queryParams,
            ),
          ),
          GoRoute(
            path: RoutePaths.playQuiz,
            name: RoutePaths.playQuiz,
            builder: (_, routerState) => const PlayQuizWidget(),
          ),
        ],
        redirect: (_, routerState) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null || !user.emailVerified) {
            return RoutePaths.auth;
          }
          return routerState.location;
        }),
    GoRoute(
      path: RoutePaths.auth,
      name: RoutePaths.auth,
      builder: (context, routerState) => const AuthScreen(),
      routes: const [],
    ),
  ],
);
