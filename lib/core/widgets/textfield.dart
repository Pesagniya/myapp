import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;

  const MyTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          hintText: hintText,
          filled: true,
          fillColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.10),
        ),
      ),
    );
  }
}
