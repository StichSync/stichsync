import 'package:jwt_decode/jwt_decode.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/models/context/user_claims_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client.auth;

  // getters
  Session? get session => _client.currentSession;

  Future<bool> get isAuthenticated async {
    if (session == null) return false;
    if (session!.isExpired) await _client.refreshSession();
    return session != null && !session!.isExpired;
  }

  UserClaims? get claims {
    if (session == null) return null;
    final tokenClaims = Jwt.parseJwt(session!.accessToken);
    return UserClaims(tokenClaims: tokenClaims);
  }

  Future<bool> register(
    email,
    password,
    username,
  ) async {
    try {
      await _client.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
        },
      );
      SsToaster.toast(msg: "Account created, Please log in", type: ToastType.success, longTime: true);
      return true;
    } on AuthException catch (error) {
      SsToaster.toast(
        msg: error.message,
        type: ToastType.error,
        longTime: true,
      );
      return false;
    }
  }

  Future<bool> login(email, password) async {
    try {
      await _client.signInWithPassword(
        email: email,
        password: password,
      );
      SsToaster.toast(
        msg: "Successfully logged in",
        type: ToastType.success,
        longTime: true,
      );
      return true;
    } on AuthException catch (error) {
      SsToaster.toast(
        msg: error.message,
        type: ToastType.error,
        longTime: true,
      );
      return false;
    }
  }

  Future<bool> forgotPassword(email) async {
    try {
      await _client.resetPasswordForEmail(
        email,
        redirectTo: "/resetPassword", // todo: determine redirect link based on users current platform
      );
      SsToaster.toast(
        msg: "Email with password reset had been sent",
        type: ToastType.success,
      );
    } on AuthException catch (error) {
      SsToaster.toast(
        msg: error.message,
        type: ToastType.error,
      );
    } catch (error) {
      SsToaster.toast(
        msg: error.toString(),
        type: ToastType.error,
      );
    }
    return true;
  }

  Future<bool> resetPassword(password) async {
    List<String> urlSplit = Uri.base.toString().split("/");
    urlSplit.removeLast();
    try {
      await _client.updateUser(
        UserAttributes(password: password),
      );
      SsToaster.toast(
        msg: "Password had been reset",
        type: ToastType.success,
      );

      return true;
    } on AuthException catch (error) {
      SsToaster.toast(
        msg: error.message,
        type: ToastType.error,
      );
    } catch (error) {
      SsToaster.toast(
        msg: error.toString(),
        type: ToastType.error,
      );
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await _client.signOut();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Session> refreshSession() async {
    var refreshed = await _client.refreshSession();
    if (refreshed.session == null) logout();
    return refreshed.session!;
  }
}
