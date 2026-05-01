import 'package:flutter/material.dart';
import '../shared/theme/app_theme.dart';
import '../social/screens/login_screen.dart';

class KrustyKonnectApp extends StatelessWidget {
  const KrustyKonnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrustyKonnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}