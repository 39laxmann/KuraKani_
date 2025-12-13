import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //creating an instance jun chai we can reuse any no.of time
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOutRn() async {
    return await _auth.signOut();
  }

  //Sign up part
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //sign in function
  Future<UserCredential> signIn({
    required String email,
    required password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
