import 'package:googleapis/dialogflow/v2.dart';
import 'package:googleapis_auth/auth_io.dart';

class DialogflowService {
  DialogflowApi _dialogflow;

  /// Call this at the beginning of every method that may need it.
  Future init() async {
    if (_dialogflow != null) return;

    final _credentials = new ServiceAccountCredentials.fromJson(
      r'''
      {
        "type": "service_account",
        "project_id": "hesprbot-ltmm",
        "private_key_id": "705cb327a6eeea4b9073e126be1eef2e18dc93ed",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDhuF6O/QoFwkJK\n2+ZK1n/zPeXRC3ry6fYLadm2ZggPcORjril7NbYXefhOFhb7buo0HSMW6oMIc0bQ\n7W66xwllLiM4wKZVT/expd746pnTDqYgRLoXng7zgR8u3K1B7TOKL5D8aVt1+12h\n4CJVN6AGS8mx750wxgNmwjMHdihL01USaOM6GDxX+/ANsYXpU0g4ExWa4n7y19ww\nPe+h830Rge15vUJy5RU9MSSGXaKeOTAuXEi7BfY+aha7eWscOQKV58N+1GoNAehK\nxzuoztOq82NbY9dwH3m4uBVRIlq37+QuwJX6Wc0INq+98eIqFFblBwHKJz906xOK\nP+SNhZH7AgMBAAECggEABkxnvgGPk5Ftpu5NYtrza/49cHPNwb86wHQ/OINoexqf\nI88PDJh/sLzyWlnbDAzuM7NFxf0xpNbJklp/4G33YxTtGgNPPsHIbHuaNv+EVmSd\nQF9CC2xmQ97wcVmVDWoX5b9MTyQfnFwO74lakCtiuJ10X/O1hz8VqNAyDDKFQkSd\nOHJ8UOKwuLevYI8TNPlqr2AY2S3DdJ6r4y+/xs9TjbGRWHmrHCpZMPNqi/LnaQ1V\nd1+90S7HZHc0rPL9CtSU1torzVr9I1nlor3eY6RM9BXw8+oi4HUIVHm+3HnVVC7N\nDNwjQyq9yXvEb/3EHdPggkw2HiaJ7zeYDrmvzG/4WQKBgQD7I8F1MH+A3sNb80In\nlkgqlIc6bOivqQMP+4mKo45pPCC+qE5TyKFjCNNtvGuHad2kgsoL3fIV/tkTSC1J\ny3L1zOTNhD8Yj+W7tGMuCqFOJvOzTSYkny9hxWLsE9USilkYi/Cyg1nuxrlybp7E\nt1ksQlZXFavcncD24kQ/stPiDwKBgQDmFqz1t68vco6CIcznU/kuAlkyLQp5B8bS\nPGO4W4ALUcicDI/n9am03Bkiao0UCLLYDQ65rYUOBJz+zL2RZXN+gaT5kqOaRaH5\n5a8Rd1Bjcc5JDeR/5iBCqz9EPEMXFjrzGp150yqzlYjqi6/T5kmBZ0M0JA2y1efB\ntn5WdANNVQKBgAm12jcTxvpOorMddsNdFjE/SPNDXsPb/xhRG4JWzJzZDFMS4uRu\nb38KylIF5Qp5V26S+Aj5bfDXx8DtG4Ms8Kb8YyRnJqFmfvWBBgyzsIT7EJUwOHdW\nCFj5bte99JEg9Ez0rDvaxFFtMaJxEIZ+qF4Dup7nYZvIJbvmB8mGupaVAoGBAIp0\nyL3QO+Y0bFcYmeH2YTLzjNMp0WyFZnoqhuNwhDvLigmFca9m4CmKbMGOFrkghuaF\n7P+E0FVgJ00YzVZKE1bkEu9v820pS9BCC7hZ8RD2cej6KC9ivrT/scGQ9dpVsUGL\nGYourTqF2G8zgankoQTyq7kbnPapy52BAMNranVFAoGAASMtRU7QUvoP1GJbJeWl\n92Z+TxAQ3RADo24d26RzGnoXS8YfUTesL1R8aJIrZE7uLoEtJYVF8MCv4ciYFdb7\nhoXgjWul2/Eq4kfVTtYF19eEIbNubg65Z0KLzM22YjEgKVFNz0jm06bBZ1Sxx58M\nJW3CcG3AP30Ks+sV2wI1XiI=\n-----END PRIVATE KEY-----\n",
        "client_email": "dialogflow-spxxjg@hesprbot-ltmm.iam.gserviceaccount.com",
        "client_id": "107807333144879304147",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/dialogflow-spxxjg%40hesprbot-ltmm.iam.gserviceaccount.com"
      }
      ''',
    );

    const _SCOPES = const [
      DialogflowApi.CloudPlatformScope,
      DialogflowApi.DialogflowScope
    ];
    final _client = await clientViaServiceAccount(_credentials, _SCOPES);
    _dialogflow = DialogflowApi(_client);
  }

  Future<GoogleCloudDialogflowV2QueryResult> getDialogflowResult(
      String userExpression) async {
    await init();

    Map data = {
      "queryInput": {
        "text": {
          "text": userExpression,
          "languageCode": "en",
        }
      }
    };

    final request = GoogleCloudDialogflowV2DetectIntentRequest.fromJson(data);
    final session = 'projects/hesprbot-ltmm/agent/sessions/123';

    try {
      final response = await _dialogflow.projects.agent.sessions
          .detectIntent(request, session);

      return response.queryResult;
    } catch (e) {
      print('error: $e');
    }

    return null;
  }

  Future<HesprBotResult> getResult(String userExpression) async {
    GoogleCloudDialogflowV2QueryResult result =
        await getDialogflowResult(userExpression);
    var map = result.webhookPayload;
    return HesprBotResult(
      textResponse: result.fulfillmentText,
      insertName: map['insertName'],
      showKeyboard: map['showKeyboard'] ?? true,
      stringButtons: map['stringButtons'],
      imageButtons: map['imageButtons'],
      showSlider: map['showSlider'],
      sliderRangeStart: map['sliderRangeStart'],
      sliderRangeEnd: map['sliderRangeEnd'],
    );
  }
}

class HesprBotResult {
  /// What the chatbot will say from the user's perspective.
  final String textResponse;

  /// Whether to check for instances of NAME in the chatbot’s text response.
  final bool insertName;

  /// True by default.
  final bool showKeyboard;

  /// Buttons with preset user expressions.
  final List<String> stringButtons;

  /// Buttons with images. May also show text.
  ///
  /// Keys are `imageAsset` and `imageCaption`.
  final Map<String, dynamic> imageButtons;

  /// Whether to give a slider, which allows a user to select a number in the
  /// given range.
  final bool showSlider;

  /// `showSlider` must be true.
  final int sliderRangeStart;

  /// `showSlider` must be true.
  final int sliderRangeEnd;

  HesprBotResult({
    this.textResponse,
    this.insertName,
    this.showKeyboard,
    this.stringButtons,
    this.imageButtons,
    this.showSlider = false,
    this.sliderRangeStart,
    this.sliderRangeEnd,
  });
}
