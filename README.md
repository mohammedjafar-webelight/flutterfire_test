# FlutterFire Testing Demo

A simple Flutter app demonstrating Firebase Firestore and Authentication integration with comprehensive testing using fakes.

## Features

- **Task Management**: Add and toggle completion of tasks
- **User Authentication**: Sign in/up with email/password or anonymously
- **Real-time Updates**: Tasks update in real-time using Firestore streams
- **Comprehensive Testing**: Unit and widget tests using `fake_cloud_firestore` and `firebase_auth_mocks`

## App Structure

```
lib/
├── main.dart          # App entry point with Firebase initialization
├── task_app.dart      # Main app widget and home page with auth wrapper
├── task_list.dart     # Widget to display tasks from Firestore
├── auth_service.dart  # Authentication service with error handling
└── auth_screens.dart  # Login and signup screens
```

## Testing

### Unit Tests with Fakes

The app uses `fake_cloud_firestore` for Firestore testing and `firebase_auth_mocks` for authentication testing, which simulate Firebase behavior without requiring a real Firebase connection.

**Key Testing Concepts:**

1. **Fake Database**: `FakeFirebaseFirestore()` simulates Firestore
2. **Mock Authentication**: `MockAuthService` implements `AuthServiceInterface` for testing
3. **Data Population**: Pre-populate fake database with test data
4. **Stream Testing**: Test real-time updates using `tester.idle()` and `tester.pump()`
5. **Widget Interaction**: Test user interactions like tapping buttons and checkboxes
6. **Form Validation**: Test input validation and error handling

### Test Coverage

**Firestore Tests:**
- ✅ Display tasks from Firestore
- ✅ Show empty state when no tasks
- ✅ Toggle task completion
- ✅ Loading states
- ✅ Individual widget testing

**Authentication Tests:**
- ✅ Login form validation (email, password, format)
- ✅ Signup form validation (email, password, confirmation)
- ✅ Loading states during authentication
- ✅ Error handling and user feedback
- ✅ Form field validation

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/task_app_test.dart
```

## Firebase Setup

This demo uses FlutterFire CLI for Firebase configuration:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

## Dependencies

- `firebase_core`: Firebase initialization
- `cloud_firestore`: Firestore database
- `firebase_auth`: Firebase Authentication
- `fake_cloud_firestore`: Testing fakes (dev dependency)
- `firebase_auth_mocks`: Authentication testing (dev dependency)

## Testing Best Practices Demonstrated

1. **Use Fakes for Unit Tests**: Avoid real Firebase calls in tests
2. **Interface-based Design**: Use abstract classes for better testability
3. **Mock Authentication**: Test auth flows without Firebase initialization
4. **Test Stream Behavior**: Handle async streams properly with `tester.idle()`
5. **Isolate Components**: Test individual widgets separately
6. **Mock User Interactions**: Test button taps, form submissions, etc.
7. **Verify UI States**: Check loading, empty, and populated states
8. **Form Validation Testing**: Test input validation and error handling

## Integration Testing

For integration tests with the Firestore emulator:

1. Start Firestore emulator: `firebase emulators:start --only firestore`
2. Configure app to use emulator (see `test/integration_test.dart` example)
3. Run integration tests

## References

- [FlutterFire Testing Documentation](https://firebase.flutter.dev/docs/testing/testing/)
- [fake_cloud_firestore Package](https://pub.dev/packages/fake_cloud_firestore)
- [Flutter Testing Guide](https://flutter.dev/docs/testing)
