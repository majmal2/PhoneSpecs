import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PhoneSpecsApp());
}

class PhoneSpecsApp extends StatelessWidget {
  const PhoneSpecsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhoneSpecs - IT 315',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}