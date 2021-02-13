import 'services/firestore_service.dart';
import 'package:get_it/get_it.dart';
import 'services/guided_journal_service.dart';
import 'services/http_service.dart';
import 'services/dialogflow_service.dart';
import 'services/cloud_functions_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => GuidedJournalService());
  locator.registerLazySingleton(() => HttpService());
  locator.registerLazySingleton(() => DialogflowService());
  locator.registerLazySingleton(() => CloudFunctionsService());
}
