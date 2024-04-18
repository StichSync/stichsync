import 'package:flutter/material.dart';
import 'package:stichsync/shared/models/db/dtos/yarn_attribute.dart';
import 'package:stichsync/shared/models/db/enums/attribute_parameter.dart';
import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';

class SsYarnAttribute extends StatefulWidget {
  final void Function(Key key)? removeYarnAttrbiute;
  final YarnAttribute? yarnAttribute;
  const SsYarnAttribute({
    super.key,
    this.removeYarnAttrbiute,
    this.yarnAttribute,
  });

  @override
  State<SsYarnAttribute> createState() => SsYarnAttributeState();
}

class SsYarnAttributeState extends State<SsYarnAttribute> {
  YarnAttribute yarn = YarnAttribute();

  @override
  void initState() {
    super.initState();
    if (widget.yarnAttribute != null) {
      setState(() {
        yarn = widget.yarnAttribute!;
      });
    } else {
      setState(() {
        yarn.parameter = AttributeParameter.length;
        yarn.quantity = 20;
        yarn.unit = AttributeUnit.kilogram;
      });
    }
  }

  changeAttribute(YarnAttribute yarnAttribute) {
    yarn = yarnAttribute;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                    child: Text(
                      yarn.parameter.toString().split(".")[1],
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blueAccent,
                    child: Text(
                      yarn.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blueAccent,
                    child: Text(
                      yarn.unit.toString().split(".")[1],
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                widget.removeYarnAttrbiute?.call(widget.key!);
              },
              icon: const Icon(Icons.remove),
            ),
          )
        ],
      ),
    );
  }
}
