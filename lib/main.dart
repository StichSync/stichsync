import 'package:flutter/material.dart';
import 'package:stichsync/startup.dart';
import 'package:stichsync/shared/config/app_config.dart';
import 'package:stichsync/shared/config/theme_config.dart';
import 'package:stichsync/views/auth/Authorization.dart';
import 'package:stichsync/views/home/home.dart';
import 'package:stichsync/views/me/me.dart';
import 'package:stichsync/views/me/settings/settings.dart';

Future<void> main() async {
  await Startup().registerServices();
  runApp(const StichSyncApp());
}

class StichSyncApp extends StatefulWidget {
  const StichSyncApp({super.key});

  @override
  State<StichSyncApp> createState() => _StichSyncAppState();
}

class _StichSyncAppState extends State<StichSyncApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appTitle,
      theme: ThemeConfig.themeData,
      home: const Home(),
      routes: {
        '': (context) => const Home(),
        '/Authorization': (context) => const Authorization(),
        '/me': (context) => const Me(),
        '/settings': (context) => const Settings()
      },
    );
  }
}
