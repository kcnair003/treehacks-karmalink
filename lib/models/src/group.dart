import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final List<String> memberUids;
  final Timestamp lastUpdated;

  Group({this.memberUids, this.lastUpdated});

  static Group fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Group(
      memberUids: data['members'],
      lastUpdated: data['last_updated'],
    );
  }
}
