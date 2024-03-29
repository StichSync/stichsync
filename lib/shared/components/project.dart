import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/editable_avatar.dart';
import 'package:stichsync/shared/components/editable_text_item.dart';
import 'package:stichsync/shared/components/image_picker_util.dart';
import 'package:stichsync/shared/components/nav/ss_nav_back_button.dart';
import 'package:stichsync/shared/components/pattern_section.dart';
import 'package:stichsync/shared/components/text_edit_dialog.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/constants/attribute.dart';
import 'package:stichsync/shared/constants/pattern_section.dart';
import 'package:stichsync/shared/services/project_service.dart';

class SsProject extends StatefulWidget {
  final String id;
  const SsProject({
    required this.id,
    super.key,
  });

  @override
  State<SsProject> createState() => _SsProjectState();
}

class _SsProjectState extends State<SsProject> {
  String projectName = "";
  String projectDesc = "";
  String projectMedia = "";
  bool isVisible = false;
  final projectService = GetIt.I<ProjectService>();
  List<DatabasePatternSectionEnum> projectList = [
    DatabasePatternSectionEnum(
      "aaa",
      "aaa",
      ["wwww"],
      [DatabaseAttributeClass("length", "foot", 12), DatabaseAttributeClass("length", "foot", 12)],
    )
  ];
  List<GlobalKey<SsPatternSectionState>> listPatterns = [];

  Future<void> addWidget(Key key) async {
    setState(() {
      isVisible = true;
      listPatterns.add(GlobalKey<SsPatternSectionState>());
    });
    while (listPatterns.last.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() {
      listPatterns.last.currentState!.addWidget();
    });
  }

  void removeWidget(Key key) {
    setState(() {
      isVisible = true;
      listPatterns.remove(key);
    });
  }

  Future<void> saveProject() async {
    setState(() {
      isVisible = false;
    });
    projectList = [];
    for (var e in listPatterns) {
      projectList.add(
        DatabasePatternSectionEnum(
          e.currentState!.sectionName,
          e.currentState!.descName,
          [e.currentState!.sectionImage],
          await e.currentState!.getAttributes(),
        ),
      );
    }
    projectService.saveProject(projectList, widget.id);
  }

  @override
  void initState() {
    super.initState();
    fetchProject();
    fetchProjectData();
  }

  Future<void> fetchProject() async {
    List<Map<String, dynamic>>? response = await projectService.fetchSectionData(widget.id);
    if (response != null) {
      for (var i = 0; i < response.length; i++) {
        setState(() {
          listPatterns.add(GlobalKey<SsPatternSectionState>());
        });
      }
      for (var i = 0; i < response.length; i++) {
        while (listPatterns[i].currentState == null) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        setState(() {
          listPatterns[i].currentState!.sectionName = response[i]["name"];
          listPatterns[i].currentState!.descName = response[i]["description"];
          listPatterns[i].currentState!.sectionImage = response[i]["mediaUrls"][0];
          listPatterns[i].currentState!.fetchAttributes(response[i]["id"]);
        });
      }
    } else {}
  }

  Future<void> fetchProjectData() async {
    List<Map<String, dynamic>>? response = await projectService.fetchProjectData(widget.id);
    if (response != null) {
      projectName = response[0]["name"];
      projectDesc = response[0]["description"];
      projectMedia = response[0]["mediaUrls"];
    }
  }

  Future<void> updateProjectName() async {
    Future<String?> editedText = SsTextEditDialog(
      limit: 40,
      placeholder: projectName,
      title: 'Update project name',
    ).show(context);
    await editedText.then((text) async {
      if (text != null) {
        var response = await projectService.updateProject(projectName, projectDesc, projectMedia, widget.id);
        if (response != null) {
          SsToaster.toast(msg: "Project updated succesfully", type: ToastType.success);
        } else {
          SsToaster.toast(msg: "Something went wrong", type: ToastType.error);
        }
        setState(() {
          projectName = text;
        });
      } else {
        SsToaster.toast(
          msg: "Text cannot be empty",
          type: ToastType.error,
        );
      }
    });
  }

  Future<void> updateProjectDesc() async {
    Future<String?> editedText = SsTextEditDialog(
      limit: 250,
      placeholder: projectDesc,
      title: 'Update project description',
    ).show(context);
    await editedText.then((text) async {
      if (text != null) {
        var response = await projectService.updateProject(projectName, projectDesc, projectMedia, widget.id);
        if (response != null) {
          SsToaster.toast(msg: "Project updated succesfully", type: ToastType.success);
        } else {
          SsToaster.toast(msg: "Something went wrong", type: ToastType.error);
        }
        setState(() {
          projectDesc = text;
        });
      } else {
        SsToaster.toast(
          msg: "Text cannot be empty",
          type: ToastType.error,
        );
      }
    });
  }

  Future<void> updateProjectMedia() async {
    final file = await ImagePickerUtil.pickImageFromGallery();
    if (file != null) {
      var result = await projectService.setProjectImage(file, widget.id);
      SsToaster.toast(
        msg: "Image updated.",
        type: ToastType.success,
      );
      setState(() {
        projectMedia = result;
      });
    } else {
      SsToaster.toast(
        msg: "Operation cancelled.",
        type: ToastType.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Change project info"),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                right: -40,
                                top: -40,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close),
                                  ),
                                ),
                              ),
                              Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Center(
                                      child: Text(
                                        "Project name",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: SsEditableTextItem(
                                        text: projectName,
                                        onPressed: () async {
                                          await updateProjectName();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    const Center(
                                      child: Text(
                                        "Project description",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: SsEditableTextItem(
                                        text: projectDesc,
                                        onPressed: () async {
                                          await updateProjectDesc();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    const Center(
                                      child: Text(
                                        "Project image",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: SsEditableAvatar(
                                          radius: 300,
                                          square: true,
                                          imageUrl: projectMedia,
                                          onPressed: () async {
                                            await updateProjectMedia();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SsNavBackBtn(),
          Expanded(
            child: ListView(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: listPatterns.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SsPatternSection(
                          key: listPatterns[index],
                          addPatternSection: (Key key) {
                            addWidget(key);
                          },
                          removePatternSection: (Key key) {
                            removeWidget(key);
                          },
                          changed: () {
                            setState(() {
                              isVisible = true;
                            });
                          },
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: isVisible,
        child: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            saveProject();
          },
        ),
      ),
    );
  }
}
