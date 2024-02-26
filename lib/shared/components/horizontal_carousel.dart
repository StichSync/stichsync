import 'package:flutter/material.dart';
import 'package:stichsync/shared/config/theme_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stichsync/shared/models/crochet.dart';
import 'package:stichsync/views/home/inspirations/components/inspiration_post.dart';

class HorizCarousel extends StatefulWidget {
  const HorizCarousel({super.key});

  @override
  State<HorizCarousel> createState() => _HorizCarouselState();
}

class _HorizCarouselState extends State<HorizCarousel> {

  void getData() {
    // Code to get crotchet data from backend
  } 

  List<Crochet> crochets = [
    Crochet(id: "69", createdAt: DateTime.now(), name: "Kuktas", description: "Niesamowity kaktus wyszydełkowany, strasznie fajny", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 2137, downvoteCount: 0, saveCount: 420, authorNickname: "lasgra"),
    Crochet(id: "69", createdAt: DateTime.now(), name: "Żabka", description: "Fajna mała żabka, nie skacze, ale za to ładnie wygląda", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 352523, downvoteCount: 574344, saveCount: 232424, authorNickname: "Eugieniusz"),
    Crochet(id: "69", createdAt: DateTime.now(), name: "Pżyszczoła", description: "Fajna pżyszczoła, nawet lata", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 222, downvoteCount: 123, saveCount: 420, authorNickname: "Ewelina"),
    Crochet(id: "69", createdAt: DateTime.now(), name: "Smoczek", description: "20-metrowy smok, wczoraj wieczorkiem go wyhaftowałem", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 2, downvoteCount: 31, saveCount: 0, authorNickname: "Paulina"),
    Crochet(id: "69", createdAt: DateTime.now(), name: "Piwerko", description: "Piwo, smaczne polecam", mediaUrl: "https://placehold.co/600x400/png", upvoteCount: 54, downvoteCount: 3, saveCount: 18, authorNickname: "Izabela"),
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: crochets.map((crochet) {
        return InspirationPost(crochet: crochet);
      }).toList(),

      //Slider Container properties
      //carousel Slider flutter
      options: CarouselOptions(
        height: MediaQuery.of(context).size.width * 0.83,
        enlargeCenterPage: false,
        autoPlay: false,
        autoPlayCurve: ThemeConfig.buttonCurve,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: ThemeConfig.buttonDuration,
        viewportFraction: 0.78,
      ),
    );
  }
}
