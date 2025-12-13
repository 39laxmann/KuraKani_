import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kurakani/auth/login_or_register.dart';
import 'package:kurakani/pages/home_page.dart';
import 'package:kurakani/pages/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //if user is logged in
        if (snapshot.hasData) {
          return HomePage();
        }
        //if user is not logged in
        else {
          return LoginOrRegister();
        }
      },
    );
  }
}
