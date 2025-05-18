import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.home, 0, context),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.description, 1, context),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.person, 2, context),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.notifications, 3, context),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 28,
          color: currentIndex == index
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        if (currentIndex == index)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}