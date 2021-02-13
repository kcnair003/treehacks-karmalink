import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {
  static final _instance = FirebaseFunctions.instance;

  static void _call(String functionName) async {
    HttpsCallable callable = _instance.httpsCallable(functionName);
    HttpsCallableResult result = await callable();
    print(result.data);
  }

  static const _test = 'function-1';

  static void test() => _call(_test);
}
