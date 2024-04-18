import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stichsync/shared/components/add_new_button.dart';
import 'package:stichsync/shared/components/text_input.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/components/yarn_attribute.dart';
import 'package:stichsync/shared/models/db/dtos/project_yarn.dart';
import 'package:stichsync/shared/models/db/dtos/yarn_attribute.dart';
import 'package:stichsync/shared/models/db/enums/attribute_parameter.dart';
import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';

class SsYarnSection extends StatefulWidget {
  final void Function(Key key)? removeYarnAttribute;
  final void Function()? onChanged;
  final ProjectYarn? projectYarn;
  const SsYarnSection({
    super.key,
    this.removeYarnAttribute,
    this.projectYarn,
    this.onChanged,
  });

  @override
  State<SsYarnSection> createState() => SsYarnSectionState();
}

class SsYarnSectionState extends State<SsYarnSection> {
  ProjectYarn yarns = ProjectYarn();
  List<GlobalKey<SsYarnAttributeState>> listYarnAttributes = [];
  List<DropdownMenuEntry<dynamic>> dropdownUnit =
      AttributeUnit.values.map((e) => e.name).toList().map<DropdownMenuEntry<String>>((String value) {
    return DropdownMenuEntry<String>(value: value, label: value);
  }).toList();

  @override
  void initState() {
    super.initState();
    if (widget.projectYarn != null) {
      setState(() {
        yarns = widget.projectYarn!;
      });
    } else {
      setState(() {
        yarns.attributes = [];
        yarns.title = "title";
      });
    }
  }

  changeTitle(String title) {
    yarns.title = title;
  }

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

  addYarnAttribute() {
    showDialog(
      context: context,
      builder: (context) {
        AttributeParameter? pickedParameter;
        double? pickedQuantity;
        AttributeUnit? pickedUnit;
        GlobalKey<SsTextInputState> quantityKey = GlobalKey<SsTextInputState>();
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
                        Column(
                          children: [
                            const Center(
                              child: Text(
                                "Enter quantity...",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(height: 8),
                            SsTextInput(
                              key: quantityKey,
                              text: "",
                              style: const TextStyle(fontSize: 20),
                              maxCharacters: 4,
                              onChanged: (text) {
                                if (double.tryParse(text) != null) {
                                  pickedQuantity = double.parse(text);
                                } else {
                                  SsToaster.toast(
                                    msg: "Put numbers only",
                                    type: ToastType.warning,
                                    longTime: false,
                                  );
                                  quantityKey.currentState!.setText(text.substring(0, text.length - 1));
                                }
                              },
                            ),
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
                    if (pickedParameter != null && pickedUnit != null && pickedQuantity != null) {
                      YarnAttribute pickedyarnAttribute = YarnAttribute();
                      pickedyarnAttribute.id = "";
                      pickedyarnAttribute.parameter = pickedParameter!;
                      pickedyarnAttribute.quantity = pickedQuantity!;
                      pickedyarnAttribute.unit = pickedUnit!;
                      pickedyarnAttribute.projectYarnId = "";
                      createYarn(pickedyarnAttribute);
                      widget.onChanged?.call();
                    } else {
                      SsToaster.toast(
                        msg: "Fields cannot be empty",
                        type: ToastType.error,
                      );
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

  createYarn(YarnAttribute yarnAttribute) async {
    SsToaster.toast(msg: "Successfully added attribute", type: ToastType.success, longTime: false);
    setState(() {
      listYarnAttributes.add(GlobalKey<SsYarnAttributeState>());
    });
    while (listYarnAttributes.last.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() {
      listYarnAttributes.last.currentState!.changeAttribute(yarnAttribute);
    });
  }

  removeYarnAttribute(Key key) {
    setState(() {
      listYarnAttributes.remove(key);
    });
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (92 + (56 * listYarnAttributes.length)).toDouble(),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              color: Colors.pink,
              child: Column(
                children: [
                  Text(
                    yarns.title!,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ListView.builder(
                    itemCount: listYarnAttributes.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: SsYarnAttribute(
                          key: listYarnAttributes[index],
                          removeYarnAttrbiute: (Key key) {
                            removeYarnAttribute(key);
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: SsAddNewButton(
                      onAddClick: () {
                        dropdownUnit = AttributeUnit.values
                            .map((e) => e.name)
                            .toList()
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(value: value, label: value);
                        }).toList();
                        addYarnAttribute();
                      },
                      text: "Add new yarn attribute...",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                widget.removeYarnAttribute?.call(widget.key!);
              },
              icon: const Icon(Icons.remove),
            ),
          )
        ],
      ),
    );
  }
}
