import 'package:flutter/material.dart';

class SsAddNewButton extends StatefulWidget {
  final void Function()? onAddClick;
  final String text;
  const SsAddNewButton({
    super.key,
    required this.onAddClick,
    required this.text,
  });

  @override
  State<SsAddNewButton> createState() => SsAddNewButtonState();
}

class SsAddNewButtonState extends State<SsAddNewButton> {
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
                  widget.text,
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
                widget.onAddClick?.call();
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
