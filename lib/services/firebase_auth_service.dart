import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../locator.dart';
import 'auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firestore_service.dart';
import '../models/user_model.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  UserModel _userFromFirebase(User firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    var user = UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
    extraSignInNeeds(user);
    return user;
  }

  UserModel _userFromEmailAndPassword(User firebaseUser, String name) {
    if (firebaseUser == null) {
      return null;
    }
    var user = UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: name,
      // Default butterfly profile picture
      photoUrl:
          'https://images.unsplash.com/photo-1549219777-03dee35e19ab?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
    );
    extraSignInNeeds(user);
    return user;
  }

  @override
  Stream<UserModel> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<UserModel> signInAnonymously() async {
    final UserCredential authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromEmailAndPassword(authResult.user, name);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel> signInWithEmailLink(
      {String email, String emailLink}) async {
    final UserCredential authResult = await _firebaseAuth.signInWithEmailLink(
        email: email, emailLink: emailLink);
    return _userFromFirebase(authResult.user);
  }

  @override
  bool isSignInWithEmailLink(String link) {
    return _firebaseAuth.isSignInWithEmailLink(link);
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
  }) async {
    return await _firebaseAuth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: url,
        handleCodeInApp: handleCodeInApp,
        androidPackageName: androidPackageName,
        androidMinimumVersion: androidMinimumVersion,
        iOSBundleId: iOSBundleID,
      ),
    );
  }

  /// https://firebase.flutter.dev/docs/auth/social
  @override
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential gCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, get the UserCredential
    UserCredential fireCredential =
        await FirebaseAuth.instance.signInWithCredential(gCredential);

    return _userFromFirebase(fireCredential.user);
  }

  // @override
  // Future<User> signInWithFacebook() async {
  //   final FacebookLogin facebookLogin = FacebookLogin();
  //   // https://github.com/roughike/flutter_facebook_login/issues/210
  //   facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //   final FacebookLoginResult result =
  //       await facebookLogin.logIn(<String>['public_profile']);
  //   if (result.accessToken != null) {
  //     final AuthResult authResult = await _firebaseAuth.signInWithCredential(
  //       FacebookAuthProvider.getCredential(
  //           accessToken: result.accessToken.token),
  //     );
  //     return _userFromFirebase(authResult.user);
  //   } else {
  //     throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //   }
  // }

  @override
  Future<UserModel> signInWithApple({List<Scope> scopes = const []}) async {
    final AuthorizationResult result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          await firebaseUser.updateProfile(
            displayName:
                '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}',
          );
        }
        return _userFromFirebase(firebaseUser);
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

  // @override
  // Future<UserModel> currentUserModel() async {
  //   final User user = await _firebaseAuth.currentUserModel();
  //   return _userFromFirebase(user);
  // }

  @override
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    // final FacebookLogin facebookLogin = FacebookLogin();
    // await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}

  /// Do other stuff that needs to happen along with sign in.
  void extraSignInNeeds(UserModel user) async {
    _firestoreService.updateUserDocumentOnLogin(user);
    if (!await userExists(user.uid)) {
      initializeNewUser(user);
    }
    storeKey();
  }

  Future<bool> userExists(String uid) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return snapshot.exists;
  }

  void initializeNewUser(UserModel user) {
    final ref = FirebaseFirestore.instance;

    // Journal document
    ref.collection('guided_journals').doc(user.uid).set({});

    // Daily journals collection
    ref
        .collection('guided_journals')
        .doc(user.uid)
        .collection('daily_journals')
        .add({});
  }

  /// Cache the key that will be used to encrypt guided journal text input
  void storeKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = encrypt.Key.fromSecureRandom(16).base64;
    prefs.setString('key', key);
  }

  @override
  UserModel currentUser() {
    final User user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }
}
