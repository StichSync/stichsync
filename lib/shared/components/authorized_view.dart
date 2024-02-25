import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/services/auth_service.dart';

class AuthorizedView extends StatefulWidget {
  final Widget child;
  const AuthorizedView({super.key, required this.child});

  @override
  State<AuthorizedView> createState() => _AuthorizedViewState();
}

class _AuthorizedViewState extends State<AuthorizedView> {
  late AuthService authService;
  late bool isAuthenticated;

  @override
  void initState() {
    super.initState();
    authService = GetIt.I<AuthService>();

    Future.microtask(() async {
      isAuthenticated = await authService.isAuthenticated();
      if (!isAuthenticated) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, "/login");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
