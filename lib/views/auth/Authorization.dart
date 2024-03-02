import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/Toaster.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class Authorization extends StatefulWidget {
  const Authorization({super.key});

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final authService = GetIt.instance.get<AuthService>();

  void errorHandling(AuthException error){
    if (error.message == "Invalid login credentials"){
      Toaster.toast(msg: "Invalid e-mail or password", type: ToastType.error);
    } 
    else if (error.message == "Rate limit exceeded"){
      Toaster.toast(msg: "You're sending too much requests!", type: ToastType.warning);
    }
    else {
      Toaster.toast(msg: error.message, type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: Container()),
          Expanded(flex: 8, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SupaEmailAuth(
                  redirectTo: '',
                  onSignInComplete: (response) {Toaster.toast(msg: "Successfully logged in!", type: ToastType.success, longTime: false); authService.setSession(response.session!); Navigator.pushReplacementNamed(context, "");},
                  onSignUpComplete: (response) {Toaster.toast(msg: "Successfully signed in! Please login", type: ToastType.success); authService.setSession(response.session!); Navigator.pushReplacementNamed(context, "/Authorization");},
                  onError: (error) { errorHandling(error as AuthException); },
                  onPasswordResetEmailSent: () {Toaster.toast(msg: "Email with password reset had been sent", type: ToastType.success, longTime: true);},
                ),
                SupaSocialsAuth(
                  socialProviders: const [
                    OAuthProvider.google,
                    OAuthProvider.facebook,
                  ],
                  showSuccessSnackBar: false,
                  colored: true,
                  redirectUrl: '',
                  onSuccess: (Session response) { authService.setSession(response); },
                  onError: (error) {},
                )
              ],
            )
          ),
          Expanded(flex: 1, child: Container()),
        ],
      )
    );
  }
}