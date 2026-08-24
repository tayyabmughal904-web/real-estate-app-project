import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),

          child: Column(
            children: [

              const SizedBox(height: 35),

              // =========================
              // LOGO
              // =========================

              SvgPicture.asset(
                'assets/logo.svg',

                width: 45,
                height: 45,

                placeholderBuilder: (context) {
                  return const Icon(
                    Icons.park,
                    size: 45,
                    color: Color(0xFF0D8547),
                  );
                },
              ),

              const SizedBox(height: 10),

              // =========================
              // TITLE
              // =========================

              const Text(
                'Get Started',

                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Welcome! Let's dive into your account.",

                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // GOOGLE
              // =========================

              _socialButton(
                icon: Icons.g_mobiledata,
                text: 'Sign in with Google',
                onPressed: () {
                  _showMessage(
                    context,
                    'Google Sign In clicked',
                  );
                },
              ),

              const SizedBox(height: 8),

              // =========================
              // APPLE
              // =========================

              _socialButton(
                icon: Icons.apple,
                text: 'Sign in with Apple',
                onPressed: () {
                  _showMessage(
                    context,
                    'Apple Sign In clicked',
                  );
                },
              ),

              const SizedBox(height: 8),

              // =========================
              // FACEBOOK
              // =========================

              _socialButton(
                icon: Icons.facebook,
                text: 'Sign in with Facebook',
                onPressed: () {
                  _showMessage(
                    context,
                    'Facebook Sign In clicked',
                  );
                },
              ),

              const SizedBox(height: 12),

              // =========================
              // OR
              // =========================

              Row(
                children: [

                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),

                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // =========================
              // EMAIL BUTTON
              // =========================

              SizedBox(
                width: double.infinity,
                height: 42,

                child: ElevatedButton(
                  onPressed: () {
                    _showMessage(
                      context,
                      'Email Sign In clicked',
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
                    'Sign in with Email',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // =========================
              // SIGN UP
              // =========================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      _showMessage(
                        context,
                        'Sign Up clicked',
                      );
                    },

                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 8,
                        color: Color(0xFF0D8547),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // SOCIAL BUTTON
  // =========================

  Widget _socialButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 40,

      child: OutlinedButton(
        onPressed: onPressed,

        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.grey.shade300,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),

        child: Row(
          children: [

            Icon(
              icon,
              size: 17,
              color: Colors.black,
            ),

            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // SNACKBAR
  // =========================

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}