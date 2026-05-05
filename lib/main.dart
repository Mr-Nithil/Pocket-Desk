import 'package:flutter/material.dart';
import 'package:pocket_desk/config/theme/theme.dart';
import 'package:pocket_desk/features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PocketDesk',
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      home: LoginPage(),
    );
  }
}
