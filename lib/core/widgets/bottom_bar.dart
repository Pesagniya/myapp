import 'package:flutter/material.dart';
import 'package:myapp/features/rides/your_rides.dart';
import 'package:myapp/features/search/search_ride.dart';
import 'package:myapp/features/offer/offer_ride.dart';
import 'package:myapp/features/chat/chat.dart';
import 'package:myapp/features/profile/your_profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _Material3BottomNavState();
}

class _Material3BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final List _pages = [
    YourRidesScreen(),
    SearchRidesScreen(),
    PostRidesScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navBarItems,
      ),
    );
  }
}

const _navBarItems = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.image_search_outlined),
    selectedIcon: Icon(Icons.image_search_rounded),
    label: 'Procurar',
  ),
  NavigationDestination(
    icon: Icon(Icons.add_outlined),
    selectedIcon: Icon(Icons.add_rounded),
    label: 'Oferecer',
  ),
  NavigationDestination(
    icon: Icon(Icons.chat),
    selectedIcon: Icon(Icons.chat_rounded),
    label: 'Chat',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline_rounded),
    selectedIcon: Icon(Icons.person_rounded),
    label: 'Perfil',
  ),
];
