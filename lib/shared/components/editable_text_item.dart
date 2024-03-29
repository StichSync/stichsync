import 'package:flutter/material.dart';

class EditableTextItem extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const EditableTextItem({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<EditableTextItem> createState() => _EditableTextItemState();
}

class _EditableTextItemState extends State<EditableTextItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const VerticalDivider(
              width: 2.0,
              color: Colors.grey,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
              ),
              onPressed: widget.onPressed,
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
