import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/models/crochet_model.dart';
import 'package:stichsync/shared/services/project_service.dart';
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
  final projectService = GetIt.instance.get<ProjectService>();
  List<InspirationPost> crochets = [];

  @override
  void initState() {
    super.initState();
    getProjects();
  }

  void getProjects() async {
    var projects = await projectService.getNewestProjects();
    if (projects != null) {
      crochets = crochetService.getProjectsFromData(projects!);
      setState(() {});
    } else {
      Toaster.toast(msg: "Something went wrong", type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const Text(
          "6 newest projects:",
          style: TextStyle(fontSize: 30),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: crochets.length,
            itemBuilder: (context, index) {
              return crochets[index];
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
