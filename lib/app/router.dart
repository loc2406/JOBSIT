import 'package:go_router/go_router.dart';
import 'package:jobsit_mobile/features/auth/screens/login_screen.dart';
import 'package:jobsit_mobile/shared/widgets/main_screen.dart';

class AppRouter {
  static const mainPath = '/';
  static const mainName = 'main';

  static const loginPath = '/login';
  static const loginName = 'login';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: mainPath,
        name: mainName,
        builder: (context, state) => const MainScreen(),
        routes: [
          loginRoute(),
        ],
      )
    ],
  );

  static GoRoute loginRoute() => GoRoute(
        path: loginPath,
        name: loginName,
        builder: (context, state) {
          return const LoginScreen();
        },
      );
}
