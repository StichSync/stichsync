import 'package:get_it/get_it.dart';
import 'package:stichsync/views/home/inspirations/data_access/crochet_service.dart';

class Startup {
  final GetIt getIt = GetIt.instance;

  void registerServices() {
    getIt.registerFactory<CrochetService>(() => CrochetService());
  }
}
