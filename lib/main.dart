import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'state/app_state.dart';

import 'pages/splash_screen.dart';
import 'pages/onboarding_screen1.dart';
import 'pages/onboarding_screen2.dart';
import 'pages/onboarding_screen3.dart';
import 'pages/login_screen.dart';
import 'pages/auth/email_login_screen.dart';
import 'pages/auth/signup_screen.dart';
import 'pages/auth/forgot_password_screen.dart';
import 'pages/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    AppStateScope(
      notifier: AppState(),
      child: const LuxeylinApp(),
    ),
  );
}

class LuxeylinApp extends StatelessWidget {
  const LuxeylinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luxeylin Real Estate',
      theme: AppTheme.lightTheme,

      // Starting route
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/onboarding3': (context) => const OnboardingScreen3(),
        '/login': (context) => const LoginScreen(),
        '/email-login': (context) => const EmailLoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const MainNavigationScreen(initialIndex: 0),
        '/explore': (context) => const MainNavigationScreen(initialIndex: 1),
        '/saved': (context) => const MainNavigationScreen(initialIndex: 2),
        '/messages': (context) => const MainNavigationScreen(initialIndex: 3),
        '/profile': (context) => const MainNavigationScreen(initialIndex: 4),
      },
    );
  }
}