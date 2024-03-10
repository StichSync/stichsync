import 'package:stichsync/shared/functions/unix_to_date_time.dart';

class UserClaims {
  UserClaims({required Map<String, dynamic> tokenClaims}) {
    iat = unixToDateTime(tokenClaims['iat'] as int);
    exp = unixToDateTime(tokenClaims['exp'] as int);
    email = tokenClaims['email'];
    applicationRole = tokenClaims['app_metadata']['applicationRole'];
  }

  late DateTime iat;
  late DateTime exp;
  late String applicationRole;
  late String email;
}
