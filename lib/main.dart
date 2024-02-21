import 'package:flutter/material.dart';
import 'package:stichsync/components/header_nav.dart';
import 'package:stichsync/config/app_config.dart';
import 'package:stichsync/config/theme_config.dart';
import 'package:stichsync/views/feed.dart';

void main() {
  runApp(const StichSyncApp());
}

class StichSyncApp extends StatelessWidget {
  const StichSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primary: Colors.deepPurple,
          seedColor: Colors.deepPurple,
          brightness: ThemeConfig.appBrightness,
        ),
        useMaterial3: true,
      ),
      home: const MainAppComponent(),
    );
  }
}

class MainAppComponent extends StatelessWidget {
  const MainAppComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderNav(
        context: context,
        title: AppConfig.headerTitle,
      ),
      body: const Feed(),
    );
  }
}
