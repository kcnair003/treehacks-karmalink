import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temporary/ui/widgets/content_animation.dart';
import '../colors.dart';
import '../project_level_data.dart';
import '../size_config.dart';
import '../../utility/transition.dart';
import 'settings_widgets/settings_widgets.dart';

class DeleteData extends StatelessWidget {
  const DeleteData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SettingsPage(
      title: 'Delete Account',
      children: [
        BodyText(
          text:
              'We\'re very sorry you want to delete your account. Having issues? Please go to the Issues tab in Settings!',
          delay: 100,
        ),
        BodyText(
          text:
              'If you still wish to delete your account, you can by clicking the button below',
          delay: 200,
        ),
        ContentAnimation(
          delay: 300,
          child: SvgPicture.asset(
            'assets/delete.svg',
            fit: BoxFit.contain,
            height: 230,
            width: 230,
          ),
        ),
        ContentAnimation(
          delay: 400,
          child: MyRaisedButton(
            text: 'Delete account',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => DeleteDataAlert(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DeleteDataAlert extends StatelessWidget {
  const DeleteDataAlert({Key key}) : super(key: key);

  /// Will trigger the back-end function to delete.
  void handleDelete(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(ProjectLevelData.user.uid)
        .update({
      'requested_delete': true,
    });

    var prefs = await SharedPreferences.getInstance();
    prefs.clear();

    // TODO: logout

    Fluttertoast.showToast(
      msg: 'Your account will be deleted soon!',
      backgroundColor: Colors.white70,
      textColor: purple3.withOpacity(0.7),
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('There is no going back if you delete your account.'),
          Text('Type "confirm" if you\'re sure you want to continue.'),
          TextFormField(
            style: TextStyle(color: purple3),
            controller: controller,
            minLines: 1,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            textAlignVertical: TextAlignVertical(y: 0),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white24,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: 'Type here',
              hintStyle: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: SizeConfig.h * 4,
                  color: purple3,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Icon(Icons.cancel, color: Colors.orange[300]),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Icon(Icons.check, color: Colors.orange[300]),
          onPressed: () {
            if (controller.text.compareTo('confirm') != 0) {
              Fluttertoast.showToast(msg: 'Did not spell "confirm" correctly');
            } else {
              handleDelete(context);
            }
          },
        ),
      ],
    );
  }
}

class ShareDataYes extends StatelessWidget {
  const ShareDataYes({Key key}) : super(key: key);

  Future<void> handleConfirmationToShare() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ProjectLevelData.user.uid)
        .update({
      'shareData': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Awesome, thanks for your trust and support! Confirm below!'),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Icon(Icons.cancel, color: Colors.orange[300]),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Icon(Icons.check, color: Colors.orange[300]),
          onPressed: () {
            handleConfirmationToShare();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ShareDataNo extends StatelessWidget {
  const ShareDataNo({Key key}) : super(key: key);

  Future<void> handleConfirmationToStop() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ProjectLevelData.user.uid)
        .update({
      'shareData': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please confirm that you want to stop sharing your journal entries!',
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Icon(Icons.cancel, color: orange3),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Icon(Icons.check, color: orange3),
          onPressed: () {
            handleConfirmationToStop();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
