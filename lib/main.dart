import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/onboarding_screen1.dart';
import 'screens/onboarding_screen2.dart';
import 'screens/onboarding_screen3.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const LuxeylineApp());
}

class LuxeylineApp extends StatelessWidget {
  const LuxeylineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luxeyline',

      // First screen
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),

        '/onboarding1': (context) => const OnboardingScreen1(),

        '/onboarding2': (context) => const OnboardingScreen2(),

        '/onboarding3': (context) => const OnboardingScreen3(),

        '/login': (context) => const LoginScreen(),
      },
    );
  }
}