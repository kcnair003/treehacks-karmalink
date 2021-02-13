import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import 'create_something.dart';
import '../colors.dart';
import '../size_config.dart';
import '../../locator.dart';
import '../widgets/my_app_bar.dart';

class EditPost extends StatelessWidget {
  EditPost({Key key, this.postID, this.initContent}) : super(key: key);

  final String postID;
  final String initContent;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: MyAppBar(
        onBack: () => Navigator.pop(context),
        titleText: 'Edit Post',
        color: orange3,
      ),
      backgroundColor: backgroundGrey,
      body: CreateSomethingBody(
        onSubmit: (TextEditingController controller) {
          savePost(controller);
        },
        textEditingController: TextEditingController(text: initContent),
      ),
    );
  }

  /// Save edits to the post.
  void savePost(TextEditingController controller) async {
    locator<FirestoreService>().editPost(postID, controller.text);
  }
}
