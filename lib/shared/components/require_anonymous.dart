import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:stichsync/views/auth/login.dart';

class RequireAnonymous extends StatefulWidget {
  final Widget child;
  const RequireAnonymous({super.key, required this.child});

  @override
  State<RequireAnonymous> createState() => _RequireAnonymousState();
}

class _RequireAnonymousState extends State<RequireAnonymous> {
  final _authService = GetIt.I<AuthService>();

  @override
  Widget build(BuildContext context) {
    return !_authService.isAuthenticated ? widget.child : const Login();
  }
}
