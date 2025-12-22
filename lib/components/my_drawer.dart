import 'package:flutter/material.dart';
import 'package:kurakani/services/auth/auth_service.dart';
import 'package:kurakani/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final auth = AuthService();
    auth.signOutRn();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header icon of drawer
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              //listtile = used to create single row item

              //Home list tile
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: const Text("H  O  M  E"),
                  onTap: () {
                    debugPrint("Home button pressed");

                    //pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              //settings list tile
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: const Text("S  E  T  T  I  N  G"),
                  onTap: () {
                    debugPrint("settings button pressed");

                    //navigate to the settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ),
            ],
          ),

          //logout button list tile
          Padding(
            padding: const EdgeInsets.only(left: 30.0, bottom: 40),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: const Text("L  O  G  O  U  T "),
              onTap: () {
                debugPrint("Logout button pressed");
                logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
