import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/models/crochet_model.dart';
import 'package:stichsync/views/home/inspirations/components/inspiration_post.dart';
import 'package:stichsync/views/home/inspirations/data_access/inspirations_service.dart';

// This page will be something similar to linkedIn feed.
// The user can scroll trough the app, and posts they see will
// contain crochet ideas that the user can save, like, dislike, comment
class Inspirations extends StatefulWidget {
  const Inspirations({super.key});

  @override
  State<Inspirations> createState() => _InspirationsState();
}

class _InspirationsState extends State<Inspirations> with AutomaticKeepAliveClientMixin<Inspirations> {
  final crochetService = GetIt.instance.get<CrochetService>();
  late List<CrochetModel> crochets;

  @override
  void initState() {
    super.initState();
    crochets = crochetService.get(10, 1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView.builder(
        itemCount: crochets.length,
        itemBuilder: (context, index) {
          return InspirationPost(crochet: crochets[index]);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
