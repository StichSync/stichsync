import 'package:flutter/material.dart';
import 'package:stichsync/config/theme_config.dart';

// This page will be something similar to linkedIn feed.
// The user can scroll trough the app, and posts they see will
// contain crochet ideas that the user can save, like, dislike, comment
class Inspirations extends StatefulWidget {
  const Inspirations({super.key});

  @override
  State<Inspirations> createState() => _InspirationsState();
}

class _InspirationsState extends State<Inspirations> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _resetCounter,
              tooltip: 'Reset',
              child: const Icon(Icons.refresh),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // todo: create a button component with animations already applied
                AnimatedOpacity(
                  opacity: _counter > 0 ? 1.0 : 0.5,
                  duration: ThemeConfig.buttonDuration,
                  curve: ThemeConfig.buttonCurve,
                  child: FloatingActionButton(
                    onPressed: _counter > 0 ? _decrementCounter : null,
                    tooltip: 'Decrement',
                    child: const Icon(Icons.remove),
                  ),
                ),
                const SizedBox(width: 15),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
