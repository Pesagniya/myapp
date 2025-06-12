import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final bool enabled;

  const MyTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        textAlign: textAlign,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
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
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          ),
          filled: true,
          fillColor:
              enabled
                  ? Theme.of(context).colorScheme.primary.withAlpha(10)
                  : Theme.of(context).colorScheme.onSurface.withAlpha(17),
        ),
      ),
    );
  }
}
