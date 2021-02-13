import 'package:flutter/material.dart';
import '../ui/social_platform/profile.dart';

class ProfileNavigator {
  static push(BuildContext context, String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Profile(uid: uid, displayBackButton: true),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  ProfilePicture({Key key, this.photoUrl, this.radius, this.uid})
      : super(key: key);

  final String photoUrl;
  final double radius;
  final String uid;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ProfileNavigator.push(context, uid),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl),
      ),
    );
  }
}
