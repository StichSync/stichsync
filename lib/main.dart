import 'package:flutter/material.dart';
import 'package:stichsync/shared/services/router/router.dart';
import 'package:stichsync/startup.dart';
import 'package:stichsync/shared/config/app_config.dart';
import 'package:stichsync/shared/config/theme_config.dart';

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
    return MaterialApp.router(
      title: AppConfig.appTitle,
      theme: ThemeConfig.themeData,
      routerConfig: router,
    );
  }
}
