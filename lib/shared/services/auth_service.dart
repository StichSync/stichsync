import 'package:stichsync/shared/components/toaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// ignore: implementation_imports
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:universal_html/html.dart' as html;

class AuthService {
  final GoTrueClient _client = Supabase.instance.client.auth;
  late Session? _session;

  setSession(Session? session) => _session = session;
  Session? get getSession => _session;

  Future<bool> isAuthenticated() async {
    try {
      var refreshResult = (await _client.refreshSession());
      setSession(refreshResult.session);
      
    } catch (_) {
      return false;
    }
    return !_session!.isExpired;
  }
  
  Future<bool> register(email, password, username) async {
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username}
      );
      Toaster.toast(msg: "Account created, Please log in", type: ToastType.success, longTime: true);
      return true;
    } on AuthException catch (error) {
      Toaster.toast(msg: error.message, type: ToastType.error, longTime: true);
      return false;
    }
  }

  Future<bool> login(email, password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password
      );
      Toaster.toast(msg: "Successfully logged in", type: ToastType.success, longTime: true);
      return true;
    } on AuthException catch (error) {
      Toaster.toast(msg: error.message, type: ToastType.error, longTime: true);
      return false;
    }
  }
  
  Future<bool> forgotPassword(email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email, redirectTo: "http://localhost:56858/password-reset");
      Toaster.toast(msg: "Email with password reset had been sent", type: ToastType.success);
    } on AuthException catch (error) {
      Toaster.toast(msg: error.message, type: ToastType.error);
    } catch (error) {
      Toaster.toast(msg: error.toString(), type: ToastType.error);
    }
    return true;
  }

  Future<bool> resetPassword(password) async {
    List<String> urlSplit = Uri.base.toString().split("/");
    urlSplit.removeLast();
    try {
      await supabase.auth.updateUser(UserAttributes(password: password));
      Toaster.toast(msg: "Password had been reset", type: ToastType.success);
      html.window.history.pushState(null, "", "");
      
      return true;
    } on AuthException catch (error) {
      Toaster.toast(msg: error.message, type: ToastType.error);
    } catch (error) {
      Toaster.toast(msg: error.toString(), type: ToastType.error);
    }
    return false;
  }
}
