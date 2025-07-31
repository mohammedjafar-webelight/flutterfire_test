import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_test/auth_service.dart';

// Mock auth service that doesn't require Firebase initialization
class MockAuthService implements AuthServiceInterface {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Stream<User?> get authStateChanges => Stream.value(_currentUser);

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    // Mock implementation - just return a mock user credential
    return Future.value(MockUserCredential());
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    // Mock implementation - just return a mock user credential
    return Future.value(MockUserCredential());
  }

  Future<void> signOut() async {
    _currentUser = null;
  }

  Future<UserCredential> signInAnonymously() async {
    // Mock implementation - just return a mock user credential
    return Future.value(MockUserCredential());
  }

  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    // Mock implementation
  }
}

class MockUserCredential implements UserCredential {
  @override
  User? get user => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
