import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oil_finder/models/models.dart';

class FirestoreService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Stream<List<Group>> getChatGroups(String uid) {
    return _instance
        .collection('groups')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);
      return querySnapshot.docs.map((doc) => Group.fromSnapshot(doc));
    });
  }

  Future<List<Group>> getGroups(String uid) async {
    QuerySnapshot snap = await _instance.collection('groups').get();
    return snap.docs.map((doc) => Group.fromSnapshot(doc));
  }

  Future<void> addGroup() async {
    _instance.collection('groups').add({
      'members': ['me', 'your mom']
    });
  }
}
