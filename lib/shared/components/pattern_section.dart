import 'package:flutter/material.dart';
import 'package:stichsync/shared/components/text_input.dart';

class PatternSection extends StatefulWidget {
  const PatternSection({
    super.key,
  });

  @override
  State<PatternSection> createState() => _PatternSectionState();
}

class _PatternSectionState extends State<PatternSection> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text("Nazwa bardzo epicka !")
      ],
    );
  }
}