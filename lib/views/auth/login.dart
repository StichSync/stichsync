import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/text_input.dart';
import 'package:stichsync/shared/components/text_button.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:stichsync/shared/services/router/router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

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

    if (email == "" || password == "") {
      Toaster.toast(msg: "Fill every space", type: ToastType.error);
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      Toaster.toast(msg: "E-mail is not valid", type: ToastType.error);
    } else {
      if (await authService.login(email, password)) {
        router.goNamed('home');
      }
    }
  }

  Future<void> forgotPassword() async {
    String email = keyEmail.currentState!.getText();
    if (email == "") {
      Toaster.toast(msg: "Fill E-mail input", type: ToastType.error);
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      Toaster.toast(msg: "E-mail is not valid", type: ToastType.error);
    } else {
      await authService.forgotPassword(email);
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
                  const Text("Login", style: TextStyle(fontSize: 50)),
                  SizedBox(
                      width: height * 0.4,
                      height: height * 0.4,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(300),
                          child: const Image(image: NetworkImage("https://i.imgur.com/pGXCsPs.png")))),
                  SsTextInput(key: keyEmail, size: Size(width * 0.8, height * 0.07), text: "E-mail", icon: Icons.mail),
                  SsTextInput(
                      key: keyPass,
                      isPassword: true,
                      size: Size(width * 0.8, height * 0.07),
                      text: "Password",
                      icon: Icons.lock),
                  Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                            text: "Forgor💀 password?",
                            style: const TextStyle(color: Colors.orange),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                forgotPassword();
                              }),
                      )),
                  SsTextButton(
                    text: "Log in",
                    bgColor: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {
                      loginValidator();
                    },
                  ),
                  Column(children: [
                    const Text(
                      "Don't have an account yet?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 82, 82, 82),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Sign Up",
                        style: const TextStyle(color: Colors.orange),
                        recognizer: TapGestureRecognizer()..onTap = () => router.goNamed('register'),
                      ),
                    )
                  ]),
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
                        onSuccess: (Session response) => router.goNamed('home'),
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
