import 'package:flutter/material.dart';
import 'package:stichsync/shared/components/horizontal_carousel.dart';
import 'package:stichsync/shared/models/crochet_model.dart';

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
  
  List crochets = [
    CrochetModel(id: "69", createdAt: DateTime.now(), name: "Kaktus", description: "Niesamowity kaktus wyszydełkowany, strasznie fajny", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 2137, downvoteCount: 0, saveCount: 420, authorNickname: "lasgra"),
    CrochetModel(id: "69", createdAt: DateTime.now(), name: "Żabka", description: "Fajna mała żabka, nie skacze, ale za to ładnie wygląda", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 352523, downvoteCount: 574344, saveCount: 232424, authorNickname: "Eugieniusz"),
    CrochetModel(id: "69", createdAt: DateTime.now(), name: "Pżyszczoła", description: "Fajna pżyszczoła, nawet lata", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 222, downvoteCount: 123, saveCount: 420, authorNickname: "Ewelina"),
    CrochetModel(id: "69", createdAt: DateTime.now(), name: "Smoczek", description: "20-metrowy smok, wczoraj wieczorkiem go wyhaftowałem", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 2, downvoteCount: 31, saveCount: 0, authorNickname: "Paulina"),
    CrochetModel(id: "69", createdAt: DateTime.now(), name: "Piwerko", description: "Piwo, smaczne polecam", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 54, downvoteCount: 3, saveCount: 18, authorNickname: "Izabela"),
  ];

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            HorizCarousel(items: crochets),
            Text(
              'Button has been pressed $_counter times',
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
