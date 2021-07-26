import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final int indexToShow;
  final ValueChanged<int> itemPressed;

  NavigationBar({
    required this.itemPressed,
    required this.indexToShow,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.green[900],
      unselectedItemColor: Colors.white30,
      selectedItemColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      currentIndex: indexToShow,
      onTap: itemPressed,
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.thermostat_outlined),
          label: 'Tilt',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate_outlined),
          label: 'Calculator',
        )
      ],
    );
  }
}
