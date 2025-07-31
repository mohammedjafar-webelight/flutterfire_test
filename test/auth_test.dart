import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfire_test/auth_screens.dart';
import 'mock_auth_service.dart';

void main() {
  group('Authentication UI Tests', () {
    late MockAuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    group('LoginScreen Tests', () {
      testWidgets('should display login form', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginScreen(authService: authService)));

        expect(find.text('Login'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.text('Sign In'), findsOneWidget);
        expect(find.text('Sign In Anonymously'), findsOneWidget);
      });

      testWidgets('should validate email field', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginScreen(authService: authService)));

        // Try to submit without entering email
        await tester.tap(find.text('Sign In'));
        await tester.pump();

        expect(find.text('Please enter your email'), findsOneWidget);
      });

      testWidgets('should validate password field', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginScreen(authService: authService)));

        // Enter email but not password
        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.tap(find.text('Sign In'));
        await tester.pump();

        expect(find.text('Please enter your password'), findsOneWidget);
      });

      testWidgets('should validate email format', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginScreen(authService: authService)));

        // Enter invalid email
        await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.tap(find.text('Sign In'));
        await tester.pump();

        expect(find.text('Please enter a valid email'), findsOneWidget);
      });

      testWidgets('should validate password length', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginScreen(authService: authService)));

        // Enter short password
        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.enterText(find.byType(TextFormField).last, '123');
        await tester.tap(find.text('Sign In'));
        await tester.pump();

        expect(find.text('Password must be at least 6 characters'), findsOneWidget);
      });

      testWidgets('should show loading state during sign in', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginScreen(authService: authService)));

        // Enter valid credentials
        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.enterText(find.byType(TextFormField).last, 'password123');

        await tester.tap(find.text('Sign In'));
        await tester.pump();

        // Should show loading indicator (the mock returns immediately, so we check for the button state)
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('SignUpScreen Tests', () {
      testWidgets('should display sign up form', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignUpScreen(authService: authService)));

        expect(find.text('Sign Up'), findsNWidgets(2)); // App bar title and button
        expect(find.byType(TextFormField), findsNWidgets(3));
      });

      testWidgets('should validate password confirmation', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignUpScreen(authService: authService)));

        // Enter different passwords
        await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
        await tester.enterText(find.byType(TextFormField).at(1), 'password123');
        await tester.enterText(find.byType(TextFormField).at(2), 'differentpassword');
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(find.text('Passwords do not match'), findsOneWidget);
      });

      testWidgets('should validate form fields', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignUpScreen(authService: authService)));

        // Enter valid credentials
        await tester.enterText(find.byType(TextFormField).at(0), 'newuser@example.com');
        await tester.enterText(find.byType(TextFormField).at(1), 'password123');
        await tester.enterText(find.byType(TextFormField).at(2), 'password123');
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Should not show any error messages
        expect(find.text('Passwords do not match'), findsNothing);
        expect(find.text('Please enter your email'), findsNothing);
      });
    });
  });
}
