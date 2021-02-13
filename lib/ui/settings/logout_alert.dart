import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/platform_exception_alert_dialog.dart';
import '../../services/auth_service.dart';
import '../app_structure.dart';
import '../widgets/alert_pop_up.dart';

class LogoutAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertPopUp(
      text: 'Are you sure you want to logout?',
      onAccept: () => handleSignOut(context),
      acceptText: 'Yes, log me out',
      onDecline: () => Navigator.pop(context),
      declineText: 'Nevermind!',
    );
  }

  Future<void> handleSignOut(BuildContext context) async {
    try {
      final AuthService auth = Provider.of<AuthService>(context, listen: false);
      await auth.signOut();
      var _navState = Provider.of<NavState>(context, listen: false);
      _navState.setShowNavBar(true);
      _navState.setPageIndex(0);
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: 'Logout failed',
        exception: e,
      ).show(context);
    }
  }
}
