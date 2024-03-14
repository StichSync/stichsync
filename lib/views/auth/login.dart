import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/attribute_picker.dart';
import 'package:stichsync/shared/components/text_input.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authService = GetIt.instance.get<AuthService>();
  final GlobalKey<SsTextInputState> keyEmail = GlobalKey<SsTextInputState>();
  final GlobalKey<SsTextInputState> keyPass = GlobalKey<SsTextInputState>();

  Future<void> loginValidator() async {
    String email = keyEmail.currentState!.getText();
    String password = keyPass.currentState!.getText();

    if (email == "" || password == ""){
      Toaster.toast(msg: "Fill every space", type: ToastType.error);
    }
    else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)){
      Toaster.toast(msg: "E-mail is not valid", type: ToastType.error);
    }
    else {
      if(await authService.login(email, password)){
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, "/");
      }
    }
  }

  Future<void> forgotPassword() async {
    String email = keyEmail.currentState!.getText();
    if (email == ""){
      Toaster.toast(msg: "Fill E-mail input", type: ToastType.error);
    }
    else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)){
      Toaster.toast(msg: "E-mail is not valid", type: ToastType.error);
    }
    else{
      await authService.forgotPassword(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return AttribPicker();
  }
}