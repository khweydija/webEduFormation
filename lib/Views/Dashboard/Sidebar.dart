import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  Sidebar({required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color.fromARGB(255, 245, 244, 244),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Image.asset('assets/images/logo.png',
                  height: 190, width: 200), // Placeholder for logo
            ],
          ),
          _SidebarItem(
            icon: Icons.dashboard,
            text: 'Dashboard',
            isSelected: selectedIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          _SidebarItem(
            icon: Icons.person,
            text: 'Gestion des Formateurs',
            isSelected: selectedIndex == 1,
            onTap: () => onItemSelected(1),
          ),
          _SidebarItem(
            icon: Icons.people,
            text: 'Gestion des Employees',
            isSelected: selectedIndex == 2,
            onTap: () => onItemSelected(2),
          ),
          _SidebarItem(
            icon: Icons.analytics,
            text: 'Gestion des Categories',
            isSelected: selectedIndex == 3,
            onTap: () => onItemSelected(3),
          ),
          _SidebarItem(
            icon: Icons.settings,
            text: 'Setting',
            isSelected: selectedIndex == 4,
            onTap: () => onItemSelected(4),
          ),
          _SidebarItem(
            icon: Icons.logout,
            text: 'Log out',
            isSelected: selectedIndex == 5,
            onTap: () => onItemSelected(5),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  _SidebarItem({required this.icon, required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0), // Margin to create space between items
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent, // White background when selected
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Color(0xFF228D6D) : Colors.black54),
        title: Text(
          text,
          style: TextStyle(
            color: isSelected ? Color(0xFF228D6D) : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Padding inside the tile
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Ensure the shape matches the background
        ),
      ),
    );
  }
}
