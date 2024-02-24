import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/secrets.dart';
import 'package:stichsync/views/home/inspirations/data_access/crochet_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Startup {
  final GetIt getIt = GetIt.instance;

  Future<void> registerServices() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
      url: Secrets.supabaseUrl,
      anonKey: Secrets.supabaseKey,
    );

    getIt.registerFactory<CrochetService>(() => CrochetService());
  }
}
