import 'package:jwt_decode/jwt_decode.dart';
import 'package:stichsync/shared/models/context/user_claims_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client.auth;
  late Session? _session;

  // getters
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

  // public methods
  Future<bool> isAuthenticated() async {
    if (_session == null) return false;
    if (_session!.isExpired) await refreshSession();
    return true;
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
