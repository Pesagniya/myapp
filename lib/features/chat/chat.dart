import 'package:flutter/material.dart';
import 'package:myapp/features/chat/user_tile.dart';
import 'package:myapp/features/auth/auth_service.dart';
import 'package:myapp/features/chat/chat_service.dart';
import 'package:myapp/features/chat/chat_user.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: _buildChatList(),
    );
  }

  Widget _buildChatList() {
    return StreamBuilder(
      stream: _chatService.getChats(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data!;
          return ListView(
            children:
                users.map((userData) {
                  return _buildChatListItem(userData, context);
                }).toList(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildChatListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    return UserTile(
      email: userData['email'],
      photoUrl: userData['photoUrl'] ?? '',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatUser(receiverEmail: userData['email']),
          ),
        );
      },
    );
  }
}
