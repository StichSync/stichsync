import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/add_new_button.dart';
import 'package:stichsync/shared/components/editable_text_item.dart';
import 'package:stichsync/shared/components/nav/ss_nav_back_button.dart';
import 'package:stichsync/shared/components/pattern_section.dart';
import 'package:stichsync/shared/components/text_button.dart';
import 'package:stichsync/shared/components/text_edit_dialog.dart';
import 'package:stichsync/shared/components/text_input.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/components/tool_attribute.dart';
import 'package:stichsync/shared/components/yarn_attribute.dart';
import 'package:stichsync/shared/components/yarn_section.dart';
import 'package:stichsync/shared/config/theme_config.dart';
import 'package:stichsync/shared/models/db/dtos/project.dart';
import 'package:stichsync/shared/models/db/dtos/project_section.dart';
import 'package:stichsync/shared/models/db/dtos/project_yarn.dart';
import 'package:stichsync/shared/models/db/dtos/tool_attribute.dart';
import 'package:stichsync/shared/models/db/enums/attribute_parameter.dart';
import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';
import 'package:stichsync/shared/models/db/enums/tool.dart';
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
  final projectService = GetIt.instance.get<ProjectService>();
  List<DropdownMenuEntry<dynamic>> dropdownUnit =
      AttributeUnit.values.map((e) => e.name).toList().map<DropdownMenuEntry<String>>((String value) {
    return DropdownMenuEntry<String>(value: value, label: value);
  }).toList();
  String projectName = "";
  String projectDesc = "";
  String projectMedia = "";
  bool importVisible = true;
  bool toolAttribVisible = true;
  bool saveVisible = false;
  Project projectList = Project();
  List<GlobalKey<SsPatternSectionState>> listSections = [];
  List<GlobalKey<SsToolAttributeState>> listTools = [];
  List<GlobalKey<SsYarnSectionState>> listYarns = [];
  late Future<List<dynamic>> dataToShow;

  setDropdown(AttributeParameter pickedParameter) {
    if (WeightParameter.values
        .any((element) => element.toString().split(".")[1] == pickedParameter.toString().split(".")[1])) {
      dropdownUnit = WeightUnit.values.map((e) => e.name).toList().map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList();
    } else {
      dropdownUnit = LengthUnit.values.map((e) => e.name).toList().map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList();
    }
  }

  Future<void> addSection() async {
    Future<String?> editedText = SsTextEditDialog(
      limit: 40,
      placeholder: "",
      title: 'Toitle',
    ).show(context);
    await editedText.then((text) async {
      if (text != "" && text != null) {
        SsToaster.toast(msg: "Section created succesfully", type: ToastType.success, longTime: false);
        setState(() {
          saveVisible = true;
          listSections.add(GlobalKey<SsPatternSectionState>());
        });
        while (listSections.last.currentState == null) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        setState(() {
          listSections.last.currentState!.changeName(text);
        });
      } else {
        SsToaster.toast(
          msg: "Text cannot be empty",
          type: ToastType.error,
        );
      }
    });
  }

  Future<void> addTool() async {
    showDialog(
      context: context,
      builder: (context) {
        Tool? pickedTool;
        double? pickedSize;
        AttributeUnit? pickedUnit;
        AttributeParameter? pickedParameter;
        GlobalKey<SsTextInputState> sizeKey = GlobalKey<SsTextInputState>();
        Key dropdownKey = Key(Random().nextInt(10000).toString());
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Center(
                          child: Text(
                            "Select tool...",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(height: 8),
                        DropdownMenu(
                          requestFocusOnTap: false,
                          dropdownMenuEntries:
                              Tool.values.map((e) => e.name).toList().map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(value: value, label: value);
                          }).toList(),
                          onSelected: (value) {
                            pickedTool = Tool.values.firstWhere((e) => e.toString() == 'Tool.${value!}');
                            if (pickedTool == Tool.scissors) {
                              pickedSize = null;
                              pickedUnit = null;
                              setState(() {
                                toolAttribVisible = false;
                              });
                            } else {
                              setState(() {
                                toolAttribVisible = true;
                              });
                            }
                          },
                        ),
                        Container(height: 16),
                        Visibility(
                          visible: toolAttribVisible,
                          child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  "Enter size...",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SsTextInput(
                                key: sizeKey,
                                text: "",
                                style: const TextStyle(fontSize: 20),
                                maxCharacters: 4,
                                onChanged: (text) {
                                  if (double.tryParse(text) != null) {
                                    pickedSize = double.parse(text);
                                  } else {
                                    sizeKey.currentState!.setText(text.substring(0, text.length - 1));
                                    SsToaster.toast(
                                      msg: "Put numbers only",
                                      type: ToastType.warning,
                                      longTime: false,
                                    );
                                  }
                                },
                              ),
                              Container(height: 16),
                              const Center(
                                child: Text(
                                  "Select parameter...",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(height: 8),
                              DropdownMenu(
                                requestFocusOnTap: false,
                                dropdownMenuEntries: AttributeParameter.values
                                    .map((e) => e.name)
                                    .toList()
                                    .map<DropdownMenuEntry<String>>((String value) {
                                  return DropdownMenuEntry<String>(value: value, label: value);
                                }).toList(),
                                onSelected: (value) async {
                                  pickedParameter = AttributeParameter.values
                                      .firstWhere((e) => e.toString() == 'AttributeParameter.${value!}');
                                  List<DropdownMenuEntry<dynamic>> dropdownCopy = dropdownUnit;
                                  await setDropdown(pickedParameter!);
                                  pickedUnit = null;
                                  if (dropdownCopy != dropdownUnit) {
                                    setState(() {
                                      dropdownKey = Key(Random().nextInt(10000).toString());
                                    });
                                  }
                                },
                              ),
                              Container(height: 16),
                              const Center(
                                child: Text(
                                  "Select jednostka...",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(height: 8),
                              Center(
                                child: DropdownMenu(
                                  key: dropdownKey,
                                  requestFocusOnTap: false,
                                  dropdownMenuEntries: dropdownUnit,
                                  onSelected: (value) {
                                    pickedUnit = AttributeUnit.values.firstWhere(
                                      (e) => e.toString() == 'AttributeUnit.${value!}',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    toolAttribVisible = true;
                    if (pickedTool != null && pickedUnit != null && pickedParameter != null && pickedSize != null) {
                      ToolAttribute pickedToolAttribute = ToolAttribute();
                      pickedToolAttribute.id = "";
                      pickedToolAttribute.tool = pickedTool!;
                      pickedToolAttribute.unit = pickedUnit;
                      pickedToolAttribute.size = pickedSize;
                      pickedToolAttribute.parameter = pickedParameter;
                      pickedToolAttribute.projectToolId = "";
                      createTool(pickedToolAttribute);
                    } else {
                      if (pickedTool != null) {
                        ToolAttribute pickedToolAttribute = ToolAttribute();
                        pickedToolAttribute.id = "";
                        pickedToolAttribute.tool = pickedTool!;
                        pickedToolAttribute.projectToolId = "";
                        createTool(pickedToolAttribute);
                      } else {
                        SsToaster.toast(
                          msg: "Fields cannot be empty",
                          type: ToastType.error,
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> createTool(ToolAttribute pickedToolAttribute) async {
    SsToaster.toast(msg: "Successfully created tool", type: ToastType.success, longTime: false);
    setState(() {
      saveVisible = true;
      listTools.add(GlobalKey<SsToolAttributeState>());
    });
    while (listTools.last.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() {
      listTools.last.currentState!.changeTools(pickedToolAttribute);
    });
  }

  Future<void> addYarn() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String? title;
            return AlertDialog(
              content: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SsTextButton(
                          text: "Search for yarn in database",
                          bgColor: Colors.amber,
                          onPressed: () {
                            SsToaster.toast(
                              msg: "Not implemented yet",
                              type: ToastType.warning,
                            );
                          },
                          textStyle: TextStyle(fontSize: 30),
                        ),
                        const Text(
                          "or",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 20, 2),
                                child: SsTextInput(
                                  text: "Title",
                                  style: const TextStyle(fontSize: 20),
                                  onChanged: (text) {
                                    title = text;
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: SsTextButton(
                                text: "Add manually",
                                bgColor: Colors.amber,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if (title != null) {
                                    createYarns(title!);
                                  } else {
                                    SsToaster.toast(
                                        msg: "Title cannot be empty", type: ToastType.warning, longTime: false);
                                  }
                                },
                                textStyle: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        )
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
  }

  Future<void> createYarns(String title) async {
    SsToaster.toast(msg: "Successfully created Yarn", type: ToastType.success, longTime: false);
    setState(() {
      saveVisible = true;
      listYarns.add(GlobalKey<SsYarnSectionState>());
    });
    while (listYarns.last.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() {
      listYarns.last.currentState!.changeTitle(title);
    });
  }

  void removeWidget(Key key) {
    if (listSections.contains(key)) {
      setState(() {
        listSections.remove(key);
        SsToaster.toast(msg: "Section deleted succesfully", type: ToastType.success, longTime: false);
      });
    } else if (listTools.contains(key)) {
      setState(() {
        listTools.remove(key);
        SsToaster.toast(msg: "Tool deleted succesfully", type: ToastType.success, longTime: false);
      });
    } else if (listYarns.contains(key)) {
      setState(() {
        listYarns.remove(key);
        SsToaster.toast(msg: "Yarn deleted succesfully", type: ToastType.success, longTime: false);
      });
    }
  }

  Future<void> saveProject() async {
    setState(() {
      saveVisible = false;
    });
    projectList = Project();
    projectList.title = projectName;
    projectList.description = projectDesc;
    for (var section in listSections) {
      ProjectSection projectSection = ProjectSection();
      projectSection.title = section.currentState!.sectionName;
      projectList.sections = [...projectList.sections, projectSection];
    }
    for (var tool in listTools) {
      ToolAttribute projectTool = ToolAttribute();
      projectTool = tool.currentState!.tool;
      projectList.tools = [...projectList.tools, projectTool];
    }
    for (var yarn in listYarns) {
      ProjectYarn projectYarn = ProjectYarn();
      projectYarn.title = yarn.currentState!.yarns.title;
      for (var yarnattrib in yarn.currentState!.listYarnAttributes) {
        projectYarn.attributes = [...projectYarn.attributes, yarnattrib.currentState!.yarn];
      }
      projectList.yarn = [...projectList.yarn, projectYarn];
    }
    projectService.saveProject(projectList, widget.id);
  }

  void fetchProject() async {
    Project? projectData = await projectService.fetchProjectData(widget.id);
    String name;
    String desc;
    if (projectData != null) {
      name = projectData.title!;
      desc = projectData.description!;
      setState(() {});
      for (var i = 0; i < projectData.sections.length; i++) {
        importVisible = false;
        listSections.add(GlobalKey<SsPatternSectionState>());
        setState(() {});
        while (listSections.last.currentState == null) {
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {});
        }
        listSections.last.currentState!.sectionName = projectData.sections[i].title!;
      }
      for (var i = 0; i < projectData.tools.length; i++) {
        importVisible = false;
        listTools.add(GlobalKey<SsToolAttributeState>());
        setState(() {});
        while (listTools.last.currentState == null) {
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {});
        }
        listTools.last.currentState!.tool = projectData.tools[i];
      }
      for (var i = 0; i < projectData.yarn.length; i++) {
        importVisible = false;
        listYarns.add(GlobalKey<SsYarnSectionState>());
        setState(() {});
        while (listYarns.last.currentState == null) {
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {});
        }
        listYarns.last.currentState!.yarns.title = projectData.yarn[i].title;
        for (var j = 0; j < projectData.yarn[i].attributes.length; j++) {
          importVisible = false;
          listYarns.last.currentState!.listYarnAttributes.add(GlobalKey<SsYarnAttributeState>());
          setState(() {});
          while (listYarns.last.currentState!.listYarnAttributes.last.currentState == null) {
            await Future.delayed(const Duration(milliseconds: 100));
            setState(() {});
          }
          listYarns.last.currentState!.listYarnAttributes.last.currentState!.yarn = projectData.yarn[i].attributes[j];
        }
      }
      projectName = name;
      projectDesc = desc;
      setState(() {});
    } else {
      projectName = "Untitiled";
      setState(() {});
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
        setState(() {
          projectName = text;
          saveVisible = true;
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
        setState(() {
          projectDesc = text;
          saveVisible = true;
        });
      } else {
        SsToaster.toast(
          msg: "Text cannot be empty",
          type: ToastType.error,
        );
      }
    });
  }

  createManually() {
    setState(() {
      importVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProject();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Create new project"),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SsNavBackBtn(),
                  const Text(
                    "Project title",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Container(height: 8),
                  SsEditableTextItem(
                    text: projectName,
                    onPressed: () async {
                      await updateProjectName();
                      setState(() {});
                    },
                  ),
                  Container(height: 32),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Container(height: 8),
                  SsEditableTextItem(
                    text: projectDesc,
                    onPressed: () async {
                      await updateProjectDesc();
                      setState(() {});
                    },
                  ),
                  Container(height: 32),
                  Visibility(
                    visible: importVisible,
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 16,
                      children: <Widget>[
                        const Text(
                          "Add Pattern",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SsTextButton(
                            text: "Import",
                            bgColor: Colors.amber,
                            onPressed: () {
                              SsToaster.toast(
                                msg: "Not implemented yet",
                                type: ToastType.warning,
                              );
                            }),
                        const Text(
                          "or",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SsTextButton(
                          text: "Create manually",
                          bgColor: Colors.amber,
                          onPressed: () {
                            createManually();
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !importVisible,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pattern section",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        ListView.builder(
                          itemCount: listSections.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SsPatternSection(
                                key: listSections[index],
                                text: '',
                                removePatternSection: (Key key) {
                                  removeWidget(key);
                                  saveVisible = true;
                                },
                              ),
                            );
                          },
                        ),
                        Container(height: 8),
                        SsAddNewButton(
                          onAddClick: () {
                            addSection();
                          },
                          text: "Add new section...",
                        ),
                        Container(height: 32),
                        const Text(
                          "Tools",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        ListView.builder(
                          itemCount: listTools.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SsToolAttribute(
                                key: listTools[index],
                                removeToolAttribute: (Key key) {
                                  removeWidget(key);
                                  saveVisible = true;
                                },
                              ),
                            );
                          },
                        ),
                        Container(height: 8),
                        SsAddNewButton(
                          onAddClick: () {
                            addTool();
                          },
                          text: "Add new tool...",
                        ),
                        Container(height: 32),
                        const Text(
                          "Yarn",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        ListView.builder(
                          itemCount: listYarns.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SsYarnSection(
                                key: listYarns[index],
                                removeYarnAttribute: (Key key) {
                                  removeWidget(key);
                                  setState(() {
                                    saveVisible = true;
                                  });
                                },
                                onChanged: () {
                                  setState(() {
                                    saveVisible = true;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        Container(height: 8),
                        SsAddNewButton(
                          onAddClick: () {
                            addYarn();
                          },
                          text: "Add new yarn...",
                        ),
                        Container(height: 32),
                        const Text(
                          "View pattern",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: SsTextButton(text: "CREATE", bgColor: Colors.pink, onPressed: () {}),
                            ),
                            Expanded(
                              flex: 3,
                              child: SsTextButton(text: "Cancel", bgColor: Colors.transparent, onPressed: () {}),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(),
                            )
                          ],
                        ),
                        Container(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Visibility(
            visible: saveVisible,
            child: FloatingActionButton(
              child: const Icon(Icons.save),
              onPressed: () {
                saveProject();
              },
            ),
          ),
        ),
        Visibility(
          visible: projectName == "",
          child: Expanded(
            child: Container(
              color: ThemeConfig.themeData.canvasColor,
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
        )
      ],
    );
  }
}
