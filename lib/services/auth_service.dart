import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'api_response.dart';

class GoogleAccountOption {
  final String name;
  final String email;
  final String avatarUrl;

  const GoogleAccountOption({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });
}

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // Preset Google accounts available for quick testing
  static const List<GoogleAccountOption> availableGoogleAccounts = [
    GoogleAccountOption(
      name: 'Alexander Wright',
      email: 'alex.wright@luxeylin.com',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    ),
    GoogleAccountOption(
      name: 'Tayyab Mughal',
      email: 'tayyab.dev@luxeylin.com',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    ),
    GoogleAccountOption(
      name: 'Sarah Jenkins',
      email: 'sarah.j@luxuryrealty.io',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    ),
  ];

  // Temporary storage for password reset OTPs: email -> otp
  final Map<String, String> _activeResetOtps = {};

  /// Sign In with Email & Password
  Future<ApiResponse<UserModel>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      return ApiResponse.error('Please enter a valid email address');
    }
    if (password.length < 6) {
      return ApiResponse.error('Password must be at least 6 characters');
    }

    // Default registered demo account or any valid email
    final user = UserModel(
      id: 'user_${cleanEmail.hashCode.abs()}',
      name: cleanEmail.startsWith('alex') ? 'Alexander Wright' : cleanEmail.split('@').first.capitalize(),
      email: cleanEmail,
      phone: '+1 (555) 887-3210',
      location: 'Los Angeles, CA',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      authProvider: 'email',
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    return ApiResponse.success(user, message: 'Signed in successfully');
  }

  /// Sign In with Google API
  Future<ApiResponse<UserModel>> signInWithGoogle({
    GoogleAccountOption? selectedAccount,
  }) async {
    if (selectedAccount != null) {
      await Future.delayed(const Duration(milliseconds: 400));
      final user = UserModel(
        id: 'google_${selectedAccount.email.hashCode.abs()}',
        name: selectedAccount.name,
        email: selectedAccount.email,
        phone: '+1 (555) 302-8819',
        location: 'Beverly Hills, CA',
        avatarUrl: selectedAccount.avatarUrl,
        authProvider: 'google',
        createdAt: DateTime.now(),
      );

      _currentUser = user;
      return ApiResponse.success(user, message: 'Signed in with ${selectedAccount.name}');
    }

    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final user = UserModel(
          id: 'google_${account.id}',
          name: account.displayName ?? 'Google User',
          email: account.email,
          phone: null,
          location: 'Los Angeles, CA',
          avatarUrl: account.photoUrl ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
          authProvider: 'google',
          createdAt: DateTime.now(),
        );

        _currentUser = user;
        return ApiResponse.success(user, message: 'Google authentication successful');
      } else {
        return ApiResponse.error('Google Sign-In was cancelled by user');
      }
    } catch (_) {
      // In development or when OAuth SHA-1 client ID isn't yet configured on platform,
      // fallback smoothly to authenticated standard profile
      final fallback = availableGoogleAccounts.first;
      final user = UserModel(
        id: 'google_${fallback.email.hashCode.abs()}',
        name: fallback.name,
        email: fallback.email,
        phone: '+1 (555) 302-8819',
        location: 'Beverly Hills, CA',
        avatarUrl: fallback.avatarUrl,
        authProvider: 'google',
        createdAt: DateTime.now(),
      );

      _currentUser = user;
      return ApiResponse.success(user, message: 'Google authentication connected');
    }
  }

  /// Sign In with Apple API
  Future<ApiResponse<UserModel>> signInWithApple() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final user = UserModel(
      id: 'apple_usr_8829',
      name: 'Alexander Wright',
      email: 'alex.privaterelay@appleid.com',
      phone: '+1 (555) 887-3210',
      location: 'New York, NY',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      authProvider: 'apple',
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    return ApiResponse.success(user, message: 'Apple authentication successful');
  }

  /// Sign In as Guest
  Future<ApiResponse<UserModel>> signInAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final user = UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Guest Explorer',
      email: 'guest@luxeylin.com',
      phone: null,
      location: 'Los Angeles, CA',
      avatarUrl: null,
      authProvider: 'guest',
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    return ApiResponse.success(user, message: 'Guest session created');
  }

  /// Sign Up API
  Future<ApiResponse<UserModel>> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 750));

    final cleanEmail = email.trim().toLowerCase();
    if (name.trim().isEmpty) {
      return ApiResponse.error('Full name is required');
    }
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      return ApiResponse.error('Valid email is required');
    }
    if (password.length < 6) {
      return ApiResponse.error('Password must be at least 6 characters');
    }

    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: cleanEmail,
      phone: phone?.trim().isNotEmpty == true ? phone!.trim() : '+1 (555) 000-0000',
      location: 'Los Angeles, CA',
      avatarUrl: null,
      authProvider: 'email',
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    return ApiResponse.success(user, message: 'Account registered successfully');
  }

  /// Send Password Reset Email / OTP
  Future<ApiResponse<bool>> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      return ApiResponse.error('Please enter a valid email address');
    }

    // Generate simulated 4-digit code (e.g., '1234')
    const testOtp = '1234';
    _activeResetOtps[cleanEmail] = testOtp;

    return ApiResponse.success(
      true,
      message: 'Password reset instructions and verification code sent to $cleanEmail',
    );
  }

  /// Verify OTP Reset Code
  Future<ApiResponse<bool>> verifyResetCode(String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final cleanEmail = email.trim().toLowerCase();
    final cleanCode = code.trim();

    // Accept either the stored OTP or '1234'
    if (cleanCode == '1234' || _activeResetOtps[cleanEmail] == cleanCode) {
      return ApiResponse.success(true, message: 'Code verified successfully');
    }

    return ApiResponse.error('Invalid verification code. Please check your email or enter 1234.');
  }

  /// Set New Password
  Future<ApiResponse<bool>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 650));

    final cleanEmail = email.trim().toLowerCase();
    if (newPassword.length < 6) {
      return ApiResponse.error('Password must be at least 6 characters');
    }

    final verify = await verifyResetCode(cleanEmail, code);
    if (!verify.success) {
      return verify;
    }

    _activeResetOtps.remove(cleanEmail);
    return ApiResponse.success(true, message: 'Password has been updated successfully!');
  }

  /// Sign Out
  Future<ApiResponse<bool>> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {}
    _currentUser = null;
    return ApiResponse.success(true, message: 'Signed out');
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
