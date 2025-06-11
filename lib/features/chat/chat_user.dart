import 'package:flutter/material.dart';

class ChatUser extends StatelessWidget {
  final String receiverEmail;

  const ChatUser({super.key, required this.receiverEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Chat User")));
  }
}
