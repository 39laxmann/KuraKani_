import 'package:flutter/material.dart';
import 'package:kurakani/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    // know if darkmode is enable or not??
    bool isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? (isDarkMode ? Colors.green.shade600 : Colors.blue)
                  : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isCurrentUser
                    ? Colors.white
                    : const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
