import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stichsync/shared/components/text_input.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/enumerated/attribute_enums.dart';

enum AttribInputType { type, unit, quantity }

class AttribInput extends StatefulWidget {
  final void Function(Key key)? addAttribute;
  final void Function(Key key)? removeAttribute;
  final void Function()? changed;
  bool? readOnly = false;
  AttribInput({super.key, this.addAttribute, this.removeAttribute, this.changed, this.readOnly});

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
    widget.changed?.call();
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
          double value = double.parse(inputKey.currentState!.getText());
          if (up) {
            if (value < 9999) {
              inputKey.currentState!.setText((value + 1).toString());
            } else {
              inputKey.currentState!.setText("9999");
              Toaster.toast(msg: "Can't set more than 9999", type: ToastType.message, longTime: false);
            }
          } else {
            if (value > 0) {
              inputKey.currentState!.setText((value - 1).toString());
            } else {
              inputKey.currentState!.setText("0");
              Toaster.toast(msg: "Can't set less than 0", type: ToastType.message, longTime: false);
            }
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent, width: 5),
        ),
        child: Column(
          children: [
            widget.addAttribute != null
                ? ElevatedButton.icon(
                    onPressed: () {
                      widget.addAttribute?.call(widget.key!);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text(""),
                  )
                : Container(),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(
                          image: AssetImage(assetDir),
                          width: width * 0.2,
                        ),
                        Container(height: width * 0.2),
                        widget.readOnly == true
                            ? Container()
                            : Column(
                                children: [
                                  SizedBox(
                                    width: width * 0.08,
                                    height: width * 0.05,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                      child: IconButton.filled(
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          pressed(AttribInputType.type, true);
                                        },
                                        icon: Icon(Icons.arrow_drop_up_sharp, size: width * 0.05),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.08,
                                    height: width * 0.05,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                      child: IconButton.filled(
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          pressed(AttribInputType.type, false);
                                        },
                                        icon: Icon(Icons.arrow_drop_down_sharp, size: width * 0.05),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(height: width * 0.2),
                        Container(height: width * 0.2),
                        Container(
                          child: Text(
                            unit,
                            style: TextStyle(
                              fontSize: (width * 0.09),
                            ),
                          ),
                        ),
                        Container(height: width * 0.2),
                        widget.readOnly == true
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width * 0.08,
                                    height: width * 0.05,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                      child: IconButton.filled(
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          pressed(AttribInputType.unit, true);
                                        },
                                        icon: Icon(Icons.arrow_drop_up_sharp, size: width * 0.05),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.08,
                                    height: width * 0.05,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                      child: IconButton.filled(
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          pressed(AttribInputType.unit, false);
                                        },
                                        icon: Icon(Icons.arrow_drop_down_sharp, size: width * 0.05),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: width * 0.203,
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width * 0.2,
                          child: Scaffold(
                            body: widget.readOnly == true
                                ? Center(
                                    child: Text(
                                      amount.toString(),
                                      style: TextStyle(fontSize: width * 0.09),
                                    ),
                                  )
                                : SsTextInput(
                                    onChanged: (String text) {
                                      widget.changed?.call();
                                      if (double.parse(text) < 1) {
                                        inputKey.currentState!.setText(double.parse(text).abs().toString());
                                      }
                                    },
                                    maxCharacters: 4,
                                    style: TextStyle(
                                      fontSize: width * 0.083,
                                    ),
                                    key: inputKey,
                                    text: "",
                                  ),
                          ),
                        ),
                        Container(height: width * 0.2),
                        widget.readOnly == true
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width * 0.08,
                                    height: width * 0.05,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                      child: IconButton.filled(
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          pressed(AttribInputType.quantity, true);
                                        },
                                        icon: Icon(Icons.arrow_drop_up_sharp, size: width * 0.05),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.08,
                                    height: width * 0.05,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                      child: IconButton.filled(
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          pressed(AttribInputType.quantity, false);
                                        },
                                        icon: Icon(Icons.arrow_drop_down_sharp, size: width * 0.05),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            widget.removeAttribute != null
                ? ElevatedButton.icon(
                    onPressed: () {
                      widget.removeAttribute?.call(widget.key!);
                    },
                    icon: const Icon(Icons.close_sharp),
                    label: const Text(""),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
