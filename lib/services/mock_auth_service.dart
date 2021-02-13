import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'auth_service.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:random_string/random_string.dart' as random;
import '../models/user_model.dart';

/// Mock authentication service to be used for testing the UI
/// Keeps an in-memory store of registered accounts so that registration and sign in flows can be tested.
class MockAuthService implements AuthService {
  MockAuthService({
    this.startupTime = const Duration(milliseconds: 250),
    this.responseTime = const Duration(seconds: 2),
  }) {
    Future<void>.delayed(responseTime).then((_) {
      _add(null);
    });
  }
  final Duration startupTime;
  final Duration responseTime;

  final Map<String, _UserData> _usersStore = <String, _UserData>{};

  UserModel _currentUser;

  final StreamController<UserModel> _onAuthStateChangedController =
      StreamController<UserModel>();
  @override
  Stream<UserModel> get onAuthStateChanged =>
      _onAuthStateChangedController.stream;

  @override
  UserModel currentUser() {
    return _currentUser;
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    await Future<void>.delayed(responseTime);
    if (_usersStore.keys.contains(email)) {
      throw PlatformException(
        code: 'ERROR_EMAIL_ALREADY_IN_USE',
        message: 'The email address is already registered. Sign in instead?',
      );
    }
    final UserModel user =
        UserModel(uid: random.randomAlphaNumeric(32), email: email);
    _usersStore[email] = _UserData(password: password, user: user);
    _add(user);
    return user;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    await Future<void>.delayed(responseTime);
    if (!_usersStore.keys.contains(email)) {
      throw PlatformException(
        code: 'ERROR_USER_NOT_FOUND',
        message: 'The email address is not registered. Need an account?',
      );
    }
    final _UserData _userData = _usersStore[email];
    if (_userData.password != password) {
      throw PlatformException(
        code: 'ERROR_WRONG_PASSWORD',
        message: 'The password is incorrect. Please try again.',
      );
    }
    _add(_userData.user);
    return _userData.user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<UserModel> signInWithEmailLink(
      {String email, String emailLink}) async {
    await Future<void>.delayed(responseTime);
    final UserModel user = UserModel(uid: random.randomAlphaNumeric(32));
    _add(user);
    return user;
  }

  @override
  bool isSignInWithEmailLink(String link) {
    return true;
  }

  @override
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  }) async {}

  @override
  Future<void> signOut() async {
    _add(null);
  }

  void _add(UserModel user) {
    _currentUser = user;
    _onAuthStateChangedController.add(user);
  }

  @override
  Future<UserModel> signInAnonymously() async {
    await Future<void>.delayed(responseTime);
    final UserModel user = UserModel(uid: random.randomAlphaNumeric(32));
    _add(user);
    return user;
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    await Future<void>.delayed(responseTime);
    final UserModel user = UserModel(uid: random.randomAlphaNumeric(32));
    _add(user);
    return user;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await Future<void>.delayed(responseTime);
    final UserModel user = UserModel(uid: random.randomAlphaNumeric(32));
    _add(user);
    return user;
  }

  @override
  Future<UserModel> signInWithApple({List<Scope> scopes}) async {
    await Future<void>.delayed(responseTime);
    final UserModel user = UserModel(uid: random.randomAlphaNumeric(32));
    _add(user);
    return user;
  }

  @override
  void dispose() {
    _onAuthStateChangedController.close();
  }
}

class _UserData {
  _UserData({@required this.password, @required this.user});
  final String password;
  final UserModel user;
}
