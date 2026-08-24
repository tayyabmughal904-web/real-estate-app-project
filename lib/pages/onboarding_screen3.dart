import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // =========================
            // TOP BAR
            // =========================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/login',
                      );
                    },

                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF0D8547),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =========================
            // IMAGE
            // =========================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: Image.asset(
                  'assets/images/house3.jpg',

                  height: 285,
                  width: double.infinity,

                  fit: BoxFit.cover,

                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      height: 285,
                      color: Colors.grey.shade200,

                      child: const Center(
                        child: Icon(
                          Icons.apartment,
                          size: 70,
                          color: Color(0xFF0D8547),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            // =========================
            // DOTS
            // =========================

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                _dot(false),
                _dot(false),
                _dot(true),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // TITLE
            // =========================

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),

              child: Text(
                'Local expertise for luxury homes',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // DESCRIPTION
            // =========================

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 45,
              ),

              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 9,
                  height: 1.5,
                  color: Colors.grey,
                ),
              ),
            ),

            const Spacer(),

            // =========================
            // GET STARTED
            // =========================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 48,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/login',
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D8547),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),

                    elevation: 0,
                  ),

                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 3,
      ),

      width: 6,
      height: 6,

      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF0D8547)
            : Colors.grey.shade300,

        shape: BoxShape.circle,
      ),
    );
  }
}