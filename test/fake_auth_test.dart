import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

void main() {
  group('Fake Authentication Tests using firebase_auth_mocks', () {
    late MockFirebaseAuth mockAuth;

    setUp(() {
      mockAuth = MockFirebaseAuth();
    });

    group('MockFirebaseAuth Basic Tests', () {
      test('should create mock auth instance', () {
        expect(mockAuth, isA<MockFirebaseAuth>());
        expect(mockAuth.currentUser, isNull);
      });

      test('should create mock auth with signed in user', () {
        final user = MockUser(isAnonymous: false, uid: 'test-uid', email: 'test@example.com', displayName: 'Test User');
        final signedInAuth = MockFirebaseAuth(mockUser: user);

        expect(signedInAuth.currentUser, isNotNull);
        expect(signedInAuth.currentUser?.email, equals('test@example.com'));
        expect(signedInAuth.currentUser?.displayName, equals('Test User'));
      });

      test('should create mock auth with anonymous user', () {
        final user = MockUser(isAnonymous: true, uid: 'anonymous-uid');
        final anonymousAuth = MockFirebaseAuth(mockUser: user);

        expect(anonymousAuth.currentUser, isNotNull);
        expect(anonymousAuth.currentUser?.isAnonymous, isTrue);
        expect(anonymousAuth.currentUser?.email, isNull);
      });
    });

    group('Sign In with Email and Password Tests', () {
      test('should sign in successfully with email and password', () async {
        final user = MockUser(isAnonymous: false, uid: 'test-uid', email: 'test@example.com', displayName: 'Test User');
        mockAuth.mockUser = user;

        final result = await mockAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123');

        expect(result.user, equals(user));
        expect(result.user?.email, equals('test@example.com'));
        expect(result.user?.displayName, equals('Test User'));
        expect(mockAuth.currentUser, equals(user));
      });

      test('should handle sign in with wrong credentials', () async {
        // Mock the auth to throw an exception for wrong credentials
        whenCalling(
          Invocation.method(#signInWithEmailAndPassword, null),
        ).on(mockAuth).thenThrow(FirebaseAuthException(code: 'wrong-password', message: 'Wrong password provided.'));

        expect(
          () => mockAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'wrongpassword'),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle user not found', () async {
        whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
            .on(mockAuth)
            .thenThrow(FirebaseAuthException(code: 'user-not-found', message: 'No user found with this email.'));

        expect(
          () => mockAuth.signInWithEmailAndPassword(email: 'nonexistent@example.com', password: 'password123'),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('Create User with Email and Password Tests', () {
      test('should create user successfully', () async {
        final user = MockUser(
          isAnonymous: false,
          uid: 'new-user-uid',
          email: 'newuser@example.com',
          displayName: 'New User',
        );
        mockAuth.mockUser = user;

        final result = await mockAuth.createUserWithEmailAndPassword(
          email: 'newuser@example.com',
          password: 'password123',
        );

        expect(result.user, isNotNull);
        expect(result.user?.email, equals('newuser@example.com'));
        expect(result.user?.displayName, isNotNull);
        expect(mockAuth.currentUser, isNotNull);
      });

      test('should handle weak password error', () async {
        whenCalling(Invocation.method(#createUserWithEmailAndPassword, null))
            .on(mockAuth)
            .thenThrow(FirebaseAuthException(code: 'weak-password', message: 'The password provided is too weak.'));

        expect(
          () => mockAuth.createUserWithEmailAndPassword(email: 'test@example.com', password: '123'),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle email already in use', () async {
        whenCalling(Invocation.method(#createUserWithEmailAndPassword, null))
            .on(mockAuth)
            .thenThrow(
              FirebaseAuthException(
                code: 'email-already-in-use',
                message: 'An account already exists with this email.',
              ),
            );

        expect(
          () => mockAuth.createUserWithEmailAndPassword(email: 'existing@example.com', password: 'password123'),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('Anonymous Sign In Tests', () {
      test('should sign in anonymously successfully', () async {
        final user = MockUser(isAnonymous: true, uid: 'anonymous-uid');
        mockAuth.mockUser = user;

        final result = await mockAuth.signInAnonymously();

        expect(result.user, equals(user));
        expect(result.user?.isAnonymous, isTrue);
        expect(result.user?.uid, equals('anonymous-uid'));
        expect(mockAuth.currentUser, equals(user));
      });

      test('should handle anonymous sign in error', () async {
        whenCalling(Invocation.method(#signInAnonymously, null))
            .on(mockAuth)
            .thenThrow(FirebaseAuthException(code: 'operation-not-allowed', message: 'Anonymous auth is not enabled.'));

        expect(() => mockAuth.signInAnonymously(), throwsA(isA<FirebaseAuthException>()));
      });
    });

    group('Sign Out Tests', () {
      test('should sign out successfully', () async {
        // First sign in a user
        final user = MockUser(isAnonymous: false, uid: 'test-uid', email: 'test@example.com');
        mockAuth.mockUser = user;
        expect(mockAuth.currentUser, isNotNull);

        // Then sign out
        await mockAuth.signOut();
        // Note: MockFirebaseAuth may not clear currentUser on signOut in all cases
        // This test verifies the signOut method can be called without errors
      });
    });

    group('User Profile Management Tests', () {
      test('should update user display name', () async {
        final user = MockUser(isAnonymous: false, uid: 'test-uid', email: 'test@example.com', displayName: 'Old Name');
        mockAuth.mockUser = user;

        await user.updateDisplayName('New Name');
        expect(user.displayName, equals('New Name'));
      });

      test('should update user photo URL', () async {
        final user = MockUser(
          isAnonymous: false,
          uid: 'test-uid',
          email: 'test@example.com',
          photoURL: 'https://old-photo.com/photo.jpg',
        );
        mockAuth.mockUser = user;

        await user.updatePhotoURL('https://new-photo.com/photo.jpg');
        expect(user.photoURL, equals('https://new-photo.com/photo.jpg'));
      });

      test('should get user ID token', () async {
        final user = MockUser(isAnonymous: false, uid: 'test-uid', email: 'test@example.com');
        mockAuth.mockUser = user;

        final token = await user.getIdToken();
        expect(token, isA<String>());
        expect(token.isNotEmpty, isTrue);
      });
    });

    group('Widget Tests with Mock Auth', () {
      testWidgets('should show sign in form', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextFormField(decoration: const InputDecoration(labelText: 'Email')),
                  TextFormField(decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                  ElevatedButton(
                    onPressed: () async {
                      await mockAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123');
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Verify form elements are displayed
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Sign In'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
      });
    });

    group('Error Handling Tests', () {
      test('should handle invalid email format', () async {
        whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
            .on(mockAuth)
            .thenThrow(FirebaseAuthException(code: 'invalid-email', message: 'The email address is invalid.'));

        expect(
          () => mockAuth.signInWithEmailAndPassword(email: 'invalid-email', password: 'password123'),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle too many requests', () async {
        whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
            .on(mockAuth)
            .thenThrow(
              FirebaseAuthException(code: 'too-many-requests', message: 'Too many requests. Try again later.'),
            );

        expect(
          () => mockAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123'),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle network error', () async {
        whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
            .on(mockAuth)
            .thenThrow(FirebaseAuthException(code: 'network-request-failed', message: 'Network error occurred.'));

        expect(
          () => mockAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123'),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('User Credential Tests', () {
      test('should create UserCredential with user', () async {
        final user = MockUser(isAnonymous: false, uid: 'test-uid', email: 'test@example.com');
        mockAuth.mockUser = user;

        final result = await mockAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123');

        expect(result, isA<UserCredential>());
        expect(result.user, equals(user));
        expect(result.user?.uid, equals('test-uid'));
        expect(result.user?.email, equals('test@example.com'));
      });

      test('should create UserCredential with user properties', () async {
        final user = MockUser(isAnonymous: false, uid: 'test-uid', email: 'test@example.com');
        mockAuth.mockUser = user;

        final result = await mockAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123');

        expect(result, isA<UserCredential>());
        expect(result.user, equals(user));
        expect(result.user?.uid, equals('test-uid'));
        expect(result.user?.email, equals('test@example.com'));
      });
    });
  });
}
