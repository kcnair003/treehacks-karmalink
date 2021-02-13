import 'package:cloud_functions/cloud_functions.dart';

class FunctionNames {
  static final helloWorld = 'KeywordExtractionAPI';
}

class CloudFunctionsService {
  void call(String functionName) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      functionName,
    );
    dynamic resp = await callable.call();
    print(resp);
  }
}
