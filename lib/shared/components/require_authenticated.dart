import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:stichsync/views/auth/login.dart';

class RequireAuthenticated extends StatefulWidget {
  final Widget child;
  const RequireAuthenticated({super.key, required this.child});

  @override
  State<RequireAuthenticated> createState() => _RequireAuthenticatedState();
}

class _RequireAuthenticatedState extends State<RequireAuthenticated> {
  final _authService = GetIt.I<AuthService>();

  @override
  Widget build(BuildContext context) {
    return _authService.isAuthenticated ? widget.child : const Login();
  }
}
