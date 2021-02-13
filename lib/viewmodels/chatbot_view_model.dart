// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../services/dialogflow_service.dart';
// import '../models/message_model.dart';
// import '../locator.dart';
// import '../services/firestore_service.dart';
// import 'paginated_scroll_view_model.dart';

// class ChatbotViewModel extends PaginatedScrollViewModel {
//   ChatbotViewModel({
//     ItemType type,
//     String uid,
//   }) : super(uid: uid);

//   final _firestoreService = locator<FirestoreService>();
//   final _dialogflowService = locator<DialogflowService>();

//   void sendChatbotMessage(MessageModel toSend) async {
//     _firestoreService.createChatbotMessage(toSend);
//     var result = await _dialogflowService.getResult(toSend.message);
//     var messageReceived = MessageModel(
//       message: result.textResponse,
//       uid: 'chatbot',
//       isMine: false,
//       timestamp: FieldValue.serverTimestamp(),
//     );
//     _firestoreService.createChatbotMessage(messageReceived);
//   }
// }
