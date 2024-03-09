import 'package:jwt_decode/jwt_decode.dart';
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

  Session get session {
    if (_session == null) throw Exception("Could not get user session");
    return _session!;
  }

  UserClaims get claims {
    final tokenClaims = Jwt.parseJwt(session.accessToken);
    return UserClaims(tokenClaims: tokenClaims);
  }

  // setters
  void setSession(Session? session) {
    if (session == null) return;
    if (session.isExpired) return;
    _session = session;
  }

  Future<bool> isAuthenticated() async {
    if (_session == null) return false;
    if (_session!.isExpired) await refreshSession();
    return true;
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
      await supabase.auth.resetPasswordForEmail(email, redirectTo: "http://localhost:63171/password-reset");
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
  
  Future<bool> logout() async {
    try {
      await _client.signOut();
      setSession(null);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Session> refreshSession() async {
    var refreshed = await _client.refreshSession();
    if (refreshed.session == null) logout();
    setSession(refreshed.session!);
    return refreshed.session!;
  }
}
