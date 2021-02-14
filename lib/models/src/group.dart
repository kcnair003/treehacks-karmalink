import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treehacks2021/models/src/user.dart';
import 'package:treehacks2021/services/services.dart';

class Group {
  final String id;
  final List<dynamic> memberUids;
  final Timestamp lastUpdated;
  List<User> users = [];
  String _namesToDisplay;

  Group({
    this.id,
    this.memberUids,
    this.lastUpdated,
  });

  static Group fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Group(
      id: snapshot.id,
      memberUids: data['members'],
      lastUpdated: data['last_updated'],
    );
  }

  final _firestoreService = FirestoreService();

  Future<void> queryMemberData() async {
    for (var uid in memberUids) {
      print('querying for $uid...');
      User user = await _firestoreService.getUser(uid);
      print(user);
      users.add(user);
    }
  }

  // Exclude myUid from the list of names to display.
  String getNamesToDisplay(String myUid) {
    for (var user in users) {
      print(user.displayName);
    }
    if (_namesToDisplay == null) {
      List<String> namesExceptMine = [];
      for (var user in users) {
        if (user.uid != myUid) {
          namesExceptMine.add(user.displayName);
        }
      }
      _namesToDisplay = namesExceptMine.join(', ');
    }
    return _namesToDisplay;
  }
}
