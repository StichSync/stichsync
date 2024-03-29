import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/attribute_input.dart';
import 'package:stichsync/shared/components/editable_avatar.dart';
import 'package:stichsync/shared/components/editable_text_item.dart';
import 'package:stichsync/shared/components/image_picker_util.dart';
import 'package:stichsync/shared/components/text_edit_dialog.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/constants/attribute.dart';
import 'package:stichsync/shared/enumerated/attribute_enums.dart';
import 'package:stichsync/shared/services/project_service.dart';

class PatternSection extends StatefulWidget {
  final void Function(Key key)? addPatternSection;
  final void Function(Key key)? removePatternSection;
  final void Function()? changed;
  final String? patternId;
  const PatternSection({super.key, this.addPatternSection, this.removePatternSection, this.changed, this.patternId});

  @override
  State<PatternSection> createState() => PatternSectionState();
}

class PatternSectionState extends State<PatternSection> {
  List<DatabaseAttributeClass> AttributesList = [];
  final projectService = GetIt.I<ProjectService>();
  List<GlobalKey<AttribInputState>> attributesKeys = [];
  String sectionName = "Section name";
  String descName = "Description";
  String SectionImage = "https://placehold.co/600x400/png";

  void addWidget() {
    setState(() {
      attributesKeys.add(GlobalKey<AttribInputState>());
      widget.changed?.call();
    });
  }

  void removeWidget(Key key) {
    setState(() {
      attributesKeys.remove(key);
      widget.changed?.call();
    });
  }

  Future<List<DatabaseAttributeClass>> getAttributes() async {
    AttributesList = [];
    for (var e in attributesKeys) {
      String unit =
          stringAttributeUnitMap.keys.firstWhere((ele) => stringAttributeUnitMap[ele] == e.currentState!.unit);

      double? quantity = double.tryParse(await e.currentState!.inputKey.currentState!.getText());

      AttributesList.add(
        DatabaseAttributeClass(e.currentState!.attribType, unit, quantity ?? 0),
      );
    }
    return Future.value(AttributesList);
  }

  Future<void> fetchAttributes(String patternId) async {
    List<Map<String, dynamic>>? response = await projectService.fetchAttributeData(patternId);
    if (response != null) {
      for (var i = 0; i < response.length; i++) {
        setState(() {
          attributesKeys.add(GlobalKey<AttribInputState>());
        });
      }
      for (var i = 0; i < response.length; i++) {
        while (
            attributesKeys[i].currentState == null || attributesKeys[i].currentState?.inputKey.currentState == null) {
          await Future.delayed(Duration(milliseconds: 100));
        }
        setState(() {
          attributesKeys[i].currentState!.attribType = response[i]["type"];
          attributesKeys[i].currentState!.assetDir = "${"/" + response[i]["type"]}.png";
          attributesKeys[i].currentState!.unit = stringAttributeUnitMap[response[i]["unit"]]!;
          attributesKeys[i].currentState!.amount = response[i]["quantity"];
          attributesKeys[i].currentState!.inputKey.currentState!.setText(response[i]["quantity"].toString());
        });
      }
    } else {}
  }

  Future<void> updateName() async {
    Future<String?> editedText = TextEditDialog(
      limit: 40,
      placeholder: "",
      title: 'Update section Name',
    ).show(context);
    editedText.then((text) async {
      if (text != "") {
        widget.changed?.call();
        Toaster.toast(
          msg: "Section name updated",
          type: ToastType.success,
        );
        setState(() {
          sectionName = text!;
        });
      } else {
        Toaster.toast(
          msg: "Section name cannot be empty",
          type: ToastType.warning,
        );
      }
    });
  }

  Future<void> updateDesc() async {
    Future<String?> editedText = TextEditDialog(
      limit: 250,
      placeholder: "",
      title: 'Update description',
    ).show(context);
    editedText.then((text) async {
      if (text != "") {
        widget.changed?.call();
        Toaster.toast(
          msg: "Description updated",
          type: ToastType.success,
        );
        setState(() {
          descName = text!;
        });
      } else {
        Toaster.toast(
          msg: "Description cannot be empty",
          type: ToastType.warning,
        );
      }
    });
  }

  Future<void> updateImage() async {
    final file = await ImagePickerUtil.pickImageFromGallery();
    print(file != null);
    if (file != null) {
      Toaster.toast(
        msg: "Image updated.",
        type: ToastType.success,
      );
      setState(() {
        SectionImage = file.path;
      });
    } else {
      Toaster.toast(
        msg: "Operation cancelled.",
        type: ToastType.message,
      );
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.addPatternSection != null
                  ? ElevatedButton.icon(
                      onPressed: () {
                        widget.addPatternSection?.call(widget.key!);
                      },
                      icon: Icon(Icons.add_circle_outline),
                      label: Text(""),
                    )
                  : Container(),
              EditableTextItem(
                text: sectionName,
                onPressed: () {
                  updateName();
                },
              ),
              EditableTextItem(
                text: descName,
                onPressed: () {
                  updateDesc();
                },
              ),
              EditableAvatar(
                radius: width * 0.8,
                square: true,
                imageUrl: SectionImage,
                onPressed: () => (updateImage()),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: attributesKeys.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      AttribInput(
                        key: attributesKeys[index],
                        addAttribute: (Key key) {
                          addWidget();
                        },
                        removeAttribute: (Key key) {
                          removeWidget(key);
                        },
                        changed: () {
                          widget.changed?.call();
                        },
                      ),
                    ],
                  );
                },
              ),
              widget.removePatternSection != null
                  ? ElevatedButton.icon(
                      onPressed: () {
                        widget.removePatternSection?.call(widget.key!);
                      },
                      icon: Icon(Icons.close_sharp),
                      label: Text(""),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
