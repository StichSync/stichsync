import 'package:flutter/material.dart';
import 'package:stichsync/startup.dart';
import 'package:stichsync/shared/config/app_config.dart';
import 'package:stichsync/shared/config/theme_config.dart';
import 'package:stichsync/views/home/home.dart';

void main() {
  Startup().registerServices();
  runApp(const StichSyncApp());
}

class StichSyncApp extends StatefulWidget {
  const StichSyncApp({super.key});

  @override
  State<StichSyncApp> createState() => _StichSyncAppState();
}

class _StichSyncAppState extends State<StichSyncApp> {
  // todo: create a main component that would decide where does
  // the user gets routed (not logged in -> auth, logged in -> home, etc)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appTitle,
      theme: ThemeConfig.themeData,
      home: const Home(),
    );
  }
}
