import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderUid;
  final String senderDisplayName;
  final String message;
  final Timestamp timestamp;

  Message({
    this.senderUid,
    this.senderDisplayName,
    this.message,
    this.timestamp,
  });

  static Message fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Message(
      senderUid: data['sender_uid'],
      senderDisplayName: data['sender_display_name'] ?? 'Jon Doe',
      message: data['message'] ?? 'Hello debaters!',
      timestamp: data['time_sent'],
    );
  }
}
