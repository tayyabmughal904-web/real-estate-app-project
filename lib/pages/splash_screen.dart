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

    // Wait 3 seconds
    Timer(
      const Duration(seconds: 3),
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

            // Status bar area
            const SizedBox(height: 20),

            const Spacer(),

            // App name
            const Text(
              'Luxeyline',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            // Version
            const Text(
              'Version 156.2',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 8,
              ),
            ),

            const SizedBox(height: 10),

            // Bottom indicator
            Container(
              width: 70,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}