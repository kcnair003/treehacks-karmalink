import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  /// Invoke the cloud function that downloads user data.
  ///
  /// https://stackoverflow.com/questions/52824388/how-do-you-add-query-parameters-to-a-dart-http-request
  /// https://flutter.dev/docs/cookbook/networking/authenticated-requests
  Future<dynamic> callDownloadData() async {
    // var queryParameters = {
    //   'user_id': ProjectLevelData.user.uid,
    // };
    // var uri = Uri.https(
    //   'us-central1-hesprdev.cloudfunctions.net',
    //   '/KeywordExtractionAPI',
    //   // queryParameters,
    // );

    var url =
        'https://us-central1-hesprdev.cloudfunctions.net/KeywordExtractionAPI';

    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    print(responseJson);
    return responseJson;
  }
}
