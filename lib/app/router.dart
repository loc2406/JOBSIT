import 'package:go_router/go_router.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:jobsit_mobile/features/jobs/presentation/screens/main_screen.dart';

class AppRouter {
  static const mainPath = '/';
  static const mainName = 'main';

  static const loginPath = '/login';
  static const loginName = 'login';

  static const registerPath = '/register';
  static const registerName = 'register';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: mainPath,
        name: mainName,
        builder: (context, state) => const MainScreen(),
        routes: [
          loginRoute(),
          registerRoute()
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

      static GoRoute registerRoute() => GoRoute(
        path: registerPath,
        name: registerName,
        builder: (context, state) {
          return const RegisterScreen();
        },
      );
}
