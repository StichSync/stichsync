import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/config/app_config.dart';
import 'package:stichsync/shared/config/theme_config.dart';
import 'package:stichsync/views/home/inspirations/data_access/crochet_service.dart';
import 'package:stichsync/views/home/inspirations/inspirations.dart';
import 'package:stichsync/views/home/my_stuff/my_stuff.dart';
import 'package:stichsync/views/home/saved/saved.dart';

// todo: move this DI to separate file
final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerFactory<CrochetService>(() => CrochetService());
}

void main() {
  setupLocator();
  runApp(const StichSyncApp());
}

class StichSyncApp extends StatefulWidget {
  const StichSyncApp({super.key});

  @override
  State<StichSyncApp> createState() => _StichSyncAppState();
}

class _StichSyncAppState extends State<StichSyncApp> {
  final _pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );
  final _items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.save),
      label: "Saved",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      label: "MyStuff",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.photo_album),
      label: "Inspirations",
    ),
  ];
  var _currentIndex = 1;

  void changePage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCirc,
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // todo: create a main component that would decide where does
  // the user gets routed (not logged in -> auth, logged in -> home, etc)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appTitle,
      theme: ThemeConfig.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppConfig.appTitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) => onPageChanged(index),
          children: const [
            Saved(),
            MyStuff(),
            Inspirations(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _items,
          currentIndex: _currentIndex,
          onTap: changePage,
        ),
      ),
    );
  }
}
