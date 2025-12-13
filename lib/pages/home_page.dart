import 'package:flutter/material.dart';
import 'package:kurakani/auth/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  void logout() {
    final authService = AuthService();
    authService.signOutRn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
    );
  }
}
