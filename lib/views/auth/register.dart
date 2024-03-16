import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/text_input.dart';
import 'package:stichsync/shared/components/text_button.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final authService = GetIt.instance.get<AuthService>();
  final GlobalKey<SsTextInputState> keyUsername = GlobalKey<SsTextInputState>();
  final GlobalKey<SsTextInputState> keyEmail = GlobalKey<SsTextInputState>();
  final GlobalKey<SsTextInputState> keyPass = GlobalKey<SsTextInputState>();
  final GlobalKey<SsTextInputState> keyRPass = GlobalKey<SsTextInputState>();

  Future<void> registerValidator() async {
    String username = keyUsername.currentState!.getText();
    String email = keyEmail.currentState!.getText();
    String password = keyPass.currentState!.getText();
    String rPassword = keyRPass.currentState!.getText();
    if (username == "" || email == "" || password == "" || rPassword == "") {
      Toaster.toast(msg: "Fill every space", type: ToastType.error);
    } else if (password != rPassword) {
      Toaster.toast(msg: "The passwords are not the same", type: ToastType.error);
    } else if (password.length < 6) {
      Toaster.toast(msg: "Password must be at least 6 characters long", type: ToastType.error);
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      Toaster.toast(msg: "E-mail is not valid", type: ToastType.error);
    } else {
      if (await authService.register(email, password, username)) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, "/login");
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
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pushNamed(context, "/login");
                          },
                        ),
                      ),
                      const Text("Register", style: TextStyle(fontSize: 50)),
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
                                  "https://media.discordapp.net/attachments/864791833309085707/1214270526206255194/image.png?ex=65f8808d&is=65e60b8d&hm=b861929d04eebff70a738227bab4d4cf5ef6b030214e930bf7e392295d4973ae&=&format=webp&quality=lossless")))),
                  SsTextInput(
                      key: keyUsername, size: Size(width * 0.8, height * 0.07), text: "Username", icon: Icons.person),
                  SsTextInput(key: keyEmail, size: Size(width * 0.8, height * 0.07), text: "E-mail", icon: Icons.mail),
                  SsTextInput(
                      key: keyPass,
                      isPassword: true,
                      size: Size(width * 0.8, height * 0.07),
                      text: "Password",
                      icon: Icons.lock),
                  SsTextInput(
                      key: keyRPass,
                      isPassword: true,
                      size: Size(width * 0.8, height * 0.07),
                      text: "Repeat password",
                      icon: Icons.lock),
                  SsTextButton(
                    text: "Register",
                    bgColor: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {
                      registerValidator();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                    child: Column(children: [
                      SupaSocialsAuth(
                        socialProviders: const [
                          OAuthProvider.google,
                          OAuthProvider.facebook,
                        ],
                        socialButtonVariant: SocialButtonVariant.icon,
                        showSuccessSnackBar: false,
                        colored: true,
                        redirectUrl: '',
                        onSuccess: (Session response) {
                          Navigator.pushReplacementNamed(context, "");
                        },
                        onError: (error) {},
                      )
                    ]),
                  ),
                ],
              )),
          Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }
}
