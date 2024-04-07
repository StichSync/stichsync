import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/text_button.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/services/project_service.dart';
import 'package:stichsync/shared/services/router/router.dart';

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
  final patternService = GetIt.I<ProjectService>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SsTextButton(
          text: "Create new Project",
          bgColor: Colors.green,
          onPressed: () async {
            String id = await patternService.addProject();
            if (id == "") {
              SsToaster.toast(msg: "Something went wrong", type: ToastType.error);
            } else {
              SsToaster.toast(msg: "Project created", type: ToastType.success, longTime: false);
              router.go('/project/$id');
            }
          },
        ),
      ],
    );
  }
}
