import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/models/src/message.dart';

class FirestoreService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<User> getUser(String uid) async {
    DocumentSnapshot doc = await _instance.collection('users').doc(uid).get();
    return User.fromMap(doc.data());
  }

  Future<List<Group>> getGroups(String uid) async {
    QuerySnapshot snap = await _instance
        .collection('groups')
        .where('members', arrayContains: uid)
        // .orderBy('last_updated')
        .get();
    return snap.docs.map((doc) {
      return Group.fromSnapshot(doc);
    }).toList();
  }

  Future<void> addGroup() async {
    _instance.collection('groups').add({
      'members': ['me', 'your mom']
    });
  }

  Stream<List<Message>> getMessages(String groupId) {
    return _instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time_sent')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromSnapshot(doc)).toList();
    });
  }
}
