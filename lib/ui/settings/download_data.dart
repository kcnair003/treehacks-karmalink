import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temporary/models/user.dart';
import 'package:temporary/services/firestore_service.dart';
import 'package:temporary/ui/widgets/content_animation.dart';
import 'package:temporary/ui/widgets/user_stream_builder.dart';
import '../../locator.dart';
import '../project_level_data.dart';
import 'settings_widgets/settings_widgets.dart';

class DownloadData extends StatelessWidget {
  DownloadData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Download Data',
      children: [
        BodyText(
          delay: 100,
          text: 'We want you to stay in the loop',
        ),
        SizedBox(height: 32),
        BodyText(
          delay: 200,
          text: 'You can request a copy of your data, no secrets here',
        ),
        Spacer(),
        ContentAnimation(
          delay: 300,
          child: UserStreamBuilder(
              uid: ProjectLevelData.user.uid,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bool canDownload = Controller.canDownload(snapshot.data);
                  printCheck(canDownload);
                  return DownloadButtonAndTextThatSaysIfTheyCanDownload(
                    canDownload,
                    snapshot.data.lastDownloadedData,
                  );
                } else {
                  return const DownloadButton(false);
                }
              }),
        ),
      ],
    );
  }

  void printCheck(bool canDownload) {
    print(
      canDownload
          ? 'User can download.'
          : 'User has downloaded data too recently to download right now.',
    );
  }
}

class DownloadButtonAndTextThatSaysIfTheyCanDownload extends StatelessWidget {
  const DownloadButtonAndTextThatSaysIfTheyCanDownload(
      this.canDownload, this.lastDownloadedData,
      {Key key})
      : super(key: key);

  final bool canDownload;
  final Timestamp lastDownloadedData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: !canDownload,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CaptionText(
              'The last time you downloaded data was ${lastDownloadedData?.toDate()}. '
              'You can download again after 7 days.',
            ),
          ),
        ),
        DownloadButton(canDownload),
      ],
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton(this.canDownload, {Key key}) : super(key: key);

  final bool canDownload;

  @override
  Widget build(BuildContext context) {
    return MyRaisedButton(
      text: 'Download',
      onPressed: canDownload
          ? () {
              locator<FirestoreService>().updateUserDocument(
                  ProjectLevelData.user.uid, {'requested_download': true});
            }
          : null,
    );
  }
}

class Controller {
  static bool _canDownload;
  static bool canDownload(UserModel user) {
    return _canDownload ?? determineIfUserCanDownload(user);
  }

  /// Determines if the user downloaded data within the past 7 days.
  static bool determineIfUserCanDownload(UserModel user) {
    Timestamp lastDownloadedData = user.lastDownloadedData;
    if (lastDownloadedData == null) return true;

    int millisecondsIn7Days = 604800000;

    return lastDownloadedData.millisecondsSinceEpoch + millisecondsIn7Days <
        Timestamp.now().millisecondsSinceEpoch;
  }
}
