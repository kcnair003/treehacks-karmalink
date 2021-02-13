import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';

class UserStreamBuilder extends StatelessWidget {
  /// Emits a stream of user data from firestore and passes it in the form of
  /// a UserModel to builder.
  UserStreamBuilder({
    Key key,
    @required this.uid,
    this.builder,
    this.busyBuilder,
  }) : super(key: key);

  final String uid;
  final Widget Function(BuildContext, UserSnapshot) builder;

  /// Widget to build while still waiting for data from the stream.
  ///
  /// Returns a CircularProgressIndicator if null.
  final Widget Function(BuildContext) busyBuilder;

  final _firestoreService = locator<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestoreService.userDataStream(uid),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          var documentSnapshot = asyncSnapshot.data;
          UserModel user = UserModel.fromMap(documentSnapshot.data());
          return builder(context, UserSnapshot(hasData: true, data: user));
        }
        return builder(context, UserSnapshot());
      },
    );
  }
}

class UserSnapshot {
  UserSnapshot({this.hasData = false, this.data});

  final bool hasData;
  final UserModel data;
}
