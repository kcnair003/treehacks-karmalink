import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuthException, UserCredential;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:treehacks2021/pages/auth_view.dart';

import '../../models/models.dart';
import '../../my_navigator.dart';
import '../../services/services.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({this.userStream}) : super(AuthState()) {
    _userSubscription = userStream.listen((User user) {
      _userValue = user;
      _determineUserTrack();
    });
    _determineUserTrack();
  }

  final _firestoreService = FirestoreService();
  final _auth = FirebaseAuthService();

  final Stream<User> userStream;
  StreamSubscription _userSubscription;
  User _userValue = User();

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
      String displayName, String email, String password) async {
    if (displayName == null || displayName.isEmpty) {
      emit(state.copyWith(createAnAccountError: 'Please enter your name'));
      return;
    }
    if (email == null || email.isEmpty) {
      emit(state.copyWith(createAnAccountError: 'Please enter your email'));
      return;
    }
    if (password == null || password.isEmpty) {
      emit(state.copyWith(createAnAccountError: 'Please enter your password'));
      return;
    }

    try {
      UserCredential cred =
          await _auth.createUserWithEmailAndPassword(email, password);
      await _firestoreService.addUser(
        User(
          uid: cred.user.uid,
          email: email,
          displayName: displayName,
        ),
      );
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
    if (_userValue.status == UserLifeCycle.unauthenticated) {
      emit(state.copyWith(
        status: AuthLifeCycle.unauthenticated,
      ));
    } else if (_userValue.status == UserLifeCycle.authenticated) {
      User userFromDB = await _firestoreService.getUser(_userValue.uid);
      emit(state.copyWith(
        status: AuthLifeCycle.authenticated,
        user: _userValue.copyWith(
          displayName: userFromDB.displayName,
          likeMinded: userFromDB.likeMinded,
        ),
      ));
      MyNavigator.pushAndRemoveUntil(AuthView());
    }
  }

  @override
  Future<void> close() async {
    super.close();
    _userSubscription.cancel();
  }
}
