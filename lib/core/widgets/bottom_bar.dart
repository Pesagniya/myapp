import 'package:flutter/material.dart';
import 'package:myapp/features/rides/presentation/screens/your_rides.dart';

class Material3BottomNav extends StatefulWidget {
  const Material3BottomNav({Key? key}) : super(key: key);

  @override
  State<Material3BottomNav> createState() => _Material3BottomNavState();
}

/* class _Material3BottomNavState extends State<Material3BottomNav> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
} */

class _Material3BottomNavState extends State<Material3BottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    YourRidesScreen(),
    YourRidesScreen(),
    YourRidesScreen(),
    YourRidesScreen(),
    YourRidesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
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
