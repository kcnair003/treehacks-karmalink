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

  const User({
    this.status = UserLifeCycle.unknown,
    this.uid = '',
    this.email,
    this.displayName,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'uid': uid,
      'email': email,
      'displayName': displayName,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
    );
  }

  User copyWith({
    String uid,
    String email,
    String displayName,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      uid,
      email,
      displayName,
    ];
  }

  @override
  String toString() => 'status: $status, uid: $uid';
}
