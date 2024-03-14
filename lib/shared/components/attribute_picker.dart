import 'package:flutter/material.dart';
import 'package:stichsync/shared/components/text_input.dart';
import 'package:stichsync/shared/constants/attribute_input.dart';

enum AttribInputType {type, unit, quantity}
String asset = "assets/thickness.png";
double amount = 10;
String unit = "mm";

class AttribPicker extends StatefulWidget {
  const AttribPicker({
    super.key,
  });

  @override
  State<AttribPicker> createState() => _AttribPickerState();
}

class _AttribPickerState extends State<AttribPicker> {

  void pressed(AttribInputType type, bool up) {
    setState(() {
      List<String> lenghtUnits = ShortLengthUnit.values.map((e) => e.name).toList();
      List<String> weightUnits = ShortWeightUnit.values.map((e) => e.name).toList();
      List<String> types = AttributeType.values.map((e) => e.name).toList();
      List<String> lenghtTypes = LengthAttributeType.values.map((e) => e.name).toList();
      switch (type) {
        case AttribInputType.type:
          String name = asset.split("/")[1].split(".")[0];
          if (up){
            if (types.indexOf(name) + 1 < types.length){
              asset = "assets/${types[types.indexOf(name) + 1].toString()}.png";
            }
            else{
              asset = "assets/thickness.png";
              name = "thickness";
            }
          }
          else{
            if (types.indexOf(name) != 0){
              asset = "assets/${types[types.indexOf(name) - 1].toString()}.png";
            }
            else{
              asset = "assets/height.png";
              name = "height";
            }
          }
          name = asset.split("/")[1].split(".")[0];
          if (lenghtTypes.contains(name)){
            if (!lenghtUnits.contains(unit)){
              unit = lenghtUnits[0];
            }
          }
          else{
            if (!weightUnits.contains(unit)){
              unit = weightUnits[0];
            }
          }
          break;
        case AttribInputType.unit:
          if (up){
            if (lenghtUnits.contains(unit)){
              if (lenghtUnits.indexOf(unit) + 1 < lenghtUnits.length){
                unit = lenghtUnits[lenghtUnits.indexOf(unit) + 1];
              }
              else{
                unit = "mm";
              }
            }
            else{
              if (weightUnits.indexOf(unit) + 1 < weightUnits.length){
                unit = weightUnits[weightUnits.indexOf(unit) + 1];
              }
              else{
                unit = "g";
              }
            }
          }
          else{
            if (lenghtUnits.contains(unit)){
              if (lenghtUnits.indexOf(unit) != 0){
                unit = lenghtUnits[lenghtUnits.indexOf(unit) - 1];
              }
              else{
                unit = "yd";
              }
            }
            else{
              if (weightUnits.indexOf(unit) != 0){
                unit = weightUnits[weightUnits.indexOf(unit) - 1];
              }
              else{
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: width * 0.32, 
          height: width * 0.19, 
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent)
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: Image(image: AssetImage(asset))),
                Expanded(
                  flex: 2, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () {pressed(AttribInputType.type, true);}, icon: Icon(Icons.arrow_drop_up_sharp), label: Text("")))]),
                      Container(height: width * 0.01),
                      Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () {pressed(AttribInputType.type, false);}, icon: Icon(Icons.arrow_drop_down_sharp), label: Text("")))]),
                    ],
                  )
                )
              ],
            )
          )
        ),
        SizedBox(
          width: width * 0.32, 
          height: width * 0.19, 
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent)
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: Center( child: Text(unit, style: TextStyle(fontSize: (width * 0.09))))),
                Expanded(
                  flex: 2, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () {pressed(AttribInputType.unit, true);}, icon: Icon(Icons.arrow_drop_up_sharp), label: Text("")))]),
                      Container(height: width * 0.01),
                      Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () {pressed(AttribInputType.unit, false);}, icon: Icon(Icons.arrow_drop_down_sharp), label: Text("")))]),
                    ],
                  )
                )
              ],
            )
          )
        ),
        SizedBox(
          width: width * 0.32, 
          height: width * 0.19, 
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent)
            ),
            child: Scaffold(body: Center(child: SsTextInput(text: "", style: TextStyle(fontSize: width * 0.07))))
          )
        ),
      ],
    );
  }
}