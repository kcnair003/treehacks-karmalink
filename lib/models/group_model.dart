import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  GroupModel({
    this.createdAt,
    this.createdBy,
    this.groupId,
    this.groupName,
    this.groupType,
    this.memberIds,
    this.modifiedAt,
  });

  /// When the group was created.
  final Timestamp createdAt;

  /// UID of person who created the group.
  final String createdBy;

  /// Same as document ID in firestore.
  final String groupId;

  final String groupName;

  /// See `GroupType` class.
  final String groupType;

  /// UIDs of members.
  final List<dynamic> memberIds;

  /// Keeps track of when the last message was sent so that conversations can be ordered in the directory.
  final Timestamp modifiedAt;

  static GroupModel fromSnapshot(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return GroupModel(
      createdAt: data['createdAt'],
      createdBy: data['createdBy'],
      groupId: data['group_id'],
      groupName: data['group_name'],
      groupType: data['group_type'],
      memberIds: data['member_ids'],
      modifiedAt: data['modifiedAt'],
    );
  }
}

class GroupType {
  /// This constructor prevents anyone from making an instance of this class.
  const GroupType._();

  /// Chat with Hespr.
  static const String solo = 'solo';

  /// Two people.
  static const String pair = 'pair';

  /// More than two people.
  static const String multi = 'multi';
}
