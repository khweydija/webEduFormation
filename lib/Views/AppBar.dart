import 'package:flutter/material.dart';
import 'package:webpfe/Views/SettingsSheet.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Remplacement du texte par l'icône menu
              Icon(
                Icons.menu, // L'icône utilisée
                size: 32, // Taille de l'icône
                color: Colors.black, // Couleur de l'icône
              ),
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
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
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
