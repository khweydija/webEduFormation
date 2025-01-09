import 'package:flutter/material.dart';
import 'package:webpfe/Views/SettingsSheet.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      //backgroundColor: Color.fromARGB(255, 245, 244, 244),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue sur votre tableau de bord',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Text(
              //   'Bonne journée à vous',
              //   style: TextStyle(fontSize: 16, color: Colors.grey),
              // ),
            ],
          ),
          Row(
            children: [
              IconButton(
  icon: Icon(Icons.settings, color: Colors.black54),
  onPressed: () {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SettingsSheet();
      },
    );
  },
),

            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
