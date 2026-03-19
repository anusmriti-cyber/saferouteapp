import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';

  // Current user session
  static User? get _currentUser => _auth.currentUser;

  // Initialize service and load saved data
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Load saved login credentials if remember me was enabled
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    if (rememberMe && _auth.currentUser == null) {
      final savedEmail = prefs.getString(_savedEmailKey);
      final savedPassword = prefs.getString(_savedPasswordKey);

      if (savedEmail != null && savedPassword != null) {
        try {
          await login(
            email: savedEmail,
            password: savedPassword,
            rememberMe: false,
          );
        } catch (e) {
          // If auto-login fails, clear saved credentials
          await _clearSavedCredentials();
        }
      }
    }
  }

  // Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  // Get current user data as Map
  static Map<String, dynamic>? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return {
      'id': user.uid,
      'name': user.displayName ?? 'User',
      'email': user.email,
      'phone': user.phoneNumber ?? '',
    };
  }

  // Get saved email for auto-fill
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedEmailKey);
  }

  // Login method refinement
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // Save credentials if remember me is enabled
      if (rememberMe) {
        await _saveCredentials(email, password);
      } else {
        await _clearSavedCredentials();
      }

      return {
        'id': user.uid,
        'name': user.displayName ?? 'User',
        'email': user.email,
        'phone': user.phoneNumber ?? '',
      };
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  // Sign up method refinement
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // Update display name
      await user.updateDisplayName(name);

      // Save credentials if remember me is enabled
      if (rememberMe) {
        await _saveCredentials(email, password);
      }

      return {
        'id': user.uid,
        'name': name,
        'email': email,
        'phone': phone,
      };
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  // Helper to handle Firebase errors
  static String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }

  // Logout method
  static Future<void> logout() async {
    await _auth.signOut();
    await _clearSavedCredentials();
  }

  // Save credentials to persistent storage
  static Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, true);
    await prefs.setString(_savedEmailKey, email);
    await prefs.setString(_savedPasswordKey, password);
  }

  // Clear saved credentials
  static Future<void> _clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_savedPasswordKey);
  }
}
