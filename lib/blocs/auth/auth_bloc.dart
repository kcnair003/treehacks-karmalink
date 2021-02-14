import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../locator.dart';
import '../../ui/auth_view.dart';
import '../../ui/ui_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import '../../constants.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({this.userStream}) : super(AuthState()) {
    _userSubscription = userStream.listen((User user) {
      _userValue = user;
      _determineUserTrack();
    });
    _determineUserTrack();
  }

  final _databaseService = locator<FirestoreService>();
  final _auth = locator<FirebaseAuthService>();

  final Stream<User> userStream;
  StreamSubscription _userSubscription;
  User _userValue = User();

  Future<void> completeOnboarding() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool(CacheKeys.hasBeenOnboarded, true);
    // _userHasBeenOnboarded = true;
    // _determineUserTrack();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (email == null || email.isEmpty) {
      emit(state.copyWith(
          signInWithEmailAndPasswordError: 'Please enter your email'));
      return;
    }
    if (password == null || password.isEmpty) {
      emit(state.copyWith(
          signInWithEmailAndPasswordError: 'Please enter your email'));
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(signInWithEmailAndPasswordError: e.message));
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    if (email == null || email.isEmpty) {
      emit(state.copyWith(createAnAccountError: 'Please enter your email'));
      return;
    }
    if (password == null || password.isEmpty) {
      emit(state.copyWith(createAnAccountError: 'Please enter your email'));
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(createAnAccountError: e.message));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email == null || email.isEmpty) {
      emit(state.copyWith(forgotPasswordError: 'Please enter your email'));
      return;
    }

    await _auth.sendPasswordResetEmail(email);
    Fluttertoast.showToast(msg: 'Email sent', gravity: ToastGravity.TOP);
  }

  Future<void> _determineUserTrack() async {
    if (!await _getUserHasBeenOnboarded() && !kIsWeb) {
      emit(state.copyWith(
        status: AuthLifeCycle.needsOnboarded,
      ));
    } else if (_userValue.status == UserLifeCycle.unauthenticated) {
      emit(state.copyWith(
        status: AuthLifeCycle.unauthenticated,
      ));
    } else if (_userValue.status == UserLifeCycle.authenticated) {
      await _checkForUserInDatabase(_userValue);
      emit(state.copyWith(
        status: AuthLifeCycle.authenticated,
        user: _userValue,
      ));
      MyNavigator.pushAndRemoveUntil(AuthView());
    }
  }

  bool _userHasBeenOnboarded = false;
  Future<bool> _getUserHasBeenOnboarded() async {
    // if (_userHasBeenOnboarded) {
    //   return true;
    // }

    // final _prefs = await SharedPreferences.getInstance();
    // _userHasBeenOnboarded = _prefs.getBool(CacheKeys.hasBeenOnboarded) ?? false;
    // return _userHasBeenOnboarded;
  }

  Future<void> _checkForUserInDatabase(User user) async {
    // User userFromDatabase = await _databaseService.user(user.uid);
    // _userValue = _userValue.copyWith(
    //   customLists: userFromDatabase.customLists,
    // );
    // if (userFromDatabase.status == UserLifeCycle.newUser) {
    //   _upsertUser(user);
    // } else {
    //   _makeSureUserMatchesInfoInDatabase(user, userFromDatabase);
    // }
  }

  Future<void> _makeSureUserMatchesInfoInDatabase(
    User currentUser,
    User userFromDatabase,
  ) async {
    if (!(currentUser.uid == userFromDatabase.uid &&
        currentUser.email == userFromDatabase.email)) {
      await _upsertUser(currentUser);
    }
  }

  Future<void> _upsertUser(User user) async {
    // _databaseService.upsertUser(
    //   user.uid,
    //   {
    //     'uid': user.uid,
    //     'email': user.email,
    //     'displayName': user.displayName,
    //   },
    // );
  }

  @override
  Future<void> close() async {
    super.close();
    _userSubscription.cancel();
  }
}
