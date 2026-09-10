import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const ConvivaApp());
}

class ConvivaApp extends StatelessWidget {
  const ConvivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conviva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
