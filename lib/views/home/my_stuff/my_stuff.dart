import 'package:flutter/material.dart';

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
          child: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          )),
    );
  }
}
