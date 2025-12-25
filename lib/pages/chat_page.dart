import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kurakani/components/my_textfields.dart';
import 'package:kurakani/services/auth/auth_service.dart';
import 'package:kurakani/services/chat/chat_services.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  //text controller
  final TextEditingController _messageController = TextEditingController();

  // instantiating chat and auth services
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  // send message
  void sendMessage() async {
    // send textfield is not empty send message
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
        receiverID,
        _messageController.text,
      ); //send the damn msg

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(child: _builMessageList()),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _builMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatServices.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading.....");
        }

        // return list view
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data["senderId"] == _authService.getCurrentUser()!.uid;

    // align the message to the right is the sender is the current user, otherwise left
    var alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [Text(data["message"])],
      ),
    );
  }

  // build message  input
  Widget _buildUserInput() {
    return Row(
      children: [
        // Textfield should take up the most space
        Expanded(
          child: MyTextfields(
            hintText: "Type a message",
            obscureText: false,
            controller: _messageController,
          ),
        ),

        // send button
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
      ],
    );
  }
}
