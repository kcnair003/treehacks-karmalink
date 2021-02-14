// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:treehacks2021/locator.dart';
// import 'package:treehacks2021/ui/auth_view.dart';
// import 'package:treehacks2021/ui/ui_helper.dart';

// import '../../models/models.dart';
// import '../../services/services.dart';
// import 'auth_state.dart';

// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit({this.userStream}) : super(AuthState()) {
//     _userSubscription = userStream.listen((User user) {
//       _userValue = user;
//       _determineUserTrack();
//     });
//     _determineUserTrack();
//   }

//   final _firestoreService = locator<FirestoreService>();
//   final _auth = locator<FirebaseAuthService>();

//   final Stream<User> userStream;
//   StreamSubscription _userSubscription;
//   User _userValue = User();

//   Future<void> signInWithEmailAndPassword(String email, String password) async {
//     if (email == null || email.isEmpty) {
//       emit(state.copyWith(
//           signInWithEmailAndPasswordError: 'Please enter your email'));
//       return;
//     }
//     if (password == null || password.isEmpty) {
//       emit(state.copyWith(
//           signInWithEmailAndPasswordError: 'Please enter your email'));
//       return;
//     }

//     try {
//       await _auth.signInWithEmailAndPassword(email, password);
//     } on FirebaseAuthException catch (e) {
//       emit(state.copyWith(signInWithEmailAndPasswordError: e.message));
//     }
//   }

//   Future<void> createUserWithEmailAndPassword(
//       String email, String password) async {
//     if (email == null || email.isEmpty) {
//       emit(state.copyWith(createAnAccountError: 'Please enter your email'));
//       return;
//     }
//     if (password == null || password.isEmpty) {
//       emit(state.copyWith(createAnAccountError: 'Please enter your email'));
//       return;
//     }

//     try {
//       await _auth.createUserWithEmailAndPassword(email, password);
//     } on FirebaseAuthException catch (e) {
//       emit(state.copyWith(createAnAccountError: e.message));
//     }
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   Future<void> sendPasswordResetEmail(String email) async {
//     if (email == null || email.isEmpty) {
//       emit(state.copyWith(forgotPasswordError: 'Please enter your email'));
//       return;
//     }

//     await _auth.sendPasswordResetEmail(email);
//     Fluttertoast.showToast(msg: 'Email sent', gravity: ToastGravity.TOP);
//   }

//   Future<void> _determineUserTrack() async {
//     if (_userValue.status == UserLifeCycle.unauthenticated) {
//       emit(state.copyWith(
//         status: AuthLifeCycle.unauthenticated,
//       ));
//     } else if (_userValue.status == UserLifeCycle.authenticated) {
//       emit(state.copyWith(
//         status: AuthLifeCycle.authenticated,
//         user: _userValue,
//       ));
//       MyNavigator.pushAndRemoveUntil(AuthView());
//     }
//   }

//   @override
//   Future<void> close() async {
//     super.close();
//     _userSubscription.cancel();
//   }
// }
