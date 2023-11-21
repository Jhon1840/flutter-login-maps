import 'package:flutter/material.dart';
import 'package:untitled3/maps/alert/user/data.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Alert'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person), // Cambiado a ícono de persona
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserData(),
              ),
            );
          },
        ),
      ],
    );
  }
}
