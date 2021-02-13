import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../project_level_data.dart';
import 'create_something.dart';
import '../colors.dart';
import '../size_config.dart';
import '../widgets/my_app_bar.dart';

class CreatePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: MyAppBar(
        onBack: () => Navigator.pop(context),
        titleText: 'Create Post',
        color: orange3,
      ),
      backgroundColor: backgroundGrey,
      body: CreateSomethingBody(
        onSubmit: (TextEditingController controller) {
          Navigator.pop(context);
          savePost(controller);
        },
      ),
    );
  }

  void savePost(TextEditingController controller) async {
    final dbRef = FirebaseFirestore.instance;
    dbRef.collection('posts').add({
      'content': controller.text,
      'hug': 1,
      'laugh': 1,
      'love': 1,
      'support': 1,
      'nickname': ProjectLevelData.user.displayName,
      'postType': 'PostCard',
      'profilePicture': ProjectLevelData.user.photoUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': ProjectLevelData.user.uid,
      'report': 0,
    });
  }
}
