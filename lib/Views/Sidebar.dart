import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:webpfe/AppRoutes.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  Sidebar({required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      //color: Color.fromARGB(255, 245, 244, 244),
      child: SingleChildScrollView(
        // Added this
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 220,
                  width: 210,
                ), // Placeholder for logo
              ],
            ),
            _SidebarItem(
              icon: Icons.dashboard,
              text: 'Tableau de bord',
              isSelected: selectedIndex == 0,
              onTap: () {
                onItemSelected(0);
                Get.offAllNamed(AppRoutes.statisticsPage);
              },
            ),
            _SidebarItem(
              icon: Icons.apartment,
              text: 'Départements',
              isSelected: selectedIndex == 1,
              onTap: () {
                onItemSelected(1);
                Get.offAllNamed(AppRoutes.adminDashboardDepartement);
              },
            ),
            _SidebarItem(
              icon: Icons.star,
              text: 'Specialités',
              isSelected: selectedIndex == 2,
              onTap: () {
                onItemSelected(2);
                Get.offAllNamed(AppRoutes.adminDashboardSpecialite);
              },
            ),
            _SidebarItem(
              icon: Icons.person,
              text: ' Formateurs',
              isSelected: selectedIndex == 3,
              onTap: () {
                onItemSelected(3);
                Get.offAllNamed(AppRoutes.adminDashboardFormateur);
              },
            ),
            _SidebarItem(
              icon: Icons.people,
              text: 'Employées',
              isSelected: selectedIndex == 4,
              onTap: () {
                onItemSelected(4);
                Get.offAllNamed(AppRoutes.adminDashboardEmploye);
              },
            ),
            _SidebarItem(
              icon: Icons.category_sharp,
              text: ' Categories',
              isSelected: selectedIndex == 5,
              onTap: () {
                onItemSelected(5);
                Get.offAllNamed(AppRoutes.dashboardCatagorie);
              },
            ),
             _SidebarItem(
              icon: Icons.workspace_premium,
              text: ' Certifications',
              isSelected: selectedIndex == 6,
              onTap: () {
                onItemSelected(6);
               // Get.offAllNamed(AppRoutes.dashboardCatagorie);
              },
            ),
            _SidebarItem(
              icon: Icons.logout,
              text: 'Log out',
              isSelected: selectedIndex == 6,
              onTap: () {
                onItemSelected(6);
                Get.offAllNamed(AppRoutes.loginAdmin);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  _SidebarItem({
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: isSelected ?Color.fromARGB(255, 248, 247, 247) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Color(0xFF228D6D) : Colors.black54,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isSelected ? Color(0xFF228D6D) : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
