import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/services/auth_service.dart';

class RequireAnonymous extends StatefulWidget {
  final Widget child;
  const RequireAnonymous({super.key, required this.child});

  @override
  State<RequireAnonymous> createState() => _RequireAnonymousState();
}

class _RequireAnonymousState extends State<RequireAnonymous> {
  late AuthService authService;
  late bool isAuthenticated;

  @override
  void initState() {
    super.initState();
    authService = GetIt.I<AuthService>();

    Future.microtask(() async {
      if (await authService.isAuthenticated()) {
        Future.microtask(
          () => Navigator.popAndPushNamed(context, ""),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
