import 'package:flutter/material.dart';
import 'package:stichsync/shared/config/theme_config.dart';
import 'package:stichsync/shared/components/horizontal_carousel.dart';

// This page will display users in-progress projects
// This is the default place the user gets redirected after successful login.
// The user can change in-progress state, add their own notes to a crochet,
// calculate needed ingredients, purchase ingredients, abandon a crochet
// Also, the user can create their own crochet project,
// and publish it to 'inspirations' if they want.
class MyStuff extends StatefulWidget {
  const MyStuff({super.key});

  @override
  State<MyStuff> createState() => _MyStuffState();
}

class _MyStuffState extends State<MyStuff> {
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            HorizCarousel(),
            Text(
              'Button has been pressed $_counter times',
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
