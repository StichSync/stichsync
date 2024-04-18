import 'package:go_router/go_router.dart';
import 'package:stichsync/shared/components/project.dart';
import 'package:stichsync/views/auth/forgot_password.dart';
import 'package:stichsync/views/auth/login.dart';
import 'package:stichsync/views/auth/register.dart';
import 'package:stichsync/views/home/home.dart';
import 'package:stichsync/views/me/me.dart';
import 'package:stichsync/views/me/settings/settings.dart';

final List<GoRoute> routerRoutes = [
  GoRoute(
    name: 'home',
    path: '/',
    builder: (context, state) => const Home(),
  ),
  GoRoute(
    name: 'me',
    path: '/me',
    builder: (context, state) => const Me(),
  ),
  GoRoute(
    name: 'settings',
    path: '/settings',
    builder: (context, state) => const Settings(),
  ),
  GoRoute(
    name: 'login',
    path: '/login',
    builder: (context, state) => const Login(),
  ),
  GoRoute(
    name: 'register',
    path: '/register',
    builder: (context, state) => const Register(),
  ),
  GoRoute(
    path: '/resetPassword',
    builder: (context, state) => const ForgotPassword(),
  ),
  GoRoute(
    path: '/reset-password',
    builder: (context, state) => const ForgotPassword(),
  ),
  GoRoute(
    name: 'project/:id',
    path: '/project/:id',
    builder: (context, state) => SsProject(id: state.pathParameters['id']!),
  ),
];
