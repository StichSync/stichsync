import 'package:flutter/material.dart';
import 'package:stichsync/shared/models/db/dtos/tool_attribute.dart';
import 'package:stichsync/shared/models/db/enums/attribute_parameter.dart';
import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';
import 'package:stichsync/shared/models/db/enums/tool.dart';

class SsToolAttribute extends StatefulWidget {
  final void Function(Key key)? removeToolAttribute;
  final ToolAttribute? toolAttribute;
  const SsToolAttribute({
    super.key,
    this.removeToolAttribute,
    this.toolAttribute,
  });

  @override
  State<SsToolAttribute> createState() => SsToolAttributeState();
}

class SsToolAttributeState extends State<SsToolAttribute> {
  ToolAttribute tool = ToolAttribute();

  @override
  void initState() {
    super.initState();
    if (widget.toolAttribute != null) {
      setState(() {
        tool = widget.toolAttribute!;
      });
    } else {
      setState(() {
        tool.size = 20;
        tool.tool = Tool.hook;
        tool.unit = AttributeUnit.foot;
        tool.parameter = AttributeParameter.length;
      });
    }
  }

  changeTools(ToolAttribute toolAttribute) {
    tool = toolAttribute;
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
                      tool.tool.toString().split(".")[1],
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                tool.size != null
                    ? Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.blueAccent,
                          child: Text(
                            tool.parameter.toString().split(".")[1],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                tool.size != null
                    ? Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.blueAccent,
                          child: Text(
                            tool.size.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                tool.size != null
                    ? Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.blueAccent,
                          child: Text(
                            tool.unit.toString().split(".")[1],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                widget.removeToolAttribute?.call(widget.key!);
              },
              icon: const Icon(Icons.remove),
            ),
          )
        ],
      ),
    );
  }
}
