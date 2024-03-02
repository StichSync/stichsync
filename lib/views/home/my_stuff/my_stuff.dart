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
        child: Text(
          'Button has been pressed $_counter times',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FloatingActionButton(
            onPressed: () {_incrementCounter();},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          )),
    );
  }
}
