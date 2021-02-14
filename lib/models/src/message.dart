import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderUid;
  final String message;
  final Timestamp timestamp;

  Message({this.senderUid, this.message, this.timestamp});

  static Message fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Message(
      senderUid: data['sender_uid'],
      message: data['message'],
      timestamp: data['time_sent'],
    );
  }
}
