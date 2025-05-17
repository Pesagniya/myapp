import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/bottom_bar.dart'; // Import the Material3BottomNav

class YourRidesScreen extends StatelessWidget {
  const YourRidesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Your Rides Content')),
      bottomNavigationBar:
          const Material3BottomNav(), // Add the bottom navigation bar
    );
  }
}
