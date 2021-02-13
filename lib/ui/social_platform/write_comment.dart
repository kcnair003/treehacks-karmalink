import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../project_level_data.dart';
import 'create_something.dart';
import '../colors.dart';
import '../widgets/my_app_bar.dart';

class WriteComment extends StatelessWidget {
  WriteComment({Key key, this.postID}) : super(key: key);

  final String postID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        onBack: () => Navigator.pop(context),
        titleText: 'Write Comment',
        color: orange3,
      ),
      backgroundColor: backgroundGrey,
      body: CreateSomethingBody(
        onSubmit: (TextEditingController controller) {
          Navigator.pop(context);
          saveComment(controller);
        },
      ),
    );
  }

  void saveComment(TextEditingController controller) async {
    final dbRef = FirebaseFirestore.instance;

    DocumentReference document = FirebaseFirestore.instance
        .collection('users')
        .doc(ProjectLevelData.user.uid);
    DocumentSnapshot snapshot = await document.get();
    var record = UserRecord.fromSnapshot(snapshot);
    DocumentReference postRef = dbRef.collection('posts').doc(postID);
    postRef.update({'newCommentsExist': true});
    postRef.collection('comments').add(
      {
        'comment': controller.text,
        'likes': 0,
        'nickname': record.nickname,
        'photoUrl': record.photoUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'uid': ProjectLevelData.user.uid,
      },
    );
  }
}

class UserRecord {
  final String photoUrl;
  final String nickname;
  final DocumentReference reference;

  UserRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['photoUrl'] != null),
        assert(map['nickname'] != null),
        photoUrl = map['photoUrl'],
        nickname = map['nickname'];

  UserRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
