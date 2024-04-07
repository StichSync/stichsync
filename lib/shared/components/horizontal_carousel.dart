import 'package:flutter/material.dart';
import 'package:stichsync/shared/config/theme_config.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SsHorizCarousel extends StatefulWidget {
  final List items;
  final CarouselOptions? optionsOver;
  const SsHorizCarousel({super.key, required this.items, this.optionsOver});

  @override
  State<SsHorizCarousel> createState() => _SsHorizCarouselState();
}

class _SsHorizCarouselState extends State<SsHorizCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => widget.items[itemIndex],

      // IMPORTANT to change amount of visible items, change viewportFraction and height
      options: CarouselOptions(
        height: widget.optionsOver?.height ?? MediaQuery.of(context).size.width * 0.78,
        enlargeCenterPage: widget.optionsOver?.enlargeCenterPage ?? true,
        enlargeStrategy: widget.optionsOver?.enlargeStrategy ?? CenterPageEnlargeStrategy.zoom,
        autoPlay: widget.optionsOver?.autoPlay ?? false,
        autoPlayCurve: widget.optionsOver?.autoPlayCurve ?? ThemeConfig.buttonCurve,
        enableInfiniteScroll: widget.optionsOver?.enableInfiniteScroll ?? true,
        autoPlayAnimationDuration: widget.optionsOver?.autoPlayAnimationDuration ?? ThemeConfig.buttonDuration,
        viewportFraction: widget.optionsOver?.viewportFraction ?? 0.78,
      ),
    );
  }
}
