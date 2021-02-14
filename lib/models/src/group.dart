import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:treehacks2021/models/src/user.dart';
import 'package:treehacks2021/services/services.dart';

class Group extends Equatable {
  final String id;
  final List<dynamic> memberUids;
  final Timestamp lastUpdated;
  final List<User> users;

  Group({
    this.id,
    this.memberUids,
    this.lastUpdated,
    this.users = const [],
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

  Future<Group> queryMemberData() async {
    List<User> _usersFetched = [];
    for (var uid in memberUids) {
      User user = await _firestoreService.getUser(uid);
      _usersFetched.add(user);
    }
    return copyWith(users: _usersFetched);
  }

  // Exclude myUid from the list of names to display.
  String getNamesToDisplay(String myUid) {
    List<String> namesExceptMine = [];
    for (var user in users) {
      if (user.uid != myUid) {
        namesExceptMine.add(user.displayName);
      }
    }
    return namesExceptMine.join(', ');
  }

  @override
  String toString() {
    return 'groupId: $id';
  }

  @override
  List<Object> get props => [id, memberUids, lastUpdated, users];

  Group copyWith({
    String id,
    List<dynamic> memberUids,
    Timestamp lastUpdated,
    List<User> users,
  }) {
    return Group(
      id: id ?? this.id,
      memberUids: memberUids ?? this.memberUids,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      users: users ?? this.users,
    );
  }
}
