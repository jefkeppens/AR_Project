import 'package:flutter/material.dart';
import 'pages/player_list.dart';

void main() {
  runApp(const UserManagementApp());
}

class UserManagementApp extends StatelessWidget {
  // This widget is the root of your application.
  const UserManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const PlayerListPage(),
    );
  }
}
