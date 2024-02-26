import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<bool> register(
    String email,
    String password,
  ) async {
    try {
      await _client.signUp(
        email: email,
        password: password,
      );
      var session = _client.currentSession;
      setSession(session);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    try {
      await _client.signInWithPassword(
        email: email,
        password: password,
      );
      var session = _client.currentSession;
      setSession(session);
      return true;
    } catch (_) {
      return false;
    }
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
}
