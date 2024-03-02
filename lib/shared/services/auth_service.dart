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
