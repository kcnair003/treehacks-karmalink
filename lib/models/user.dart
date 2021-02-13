import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String password;
  final String displayName;
  final String photoUrl;
  final int incomingFriendRequests;
  final bool shareData;
  final bool requestedDelete;
  final Timestamp lastDownloadedData;

  const UserModel({
    this.uid,
    this.email,
    this.password,
    this.displayName,
    this.photoUrl,
    this.incomingFriendRequests,
    this.shareData,
    this.requestedDelete,
    this.lastDownloadedData,
  });

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['id'],
      displayName: map['nickname'],
      photoUrl: map['photoUrl'],
      incomingFriendRequests: map['incoming_friend_requests'] ?? 0,
      shareData: map['shareData'] ?? false,
      requestedDelete: map['requested_delete'],
      lastDownloadedData: map['lastDownloadedData'],
    );
  }
}
