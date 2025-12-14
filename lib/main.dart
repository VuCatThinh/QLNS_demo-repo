import 'package:flutter/material.dart';
import 'pages/admin/admin_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý nhân sự',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AdminHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
