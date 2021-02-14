import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/models/src/message.dart';

class FirestoreService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<User> getUser(String uid) async {
    DocumentSnapshot doc = await _instance.collection('users').doc(uid).get();
    return User.fromMap(doc.data());
  }

  Future<void> addUser(User user) async {
    await _instance.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _instance.collection('users').doc(uid).update(data);
  }

  Future<List<Group>> getGroups(String uid) async {
    QuerySnapshot snap = await _instance
        .collection('groups')
        .where('members', arrayContains: uid)
        .orderBy('last_updated')
        .get();
    return snap.docs.map((doc) {
      return Group.fromSnapshot(doc);
    }).toList();
  }

  Future<void> updateGroup(String groupId, Map<String, dynamic> data) async {
    _instance.collection('groups').doc(groupId).update(data);
  }

  Stream<List<Message>> getMessages(String groupId) {
    return _instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time_sent', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromSnapshot(doc)).toList();
    });
  }

  void addMessage(String groupId, String senderId, String senderDisplayName,
      String content) {
    DocumentReference doc = _instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc();
    doc.set({
      'sender_uid': senderId,
      'sender_display_name': senderDisplayName,
      'message': content,
      'time_sent': FieldValue.serverTimestamp(),
    });
  }
}
