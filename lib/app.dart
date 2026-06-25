import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/home_screen.dart';

class RubikSolveApp extends StatelessWidget {
  const RubikSolveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RubikSolve Pro',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.darkTheme,

      home: const HomeScreen(),
    );
  }
}