import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kurakani/components/chat_bubble.dart';
import 'package:kurakani/components/my_textfields.dart';
import 'package:kurakani/services/auth/auth_service.dart';
import 'package:kurakani/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  // instantiating chat and auth services
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // scroll when keyboard opens
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollDown();
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // scroll to bottom
  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // send message
  void sendMessage() async {
    // send textfield is not empty send message
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
        widget.receiverID,
        _messageController.text,
      ); //send the damn msg

      _messageController.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollDown();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
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
      stream: _chatServices.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading.....");
        }

        // scroll AFTER list is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollDown();
        });

        // return list view
        return ListView(
          controller: _scrollController,
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
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    return ChatBubble(message: data['message'], isCurrentUser: isCurrentUser);
  }

  // build message  input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Row(
        children: [
          // Textfield should take up the most space
          Expanded(
            child: MyTextfields(
              myFocusNode: myFocusNode,
              hintText: "Type a message",
              obscureText: false,
              controller: _messageController,
            ),
          ),

          // send button
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
