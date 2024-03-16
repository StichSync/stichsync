import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { warning, error, message, success }

class Toaster {
  static Future<bool?> toast({
    required String msg,
    required ToastType type,
    bool longTime = true,
  }) async {
    Color bgcolor;
    dynamic webBgcolor;
    Color textColor = Colors.white;
    switch (type) {
      case ToastType.warning:
        bgcolor = Colors.yellow;
        webBgcolor = "#ffeb3b";
        textColor = Colors.black;
      case ToastType.error:
        bgcolor = Colors.red;
        webBgcolor = "#f44336";
      case ToastType.message:
        bgcolor = Colors.lightBlue;
        webBgcolor = "#03a9f4";
      case ToastType.success:
        bgcolor = Colors.green;
        webBgcolor = "#4caf50";
    }
    return Fluttertoast.showToast(
      msg: msg,
      backgroundColor: bgcolor,
      webBgColor: webBgcolor,
      textColor: textColor,
      toastLength: longTime ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      timeInSecForIosWeb: longTime ? 5 : 1,
    );
  }
}
