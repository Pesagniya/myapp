import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/textfield.dart';
import 'package:myapp/core/widgets/button.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            MyTextField(hintText: "Placeholder"),
            MyButton(
              text: "Placeholder",
              onTap: () {
                // Handle button tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
