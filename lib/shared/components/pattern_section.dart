import 'dart:async';
import 'package:flutter/material.dart';
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

class SsPatternSection extends StatefulWidget {
  final void Function(Key key)? addPatternSection;
  final void Function(Key key)? removePatternSection;
  final void Function()? changed;
  final String? patternId;
  const SsPatternSection({super.key, this.addPatternSection, this.removePatternSection, this.changed, this.patternId});

  @override
  State<SsPatternSection> createState() => SsPatternSectionState();
}

class SsPatternSectionState extends State<SsPatternSection> {
  List<DatabaseAttributeClass> attributesList = [];
  final projectService = GetIt.I<ProjectService>();
  List<GlobalKey<SsAttribInputState>> attributesKeys = [];
  String sectionName = "Section name";
  String descName = "Description";
  String sectionImage = "https://placehold.co/600x400/png";

  void addWidget() {
    setState(() {
      attributesKeys.add(GlobalKey<SsAttribInputState>());
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
    attributesList = [];
    for (var e in attributesKeys) {
      String unit =
          stringAttributeUnitMap.keys.firstWhere((ele) => stringAttributeUnitMap[ele] == e.currentState!.unit);

      double? quantity = double.tryParse(e.currentState!.inputKey.currentState!.getText());

      attributesList.add(
        DatabaseAttributeClass(e.currentState!.attribType, unit, quantity ?? 0),
      );
    }
    return Future.value(attributesList);
  }

  Future<void> fetchAttributes(String patternId) async {
    List<Map<String, dynamic>>? response = await projectService.fetchAttributeData(patternId);
    if (response != null) {
      for (var i = 0; i < response.length; i++) {
        setState(() {
          attributesKeys.add(GlobalKey<SsAttribInputState>());
        });
      }
      for (var i = 0; i < response.length; i++) {
        while (
            attributesKeys[i].currentState == null || attributesKeys[i].currentState?.inputKey.currentState == null) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        setState(() {
          attributesKeys[i].currentState!.attribType = response[i]["type"];
          attributesKeys[i].currentState!.assetDir = "${"/${response[i]["type"]}"}.png";
          attributesKeys[i].currentState!.unit = stringAttributeUnitMap[response[i]["unit"]]!;
          attributesKeys[i].currentState!.amount = response[i]["quantity"];
          attributesKeys[i].currentState!.inputKey.currentState!.setText(response[i]["quantity"].toString());
        });
      }
    } else {}
  }

  Future<void> updateName() async {
    Future<String?> editedText = SsTextEditDialog(
      limit: 40,
      placeholder: "",
      title: 'Update section Name',
    ).show(context);
    editedText.then((text) async {
      if (text != "") {
        widget.changed?.call();
        SsToaster.toast(
          msg: "Section name updated",
          type: ToastType.success,
        );
        setState(() {
          sectionName = text!;
        });
      } else {
        SsToaster.toast(
          msg: "Section name cannot be empty",
          type: ToastType.warning,
        );
      }
    });
  }

  Future<void> updateDesc() async {
    Future<String?> editedText = SsTextEditDialog(
      limit: 250,
      placeholder: "",
      title: 'Update description',
    ).show(context);
    editedText.then((text) async {
      if (text != "") {
        widget.changed?.call();
        SsToaster.toast(
          msg: "Description updated",
          type: ToastType.success,
        );
        setState(() {
          descName = text!;
        });
      } else {
        SsToaster.toast(
          msg: "Description cannot be empty",
          type: ToastType.warning,
        );
      }
    });
  }

  Future<void> updateImage() async {
    final file = await ImagePickerUtil.pickImageFromGallery();
    if (file != null) {
      SsToaster.toast(
        msg: "Image updated.",
        type: ToastType.success,
      );
      setState(() {
        sectionImage = file.path;
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
    double width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.all(16.0),
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
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text(""),
                    )
                  : Container(),
              SsEditableTextItem(
                text: sectionName,
                onPressed: () {
                  updateName();
                },
              ),
              SsEditableTextItem(
                text: descName,
                onPressed: () {
                  updateDesc();
                },
              ),
              SsEditableAvatar(
                radius: width * 0.8,
                square: true,
                imageUrl: sectionImage,
                onPressed: () => (updateImage()),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: attributesKeys.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SsAttribInput(
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
                      icon: const Icon(Icons.close_sharp),
                      label: const Text(""),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
