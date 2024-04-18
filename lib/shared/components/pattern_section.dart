import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/services/project_service.dart';

// ignore: must_be_immutable
class SsPatternSection extends StatefulWidget {
  final void Function(Key key)? removePatternSection;
  final void Function()? addPatternSection;
  final String? patternId;
  final String text;
  bool? isAdding = false;
  SsPatternSection({
    super.key,
    this.removePatternSection,
    this.addPatternSection,
    this.patternId,
    this.isAdding,
    required this.text,
  });

  @override
  State<SsPatternSection> createState() => SsPatternSectionState();
}

class SsPatternSectionState extends State<SsPatternSection> {
  final projectService = GetIt.I<ProjectService>();
  String sectionName = "";

  void initState() {
    super.initState();
    setState(() {
      sectionName = widget.text;
    });
  }

  changeName(String text) {
    sectionName = text;
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
            child: Container(
              color: Colors.indigo,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  sectionName,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                if (widget.isAdding == true) {
                  widget.addPatternSection?.call();
                } else {
                  widget.removePatternSection?.call(widget.key!);
                }
              },
              icon: widget.isAdding == true ? const Icon(Icons.add) : const Icon(Icons.remove),
            ),
          )
        ],
      ),
    );
  }
}
