import 'package:flutter/material.dart';
import '../shared/theme/app_theme.dart';

class KrustyKonnectApp extends StatelessWidget {
  const KrustyKonnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrustyKonnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Center(child: Text("App is running")),
      ),
    );
  }
}