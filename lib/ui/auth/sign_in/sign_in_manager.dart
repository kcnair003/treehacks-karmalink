import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthService auth;
  final ValueNotifier<bool> isLoading;

  Future<UserModel> _signIn(Future<UserModel> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }

  Future<void> signInWithApple() async {
    return await _signIn(auth.signInWithApple);
  }
}
