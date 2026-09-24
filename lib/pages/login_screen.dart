import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _showGoogleAccountSelector(AppState appState) {
    showModalBottomSheet(
      context: this.context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            top: 20,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(sheetCtx).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.g_mobiledata, size: 30, color: Color(0xFF4285F4)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Choose an account to continue to Luxeylin',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1, color: AppTheme.borderLight),
              const SizedBox(height: 8),
              ...AuthService.availableGoogleAccounts.map((account) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(account.avatarUrl),
                  ),
                  title: Text(
                    account.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    account.email,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textLight),
                  onTap: () async {
                    Navigator.pop(sheetCtx);
                    setState(() => _isLoading = true);

                    final response = await appState.signInWithGoogle(selectedAccount: account);
                    if (!mounted) return;
                    setState(() => _isLoading = false);

                    if (response.success) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text('Welcome back, ${account.name}!'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                      Navigator.pushReplacementNamed(this.context, '/home');
                    } else {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text(response.error ?? 'Google Sign-In failed'),
                          backgroundColor: AppTheme.error,
                        ),
                      );
                    }
                  },
                );
              }),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: const Icon(Icons.person_add_alt_1_outlined, size: 20, color: AppTheme.textSecondary),
                ),
                title: const Text(
                  'Sign in with another Google account',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(sheetCtx);
                  setState(() => _isLoading = true);
                  final response = await appState.signInWithGoogle();
                  if (!mounted) return;
                  setState(() => _isLoading = false);
                  if (response.success) {
                    Navigator.pushReplacementNamed(this.context, '/home');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleGoogleSignIn(AppState appState) async {
    setState(() => _isLoading = true);
    final response = await appState.signInWithGoogle();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response.success) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text('Welcome back, ${appState.userName}!'),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.pushReplacementNamed(this.context, '/home');
    } else {
      if (response.error != null && response.error!.contains('cancelled')) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In was cancelled')),
        );
      } else {
        _showGoogleAccountSelector(appState);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 36),

              // Logo & App Name
              SvgPicture.asset(
                'assets/logo.svg',
                width: 48,
                height: 48,
                placeholderBuilder: (context) {
                  return const Icon(
                    Icons.apartment_rounded,
                    size: 48,
                    color: AppTheme.primaryColor,
                  );
                },
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                'Get Started with Luxeylin',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Find, tour, and lease luxury homes with confidence.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 36),

              if (_isLoading) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ] else ...[
                // =========================
                // SOCIAL BUTTONS
                // =========================
                _socialButton(
  icon: Icons.g_mobiledata,
  iconColor: const Color(0xFF4285F4),
  text: 'Continue with Google',
  onPressed: () => _showGoogleAccountSelector(appState),
),

                const SizedBox(height: 12),

                _socialButton(
                  icon: Icons.apple,
                  iconColor: Colors.black,
                  text: 'Continue with Apple',
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    final resp = await appState.signInWithApple();
                    if (!mounted) return;
                    setState(() => _isLoading = false);
                    if (resp.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Welcome back with Apple ID!'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                ),

                const SizedBox(height: 12),

                _socialButton(
                  icon: Icons.facebook,
                  iconColor: const Color(0xFF1877F2),
                  text: 'Continue with Facebook',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Facebook login connected! Entering Luxeylin...'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),

                const SizedBox(height: 20),

                // =========================
                // OR DIVIDER
                // =========================
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Or continue with email',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 20),

                // =========================
                // EMAIL BUTTON
                // =========================
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/email-login');
                    },
                    icon: const Icon(Icons.mail_outline_rounded, size: 20),
                    label: const Text(
                      'Sign in with Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // GUEST EXPLORE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () async {
                      await appState.signInAsGuest();
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: const BorderSide(color: AppTheme.borderLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Explore as Guest',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

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
                      fontSize: 13.5,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required Color iconColor,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.borderLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: iconColor,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}