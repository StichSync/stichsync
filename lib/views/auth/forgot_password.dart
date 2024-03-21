import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/text_input.dart';
import 'package:stichsync/shared/components/text_button.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:stichsync/shared/services/router/router.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final authService = GetIt.instance.get<AuthService>();
  final GlobalKey<SsTextInputState> keyPass = GlobalKey<SsTextInputState>();
  final GlobalKey<SsTextInputState> keyRPass = GlobalKey<SsTextInputState>();

  Future<void> forgotPassword() async {
    String password = keyPass.currentState!.getText();
    String rPassword = keyRPass.currentState!.getText();
    if (password == "" || rPassword == "") {
      Toaster.toast(msg: "Fill every space", type: ToastType.error);
    } else if (password != rPassword) {
      Toaster.toast(msg: "The passwords are not the same", type: ToastType.error);
    } else if (password.length < 6) {
      Toaster.toast(msg: "Password must be at least 6 characters long", type: ToastType.error);
    } else {
      if (await authService.resetPassword(password) && context.mounted) {
        router.goNamed('login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: Container()),
          Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.1,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                          onPressed: () => router.goNamed('login'),
                        ),
                      ),
                      const Text("Password reset", style: TextStyle(fontSize: 50)),
                      SizedBox(
                        width: width * 0.1,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: height * 0.4,
                    height: height * 0.4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(300),
                      child: const Image(
                        image: NetworkImage(
                            "https://media.discordapp.net/attachments/864791833309085707/1214270526206255194/image.png?ex=65f8808d&is=65e60b8d&hm=b861929d04eebff70a738227bab4d4cf5ef6b030214e930bf7e392295d4973ae&=&format=webp&quality=lossless"),
                      ),
                    ),
                  ),
                  SsTextInput(
                    key: keyPass,
                    isPassword: true,
                    size: Size(
                      width * 0.8,
                      height * 0.07,
                    ),
                    text: "Password",
                    icon: Icons.lock,
                  ),
                  SsTextInput(
                    key: keyRPass,
                    isPassword: true,
                    size: Size(
                      width * 0.8,
                      height * 0.07,
                    ),
                    text: "Repeat password",
                    icon: Icons.lock,
                  ),
                  SsTextButton(
                    text: "Change password",
                    bgColor: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {
                      forgotPassword();
                    },
                  ),
                  SizedBox(
                    width: 15,
                    height: height * 0.18,
                  )
                ],
              )),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
