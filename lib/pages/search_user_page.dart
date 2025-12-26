import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kurakani/pages/chat_page.dart';
import 'package:kurakani/services/auth/auth_service.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final TextEditingController _searchController = TextEditingController();
  final AuthService _authService = AuthService();

  String searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.getCurrentUser();
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("No user signed in")));
    }
    final currentUserId = currentUser.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Search Users")),
      body: Column(
        children: [
          // 🔍 Search input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search by email",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),

          // 🔎 Results
          Expanded(
            child: searchQuery.isEmpty
                ? const Center(child: Text("Type to search users"))
                : StreamBuilder<QuerySnapshot>(
                    stream: _authService.searchUsers(searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text("Error loading users"));
                      }

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // DEBUG: print all returned docs
                      debugPrint(
                        "Returned docs: ${snapshot.data!.docs.length}",
                      );
                      for (var doc in snapshot.data!.docs) {
                        final data = doc.data() as Map<String, dynamic>;
                        debugPrint(data.toString());
                      }

                      // Filter out current user
                      final users = snapshot.data!.docs
                          .where(
                            (doc) =>
                                (doc.data() as Map<String, dynamic>)['uid'] !=
                                currentUserId,
                          )
                          .toList();

                      if (users.isEmpty) {
                        return const Center(child: Text("No users found"));
                      }

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final data =
                              users[index].data() as Map<String, dynamic>;
                          final email = data['email'] as String?;
                          final uid = data['uid'] as String?;

                          if (email == null || uid == null) return SizedBox();

                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(email),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatPage(
                                    receiverEmail: email,
                                    receiverID: uid,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
