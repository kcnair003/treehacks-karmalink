import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/models.dart';

class FirebaseAuthService {
  final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;

  Stream<User> get user {
    return _auth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null
          ? User(status: UserLifeCycle.unauthenticated)
          : firebaseUser.toUser;
    });
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = firebaseAuth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

extension on firebaseAuth.User {
  User get toUser {
    return User(
      status: UserLifeCycle.authenticated,
      uid: this.uid,
      email: this.email,
    );
  }
}
