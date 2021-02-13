import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temporary/models/group_model.dart';

import 'paginated_scroll_view_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ConversationViewModel extends PaginatedScrollViewModel {
  ConversationViewModel({this.uid, this.groupId})
      : super(
          query: FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection('messages')
              .orderBy('sentAt', descending: true),
          modelConstructor: (snapshot) => MessageModel.fromSnapshot(snapshot),
        );

  Map<String, UserModel> _membersInConversation = Map();

  final String uid;
  final String groupId;

  final instance = FirebaseFirestore.instance;

  void init(GroupModel conversationData) async {
    setBusy(true);
    getDataOfMembersInConversation(conversationData);
    setBusy(false);
    listenToItems();
  }

  void getDataOfMembersInConversation(GroupModel conversationData) async {
    QuerySnapshot snapshot = await instance
        .collection('users')
        .where(
          'id',
          whereIn: conversationData.memberIds,
        )
        .get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for (QueryDocumentSnapshot doc in docs) {
      UserModel user = UserModel.fromMap(doc.data());
      _membersInConversation.putIfAbsent(user.uid, () => user);
    }
  }

  UserModel getMemberById(String uid) {
    return _membersInConversation[uid];
  }

  /// Update the modifiedAt field of the group document and add a new message doc
  /// to the group's message collection.
  Future<void> sendMessage(String message) async {
    final DocumentReference groupDoc =
        instance.collection('groups').doc(groupId);
    groupDoc.update({
      'modifiedAt': FieldValue.serverTimestamp(),
    });
    final CollectionReference messagesCollection =
        groupDoc.collection('messages');
    DocumentReference newDocument = messagesCollection.doc();
    await newDocument.set({
      'message_id': newDocument.id,
      'message_text': message,
      'readBy': [uid],
      'sentAt': FieldValue.serverTimestamp(),
      'sentBy': uid,
    });
  }

  void markMessageAsRead(MessageModel message) async {
    if (!message.userHasRead) {
      final DocumentReference messageDocument = instance
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(message.id);
      await messageDocument.update({
        'readBy': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
