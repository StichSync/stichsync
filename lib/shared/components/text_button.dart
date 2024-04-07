import 'package:flutter/material.dart';

class SsTextButton extends StatefulWidget {
  final String text;
  final Color bgColor;
  final Color? textColor;
  final void Function() onPressed;
  final TextStyle? textStyle;
  const SsTextButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.onPressed,
    this.textColor,
    this.textStyle,
  });

  @override
  State<SsTextButton> createState() => _SsTextButtonState();
}

class _SsTextButtonState extends State<SsTextButton> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return TextButton(
      onPressed: () {
        widget.onPressed.call();
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(width * 0.8, height * 0.07)),
        backgroundColor: MaterialStateProperty.all<Color>(widget.bgColor),
        foregroundColor: MaterialStateProperty.all<Color>(
          widget.textColor != null ? widget.textColor! : const Color.fromARGB(255, 82, 82, 82),
        ),
      ),
      child: Text(
        widget.text,
        style: widget.textStyle ?? TextStyle(fontSize: height * 0.035),
      ),
    );
  }
}
