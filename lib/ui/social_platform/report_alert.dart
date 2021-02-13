import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../locator.dart';
import '../widgets/alert_pop_up.dart';

class ReportAlert extends StatelessWidget {
  ReportAlert({Key key, this.postID}) : super(key: key);

  final String postID;

  @override
  Widget build(BuildContext context) {
    return AlertPopUp(
      text:
          'Thank you for helping us keep the platform safe! Does this post contain dangerous or offensive content?',
      onAccept: () {
        handleReport();
        Navigator.of(context).pop();
      },
      acceptText: 'Yes',
      onDecline: () => Navigator.pop(context),
      declineText: 'No',
    );
  }

  void handleReport() {
    locator<FirestoreService>().reportPost(postID);
  }
}
