import 'package:flutter/material.dart';

class YourRidesScreen extends StatefulWidget {
  const YourRidesScreen({super.key});

  @override
  YourRidesScreenState createState() => YourRidesScreenState();
}

class YourRidesScreenState extends State<YourRidesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Placeholder Widget Demo'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Placeholder(
          strokeWidth: 1.0,
          color: Colors.indigoAccent,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              "This is a placeholder",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
