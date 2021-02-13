import 'package:flutter/material.dart';

import '../../colors.dart';
import '../const.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
      ),
      color: pureWhite.withOpacity(0.8),
    );
  }
}
