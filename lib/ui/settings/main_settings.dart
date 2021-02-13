import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_structure.dart';
import '../widgets/decorated_container.dart';
import '../colors.dart';
import 'download_data.dart';
import 'feedback.dart';
import 'share_data.dart';
import '../size_config.dart';
import 'logout_alert.dart';
import 'delete_data.dart';
import 'settings_widgets/settings_widgets.dart';
import '../../utility/transition.dart';
import '../widgets/content_animation.dart';

class Settings extends StatelessWidget {
  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: MyAppBar(
          onBack: () {
            Provider.of<NavState>(context, listen: false).setShowNavBar(true);
            Navigator.pop(context);
          },
          titleText: 'Settings',
          color: orange3,
        ),
        backgroundColor: backgroundGrey,
        body: Center(
          child: ListView(
            children: [
              SettingCard(
                flutterIcon: Icon(Icons.attach_file, color: pureWhite),
                text: 'Give feedback',
                setting: GiveFeedback(),
                delay: 100,
              ),
              SettingCard(
                flutterIcon: Icon(Icons.lock_open, color: pureWhite),
                text: 'Share data',
                setting: ShareData(),
                delay: 200,
              ),
              SettingCard(
                flutterIcon: Icon(Icons.exit_to_app, color: pureWhite),
                text: 'Logout',
                delay: 300,
              ),
              SettingCard(
                svgIcon:
                    SvgPicture.asset('assets/shield.svg', color: pureWhite),
                text: 'Delete account',
                setting: DeleteData(),
                delay: 400,
              ),
              SettingCard(
                flutterIcon: Icon(Icons.file_download, color: pureWhite),
                text: 'Download data',
                setting: DownloadData(),
                delay: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  SettingCard({
    Key key,
    this.flutterIcon,
    this.svgIcon,
    @required this.text,
    this.setting,
    @required this.delay,
  }) : super(key: key);

  final Icon flutterIcon;
  final Widget svgIcon;
  final String text;
  final Widget setting;
  final int delay;

  Widget getIcon() {
    if (text.compareTo('Delete account') == 0) {
      return svgIcon;
    } else {
      return flutterIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (text.compareTo('Logout') == 0) {
          showDialog(
            context: context,
            builder: (context) => LogoutAlert(),
          );
        } else {
          Navigator.push(
            context,
            Transition.none(next: setting),
          );
        }
      },
      child: ContentAnimation(
        delay: delay,
        child: DecoratedContainer(
          height: SizeConfig.v * 11,
          margin: EdgeInsets.only(
            left: SizeConfig.v * 2,
            right: SizeConfig.v * 2,
            top: SizeConfig.v * 2,
            bottom: SizeConfig.v * 0.5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.h * 10,
                  right: SizeConfig.h * 4,
                ),
                child: getIcon(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.v * 1),
                child: Text(
                  text,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      fontSize: SizeConfig.h * 6.0,
                      color: pureWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
