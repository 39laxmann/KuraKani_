import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //creating an instance jun chai we can reuse any no.of time
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //for firebaase database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signOutRn() async {
    return await _auth.signOut();
  }

  //Sign up part
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      // create user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // save user info in a seperate doc
      final user = userCredential.user!;
      await _firestore.collection("Users").doc(user.uid).set({
        "uid": user.uid,
        "email": user.email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign in function
  Future<UserCredential> signIn({
    required String email,
    required password,
  }) async {
    try {
      // sign user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;

      // save user info , if it doesn't already exist
      _firestore.collection("Users").doc(user.uid).set({
        "uid": user.uid,
        "email": user.email,
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
