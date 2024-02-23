import 'package:flutter/material.dart';

// This page will be something similar to linkedIn feed.
// The user can scroll trough the app, and posts they see will
// contain crochet ideas that the user can save, like, dislike, comment
class Inspirations extends StatelessWidget {
  const Inspirations({super.key});

  Widget generatePost(int index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 300,
        height: 450,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Inspiration number $index',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return generatePost(index + 1);
          },
        ),
      ),
    );
  }
}
