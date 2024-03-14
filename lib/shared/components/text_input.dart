import 'package:flutter/material.dart';

class SsTextInput extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final IconData? icon;
  final Size? size;
  final bool isPassword;
  const SsTextInput({
    super.key,
    required this.text,
    this.style,
    this.icon,
    this.size,
    this.isPassword = false,
  });

  @override
  State<SsTextInput> createState() => SsTextInputState();
}

class SsTextInputState extends State<SsTextInput> {
  final TextEditingController _controller = TextEditingController();
  late bool isClosed;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    isClosed = widget.isPassword;
  }

  String getText() {
    return _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size?.width,
      height: widget.size?.height,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          label: Text(widget.text),
          suffixIcon: widget.isPassword ? IconButton(
            icon: Icon(isClosed ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                isClosed = !isClosed;
              });
            },
          ) : null
        ),
        style: widget.style,
        obscureText: isClosed ? true : false,
        enableSuggestions: isClosed ? false : true,
        autocorrect: isClosed ? false : true,
      )
    );
  }
}
