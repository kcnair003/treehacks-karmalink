import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:meta/meta.dart';
import '../models/user.dart';

abstract class AuthService {
  UserModel currentUser();
  Future<UserModel> signInAnonymously();
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserWithEmailAndPassword(String email, String password, String name);
  Future<void> sendPasswordResetEmail(String email);
  Future<UserModel> signInWithEmailLink({String email, String emailLink});
  bool isSignInWithEmailLink(String link);
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  });
  Future<UserModel> signInWithGoogle();
  // Future<UserModel> signInWithFacebook();
  Future<UserModel> signInWithApple({List<Scope> scopes});
  Future<void> signOut();
  Stream<UserModel> get onAuthStateChanged;
  void dispose();
}
