import 'package:cloud_firestore/cloud_firestore.dart';

import '../ui/project_level_data.dart';

class MessageModel {
  MessageModel({
    this.id,
    this.messageText,
    this.readBy,
    this.sentAt,
    this.sentBy,
  });

  final String id;
  final String messageText;
  final List readBy;
  final Timestamp sentAt;

  /// uid of sender.
  final String sentBy;

  static MessageModel fromSnapshot(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return MessageModel(
      id: data['message_id'],
      messageText: data['message_text'],
      readBy: data['readBy'] ?? List(),
      sentAt: data['sentAt'],
      sentBy: data['sentBy'],
    );
  }

  bool get isMine {
    return sentBy == ProjectLevelData.user.uid;
  }

  bool get userHasRead {
    return readBy.contains(ProjectLevelData.user.uid);
  }
}
