import 'package:flutter/material.dart';
import 'package:stichsync/shared/config/app_config.dart';
import 'package:stichsync/shared/services/router/router.dart';
import 'package:stichsync/views/home/inspirations/inspirations.dart';
import 'package:stichsync/views/home/my_stuff/my_stuff.dart';
import 'package:stichsync/views/home/saved/saved.dart';

// home - a default page that logged in user is routed to by default.
// it contains three screens: saved, myStuff, inspirations
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  @override
  void initState() {
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(
            left: 8.0,
          ),
          child: Text(
            AppConfig.appTitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 36,
            ),
            onPressed: () => router.pushNamed('me'),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 36,
              ),
              onPressed: () => router.pushNamed('settings'),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => onPageChanged(index),
        padEnds: false,
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
    );
  }
}
