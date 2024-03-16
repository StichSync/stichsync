// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/services/auth_service.dart';

class RequireAuthenticated extends StatefulWidget {
  final Widget child;
  const RequireAuthenticated({super.key, required this.child});

  @override
  State<RequireAuthenticated> createState() => _RequireAuthenticatedState();
}

class _RequireAuthenticatedState extends State<RequireAuthenticated> {
  Future<bool> checkAuthState() async {
    final authService = GetIt.I<AuthService>();
    final isAuthenticated = await authService.isAuthenticated();

    // if (Uri.base.toString().split("/").last.split("?")[0] == "password-reset") {
    //   Navigator.pushReplacementNamed(context, "/passwordReset");
    //   return false;
    // } else {
    if (!isAuthenticated) {
      Navigator.pushReplacementNamed(context, "/login");
      return false;
    }
    return true;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAuthState(),
      builder: (ctx, snap) => widget.child,
    );
  }
}
