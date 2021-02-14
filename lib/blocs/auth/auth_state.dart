import 'package:equatable/equatable.dart';

import '../../models/models.dart';

enum AuthLifeCycle {
  loading,
  unauthenticated,
  authenticated,
}

class AuthState extends Equatable {
  final AuthLifeCycle status;
  final UserK user;
  final String signInWithEmailAndPasswordError;
  final String createAnAccountError;
  final String forgotPasswordError;

  AuthState({
    AuthLifeCycle status,
    this.user,
    this.signInWithEmailAndPasswordError,
    this.createAnAccountError,
    this.forgotPasswordError,
  }) : this.status = status ?? AuthLifeCycle.loading;

  AuthState copyWith({
    AuthLifeCycle status,
    UserK user,
    String errorMessage,
    String signInWithEmailAndPasswordError,
    String createAnAccountError,
    String forgotPasswordError,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      signInWithEmailAndPasswordError: signInWithEmailAndPasswordError ??
          this.signInWithEmailAndPasswordError,
      createAnAccountError: createAnAccountError ?? this.createAnAccountError,
      forgotPasswordError: forgotPasswordError ?? this.forgotPasswordError,
    );
  }

  @override
  List<Object> get props => [
        status,
        user,
        signInWithEmailAndPasswordError,
        createAnAccountError,
        forgotPasswordError,
      ];

  @override
  String toString() => 'status: $status';
}
