import 'package:flutter/material.dart';

import '../ui/colors.dart';
import '../ui/text_styles.dart';
import '../common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key key,
    String text,
    bool loading = false,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyles.roboto(20, pureWhite),
          ),
          height: 44.0,
          color: purple2,
          textColor: Colors.black87,
          loading: loading,
          onPressed: onPressed,
        );
}
