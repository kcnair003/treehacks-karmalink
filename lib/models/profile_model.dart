import '../ui/project_level_data.dart';
import '../locator.dart';
import '../services/firestore_service.dart';

class ProfileModel {
  final String uid;
  final String nickname;
  final String photoUrl;
  final bool isMyProfile;
  final String friendStatus;

  ProfileModel({
    this.uid,
    this.nickname,
    this.photoUrl,
    this.isMyProfile,
    this.friendStatus,
  });

  static Future<ProfileModel> fromMap(Map map, String uid) async {
    if (map == null) return null;

    return ProfileModel(
      uid: uid,
      nickname: map['nickname'],
      photoUrl: map['photoUrl'],
      isMyProfile: compareUid(uid),
      friendStatus: await getFriendStatus(uid),
    );
  }

  /// See if profile belongs to the viewer by comparing profile
  /// uid to viewer uid.
  static bool compareUid(String uid) {
    return uid == ProjectLevelData.user.uid;
  }

  static Future<String> getFriendStatus(String uid) =>
      locator<FirestoreService>()
          .getFriendStatus(ProjectLevelData.user.uid, uid);
}
