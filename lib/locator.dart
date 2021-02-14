import 'package:get_it/get_it.dart';
import 'services/services.dart';

export 'services/src/firebase_auth_service.dart';
export 'services/src/pagination.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => Pagination());
  locator.registerLazySingleton(() => FirebaseAuthService());
}
