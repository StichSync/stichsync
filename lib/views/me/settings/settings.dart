import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/nav/ss_nav_back_button.dart';
import 'package:stichsync/shared/models/context/user_claims_model.dart';
import 'package:stichsync/shared/services/auth_service.dart';

// this site will contain general app settings
// will also contain big sidebar with all settings subsites and/or
// small settings (eg dark mode switch)
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _authService = GetIt.I<AuthService>();
  late final UserClaims userClaims;

  @override
  void initState() {
    super.initState();
    userClaims = _authService.claims!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const SsNavBackBtn(),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Current user email is: ${userClaims.email}",
            ),
            Text(
              "Current user role is: ${userClaims.applicationRole}",
            ),
          ],
        ),
      ),
    );
  }
}
