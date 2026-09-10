import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait 2.5 seconds before navigating to onboarding
    Timer(
      const Duration(milliseconds: 2500),
      () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/onboarding1',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D8547),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Brand Icon & Title
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.apartment_rounded,
                size: 54,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // App Name
            const Text(
              'Luxeylin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Luxury Real Estate & Homes',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),

            const Spacer(),

            // Version
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Bottom indicator line
            Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}