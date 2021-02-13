import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  /// What the message says.
  final String message;

  /// Who said it.
  final String uid;

  /// Whether the message belongs to me.
  final bool isMine;

  /// Timestamp of message.
  final FieldValue timestamp;

  MessageModel({this.message, this.uid, this.isMine, this.timestamp});

  static MessageModel fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'],
      uid: map['uid'],
      isMine: map['isMine'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'uid': uid,
      'isMine': isMine,
      'timestamp': timestamp,
    };
  }
}
