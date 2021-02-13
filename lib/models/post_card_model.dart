import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import '../ui/project_level_data.dart';
import 'reaction_model.dart';

class PostCardModel {
  final String uid;
  final String postID;
  final String content;
  final String photoUrl;
  final String nickname;
  final String timeSincePost;
  final bool isMyPost;
  final bool newCommentsExist;
  final ReactionModel love;
  final ReactionModel support;
  final ReactionModel hug;
  final ReactionModel laugh;

  PostCardModel({
    this.uid,
    this.postID,
    this.content,
    this.photoUrl,
    this.nickname,
    this.timeSincePost,
    this.isMyPost,
    this.newCommentsExist,
    this.love,
    this.support,
    this.hug,
    this.laugh,
  });

  static PostCardModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    double total =
        (map['love'] + map['support'] + map['hug'] + map['laugh']).toDouble();

    return PostCardModel(
      uid: map['uid'],
      postID: documentId,
      content: map['content'],
      photoUrl: map['profilePicture'],
      nickname: map['nickname'],
      timeSincePost: getTimeSince(map['timestamp']),
      isMyPost: getIsMyPost(map['uid']),
      newCommentsExist: map['newCommentsExist'] ?? false,
      love: ReactionModel(
        postID: documentId,
        name: 'love',
        amount: map['love'],
        width: getReactionWidth(total, map['love']),
      ),
      support: ReactionModel(
        postID: documentId,
        name: 'support',
        amount: map['support'],
        width: getReactionWidth(total, map['support']),
      ),
      hug: ReactionModel(
        postID: documentId,
        name: 'hug',
        amount: map['hug'],
        width: getReactionWidth(total, map['hug']),
      ),
      laugh: ReactionModel(
        postID: documentId,
        name: 'laugh',
        amount: map['laugh'],
        width: getReactionWidth(total, map['laugh']),
      ),
    );
  }

  /// Convert `timestamp` into timeSincePost.
  static String getTimeSince(Timestamp timestamp) {
    DateTime myDateTime = DateTime.parse(timestamp.toDate().toString());
    String timeSincePost = Jiffy(myDateTime).fromNow();
    return timeSincePost;
  }

  /// Compares uid of the post to the device's uid.
  static bool getIsMyPost(String uid) {
    return uid == ProjectLevelData.user.uid;
  }

  /// Convert number of reactions into width of that reaction for
  /// the progress indicator.
  ///
  /// E.g., There are 5 love reacts with a total of 10, so love
  /// will take up half of the indicator.
  static double getReactionWidth(double total, int numOfReaction) {
    return numOfReaction.toDouble() / total;
  }
}
