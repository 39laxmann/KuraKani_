import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user safely
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Sign out
  Future<void> signOutRn() async {
    await _auth.signOut();
  }

  /// Sign up
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;

      // Save user info with lowercase email
      await _firestore.collection("Users").doc(user.uid).set({
        "uid": user.uid,
        "email": user.email,
        "emailLower": user.email!.toLowerCase(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  /// Sign in
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;

      // Update Firestore info safely
      await _firestore.collection("Users").doc(user.uid).set({
        "uid": user.uid,
        "email": user.email,
        "emailLower": user.email!.toLowerCase(),
        "lastLogin": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Update all existing users to have `emailLower` (run once safely)
  Future<void> addEmailLowerToAllUsers() async {
    final snapshot = await _firestore.collection("Users").get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final email = data['email'] as String?;
      if (email != null &&
          (data['emailLower'] == null || data['emailLower'].isEmpty)) {
        await doc.reference.set({
          'emailLower': email.toLowerCase(),
        }, SetOptions(merge: true));
        debugPrint("Updated ${doc.id} with emailLower");
      }
    }

    debugPrint("All existing users updated with emailLower!");
  }

  /// Robust prefix search (case-insensitive)
  Stream<QuerySnapshot> searchUsers(String query) {
    final q = query.toLowerCase().trim();

    return _firestore
        .collection("Users")
        .where("emailLower", isGreaterThanOrEqualTo: q)
        .where("emailLower", isLessThan: q + 'z')
        .snapshots();
  }
}
