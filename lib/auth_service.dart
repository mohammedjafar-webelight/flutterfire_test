import 'package:firebase_auth/firebase_auth.dart';

// Abstract class for auth service to enable testing
abstract class AuthServiceInterface {
  User? get currentUser;
  Stream<User?> get authStateChanges;
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<UserCredential> signInAnonymously();
  Future<void> updateUserProfile({String? displayName, String? photoURL});
}

class AuthService implements AuthServiceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  @override
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign up with email and password
  @override
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign out
  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Sign in anonymously
  @override
  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Update user profile
  @override
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Handle authentication errors
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-email':
          return 'The email address is invalid.';
        default:
          return error.message ?? 'An error occurred during authentication.';
      }
    }
    return 'An unexpected error occurred.';
  }
}
