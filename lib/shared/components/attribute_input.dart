import 'package:flutter/material.dart';
import 'package:stichsync/shared/components/text_input.dart';
import 'package:stichsync/shared/constants/attribute.dart';
import 'package:stichsync/shared/enumerated/attribute_enums.dart';

enum AttribInputType { type, unit, quantity }

class AttribInput extends StatefulWidget {
  final void Function(Key key) addAttribute;
  final void Function(Key key) removeAttribute;
  const AttribInput({super.key, required this.addAttribute, required this.removeAttribute});

  @override
  State<AttribInput> createState() => AttribInputState();
}

// HOW TO USE
// Pass addAttribute and removeAttribute function and create new AttribInput on addAttribute. On removeAttribute remove this AttribInput by key

class AttribInputState extends State<AttribInput> {
  final GlobalKey<SsTextInputState> inputKey = GlobalKey<SsTextInputState>();
  String assetDir = "/thickness.png";
  String attribType = "thickness";
  double amount = 10;
  String unit = "mm";

  void pressed(AttribInputType type, bool up) {
    setState(() {
      List<String> lenghtUnits = ShortLengthUnit.values.map((e) => e.name).toList();
      List<String> weightUnits = ShortWeightUnit.values.map((e) => e.name).toList();
      List<String> types = AttributeType.values.map((e) => e.name).toList();
      List<String> lenghtTypes = LengthAttributeType.values.map((e) => e.name).toList();
      switch (type) {
        case AttribInputType.type:
          String name = assetDir.split("/")[1].split(".")[0];
          if (up) {
            if (types.indexOf(name) + 1 < types.length) {
              assetDir = "/${types[types.indexOf(name) + 1].toString()}.png";
            } else {
              assetDir = "/thickness.png";
            }
          } else {
            if (types.indexOf(name) != 0) {
              assetDir = "/${types[types.indexOf(name) - 1].toString()}.png";
            } else {
              assetDir = "/height.png";
            }
          }
          name = assetDir.split("/")[1].split(".")[0];
          attribType = name;
          if (lenghtTypes.contains(name)) {
            if (!lenghtUnits.contains(unit)) {
              unit = lenghtUnits[0];
            }
          } else {
            if (!weightUnits.contains(unit)) {
              unit = weightUnits[0];
            }
          }
          break;
        case AttribInputType.unit:
          if (up) {
            if (lenghtUnits.contains(unit)) {
              if (lenghtUnits.indexOf(unit) + 1 < lenghtUnits.length) {
                unit = lenghtUnits[lenghtUnits.indexOf(unit) + 1];
              } else {
                unit = "mm";
              }
            } else {
              if (weightUnits.indexOf(unit) + 1 < weightUnits.length) {
                unit = weightUnits[weightUnits.indexOf(unit) + 1];
              } else {
                unit = "g";
              }
            }
          } else {
            if (lenghtUnits.contains(unit)) {
              if (lenghtUnits.indexOf(unit) != 0) {
                unit = lenghtUnits[lenghtUnits.indexOf(unit) - 1];
              } else {
                unit = "yd";
              }
            } else {
              if (weightUnits.indexOf(unit) != 0) {
                unit = weightUnits[weightUnits.indexOf(unit) - 1];
              } else {
                unit = "lb";
              }
            }
          }
          break;
        case AttribInputType.quantity:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent, width: 5),
        ),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                widget.addAttribute.call(widget.key!);
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text(""),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width * 0.32,
                  height: width * 0.19,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Image(image: AssetImage(assetDir))),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        pressed(AttribInputType.type, true);
                                      },
                                      icon: const Icon(Icons.arrow_drop_up_sharp),
                                      label: const Text(""),
                                    ),
                                  )
                                ],
                              ),
                              Container(height: width * 0.01),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        pressed(AttribInputType.type, false);
                                      },
                                      icon: const Icon(Icons.arrow_drop_down_sharp),
                                      label: const Text(""),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.32,
                  height: width * 0.19,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              unit,
                              style: TextStyle(
                                fontSize: (width * 0.09),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        pressed(AttribInputType.unit, true);
                                      },
                                      icon: const Icon(Icons.arrow_drop_up_sharp),
                                      label: const Text(""),
                                    ),
                                  )
                                ],
                              ),
                              Container(height: width * 0.01),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        pressed(AttribInputType.unit, false);
                                      },
                                      icon: const Icon(Icons.arrow_drop_down_sharp),
                                      label: const Text(""),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.32,
                  height: width * 0.19,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    child: Scaffold(
                      body: Center(
                        child: SsTextInput(
                          key: inputKey,
                          text: "",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                widget.removeAttribute(widget.key!);
              },
              icon: const Icon(Icons.close_sharp),
              label: const Text(""),
            ),
          ],
        ),
      ),
    );
  }
}
