import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/users_list_screen.dart';

Drawer drawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text('Тут заголовок'),
        ),
        ListTile(
          title: const Text('Окно логина'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginDemo()));
          },
        ),
        ListTile(
          title: const Text('Список юзеров'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => UsersListScreen()));
          },
        ),
      ],
    ),
  );
}
