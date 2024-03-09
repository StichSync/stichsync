import 'package:flutter/material.dart';

class SsTextButton extends StatefulWidget {
  final String text;
  final Color bgColor;
  final Color? textColor;
  final Size? size;
  final void Function() onPressed;
  const SsTextButton({
    required this.text,
    required this.bgColor,
    required this.onPressed,
    this.textColor,
    this.size,
    super.key,
  });

  @override
  State<SsTextButton> createState() => _SsTextButtonState();
}

class _SsTextButtonState extends State<SsTextButton> {
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    if (widget.size == null){
      return Flexible(
        child: TextButton(
          onPressed: () {widget.onPressed.call();}, 
          style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(Size(width * 0.8, height * 0.07)), 
            backgroundColor: MaterialStateProperty.all<Color>(widget.bgColor), 
            foregroundColor: MaterialStateProperty.all<Color>(widget.textColor != null ? widget.textColor! : const Color.fromARGB(255, 82, 82, 82))), 
          child: Text(widget.text, style: TextStyle(fontSize: height * 0.035))
        )
      );
    }
    else{
      return SizedBox(
        width: widget.size!.width,
        height: widget.size!.height,
        child: TextButton(
          onPressed: () {widget.onPressed.call();}, 
          style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(widget.size!), 
            backgroundColor: MaterialStateProperty.all<Color>(widget.bgColor), 
            foregroundColor: MaterialStateProperty.all<Color>(widget.textColor != null ? widget.textColor! : const Color.fromARGB(255, 82, 82, 82))), 
          child: FittedBox(fit: BoxFit.fill, child: Text(widget.text))
        )
      );
    }
  }
}
