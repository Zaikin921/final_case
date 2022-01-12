import 'package:flutter/material.dart';

import 'screens/users_list_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users list',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Список пользователей'),
        ),
        body: Center(child: UsersListScreen()),
      ),
    );
  }
}
