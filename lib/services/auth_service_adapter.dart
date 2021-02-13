import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'auth_service.dart';
import 'firebase_auth_service.dart';
import 'mock_auth_service.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

enum AuthServiceType { firebase, mock }

class AuthServiceAdapter implements AuthService {
  AuthServiceAdapter({@required AuthServiceType initialAuthServiceType})
      : authServiceTypeNotifier =
            ValueNotifier<AuthServiceType>(initialAuthServiceType) {
    _setup();
  }
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final MockAuthService _mockAuthService = MockAuthService();

  // Value notifier used to switch between [FirebaseAuthService] and [MockAuthService]
  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;
  AuthServiceType get authServiceType => authServiceTypeNotifier.value;
  AuthService get authService => authServiceType == AuthServiceType.firebase
      ? _firebaseAuthService
      : _mockAuthService;

  StreamSubscription<UserModel> _firebaseAuthSubscription;
  StreamSubscription<UserModel> _mockAuthSubscription;

  void _setup() {
    // Observable<UserModel>.merge was considered here, but we need more fine grained control to ensure
    // that only events from the currently active service are processed
    _firebaseAuthSubscription =
        _firebaseAuthService.onAuthStateChanged.listen((user) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.addError(error);
      }
    });
    _mockAuthSubscription = _mockAuthService.onAuthStateChanged.listen((user) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.addError(error);
      }
    });
  }

  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();
    _mockAuthSubscription?.cancel();
    _onAuthStateChangedController?.close();
    _mockAuthService.dispose();
    authServiceTypeNotifier.dispose();
  }

  final StreamController<UserModel> _onAuthStateChangedController =
      StreamController<UserModel>.broadcast();
  @override
  Stream<UserModel> get onAuthStateChanged =>
      _onAuthStateChangedController.stream;

  @override
  UserModel currentUser() => authService.currentUser();

  @override
  Future<UserModel> signInAnonymously() => authService.signInAnonymously();

  @override
  Future<UserModel> createUserWithEmailAndPassword(
          String email, String password, String name) =>
      authService.createUserWithEmailAndPassword(email, password, name);

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) =>
      authService.signInWithEmailAndPassword(email, password);

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      authService.sendPasswordResetEmail(email);

  @override
  Future<UserModel> signInWithEmailLink({String email, String emailLink}) =>
      authService.signInWithEmailLink(email: email, emailLink: emailLink);

  @override
  bool isSignInWithEmailLink(String link) =>
      authService.isSignInWithEmailLink(link);

  @override
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  }) =>
      authService.sendSignInWithEmailLink(
        email: email,
        url: url,
        handleCodeInApp: handleCodeInApp,
        iOSBundleID: iOSBundleID,
        androidPackageName: androidPackageName,
        androidInstallIfNotAvailable: androidInstallIfNotAvailable,
        androidMinimumVersion: androidMinimumVersion,
      );

  // @override
  // Future<UserModel> signInWithFacebook() => authService.signInWithFacebook();

  @override
  Future<UserModel> signInWithGoogle() => authService.signInWithGoogle();

  @override
  Future<UserModel> signInWithApple({List<Scope> scopes}) =>
      authService.signInWithApple();

  @override
  Future<void> signOut() => authService.signOut();
}
