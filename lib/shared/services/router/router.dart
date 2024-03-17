import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:stichsync/shared/services/router/allow_anonymous_routes.dart';
import 'package:stichsync/shared/services/router/router_routes.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: routerRoutes,
  redirect: (context, state) async {
    final authService = GetIt.I<AuthService>();

    final isAnonymousRoute = allowAnonymousRoutes.contains(state.path);
    final isAuthenticated = await authService.isAuthenticated;

    if (!isAuthenticated && !isAnonymousRoute) {
      // require authenticated
      return '/login';
    }

    // no need to redirect
    return null;
  },
);
