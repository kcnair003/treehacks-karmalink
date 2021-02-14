import 'package:equatable/equatable.dart';

enum UserLifeCycle {
  unknown,
  newUser,
  unauthenticated,
  authenticated,
}

/// A user with data collected by Oil Finder. Not to be confused with the User class
/// in Firebase Auth.
class User extends Equatable {
  /// Defaults to UserLifeCycle.unknown
  final UserLifeCycle status;
  final String uid;
  final String email;
  final String displayName;

  /// True represents like-minded and false represents different-minded.
  final bool likeMinded;

  const User({
    this.status = UserLifeCycle.unknown,
    this.uid = '',
    this.email,
    this.displayName,
    this.likeMinded,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'display_name': displayName,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      displayName: map['display_name'],
      likeMinded: map['like_minded'] ?? true,
    );
  }

  User copyWith({
    String uid,
    String email,
    String displayName,
    bool likeMinded,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      likeMinded: likeMinded ?? this.likeMinded,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      uid,
      email,
      displayName,
      likeMinded,
    ];
  }

  @override
  String toString() => 'status: $status, uid: $uid, displayName: $displayName';
}
