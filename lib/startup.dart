import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/secrets.dart';
import 'package:stichsync/shared/services/account_service.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:stichsync/shared/services/project_service.dart';
import 'package:stichsync/views/home/inspirations/data_access/inspirations_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Startup {
  final GetIt getIt = GetIt.instance;

  Future<void> registerServices() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
      url: Secrets.supabaseUrl,
      anonKey: Secrets.supabaseKey,
    );

    // factories - their lifecycle is limited to lifetime of their parent (widget)
    // multiple instances allowed
    getIt.registerFactory<CrochetService>(() => CrochetService());

    // singletons - living since the moment of initialization until closing the whole app
    // each singleton is ensured to have only one instance
    getIt.registerLazySingleton<AuthService>(() => AuthService());
    getIt.registerLazySingleton<ProjectService>(() => ProjectService());
    getIt.registerLazySingleton<AccountService>(() => AccountService());
  }
}
