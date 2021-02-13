import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'settings_widgets/settings_widgets.dart';
import '../widgets/content_animation.dart';

class GiveFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Feedback/Issues',
      children: [
        BodyText(
          text: 'We\'re very sorry if you\'re having any issues',
          delay: 100,
        ),
        BodyText(
          text:
              'Let us know how we can help you by emailing us at ethan@hespr.com!',
          delay: 200,
        ),
        SizedBox(height: 32),
        ContentAnimation(
          delay: 300,
          child: SvgPicture.asset(
            'assets/feedback.svg',
            width: 250,
          ),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}
