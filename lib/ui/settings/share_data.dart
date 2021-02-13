import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../ui/widgets/user_stream_builder.dart';
import '../project_level_data.dart';
import 'delete_data.dart';
import '../colors.dart';
import '../size_config.dart';
import 'settings_widgets/settings_widgets.dart';
import '../widgets/content_animation.dart';

class ShareData extends StatelessWidget {
  const ShareData({Key key}) : super(key: key);

  final _string1 = '''
  We consider your trust and safety our top priorities. Our app works best when 
  you feel comfortable and connected, and we work our hardest to make that possible.
  ''';
  final _string2 = '''
  Your guided journal entries are encrypted end-to-end.
  ''';
  final _string3 = '''
  However, as we try to make our algorithms more powerful, we need some journal 
  entries that we can use to train our algorithms. If you opt in below, you will 
  share your journal entries anonymously and dissociated from your name.
  ''';
  final _string4 = '''
  Of course, you can easily change your mind at any time, and we will gladly 
  make that change immediately.
  ''';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SettingsPage(
      title: 'Sharing Data',
      children: [
        Padding(
          padding: EdgeInsets.only(top: SizeConfig.v * 1),
          child: BodyText(
            delay: 100,
            text: _string1,
          ),
        ),
        BodyText(
          delay: 200,
          text: _string2,
        ),
        BodyText(
          delay: 300,
          text: _string3,
        ),
        BodyText(
          delay: 400,
          text: _string4,
        ),
        Spacer(),
        ContentAnimation(
          delay: 500,
          child: UserStreamBuilder(
            uid: ProjectLevelData.user.uid,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return data.shareData
                    ? undoShareDataButton()
                    : shareDataButton();
              } else {
                return MyRaisedButton();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget shareDataButton() {
    return Column(
      children: [
        CaptionText('Not currently sharing'),
        SizedBox(height: 8),
        MyRaisedButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('users')
                .doc(ProjectLevelData.user.uid)
                .update({
              'shareData': true,
            });
          },
          text: 'Share now!',
        ),
      ],
    );
  }

  Widget undoShareDataButton() {
    return Column(
      children: [
        CaptionText('Currently sharing'),
        SizedBox(height: 8),
        MyRaisedButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('users')
                .doc(ProjectLevelData.user.uid)
                .update({
              'shareData': false,
            });
          },
          text: 'Stop sharing',
        ),
      ],
    );
  }
}
