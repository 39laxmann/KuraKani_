import 'package:flutter/material.dart';
import 'package:kurakani/components/user_tile.dart';
import 'package:kurakani/pages/chat_page.dart';
import 'package:kurakani/services/auth/auth_service.dart';
import 'package:kurakani/components/my_drawer.dart';
import 'package:kurakani/services/chat/chat_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // yo chai chat ra auth service access garna lai
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  void logout() {
    _authService.signOutRn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      drawer: MyDrawer(),
      body: _builUserList(),
    );
  }

  Widget _builUserList() {
    return StreamBuilder(
      stream: _chatServices.getUserStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return list view

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _builUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual list tile for user
  Widget _builUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    // skip invalid user and current user
    if (userData["email"] == null || userData["uid"] == null) {
      return const SizedBox.shrink();
    }
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          //tapped on a user -> go to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
