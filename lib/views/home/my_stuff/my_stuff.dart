import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/text_button.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/models/crochet_model.dart';
import 'package:stichsync/shared/services/project_service.dart';
import 'package:stichsync/shared/services/router/router.dart';
import 'package:stichsync/views/home/inspirations/components/inspiration_post.dart';

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
  final projectService = GetIt.I<ProjectService>();
  CrochetModel? crochet;

  Future<CrochetModel?> getCrotchet() async {
    return await projectService.getNewestProject();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCrotchet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          crochet = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SsTextButton(
                text: "Create new Project",
                bgColor: Colors.green,
                onPressed: () async {
                  String id = await projectService.addProject();
                  if (id != "") {
                    SsToaster.toast(msg: "Project created", type: ToastType.success, longTime: false);
                    router.go('/project/$id');
                  }
                },
              ),
              Container(height: 25),
              crochet != null
                  ? const Text(
                      "Your last Post:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  : Container(),
              crochet != null
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => router.go('/project/${crochet!.id}'),
                      child: InspirationPost(crochet: crochet!),
                    )
                  : Container(),
            ],
          );
        } else {
          return const Text("Unhandled case");
        }
      },
    );
  }
}
