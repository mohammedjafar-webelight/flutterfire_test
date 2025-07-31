# FlutterFire Testing Demo

A simple Flutter app demonstrating Firebase Firestore integration with comprehensive testing using fakes.

## Features

- **Task Management**: Add and toggle completion of tasks
- **Real-time Updates**: Tasks update in real-time using Firestore streams
- **Comprehensive Testing**: Unit and widget tests using `fake_cloud_firestore`

## App Structure

```
lib/
├── main.dart          # App entry point with Firebase initialization
├── task_app.dart      # Main app widget and home page
├── task_list.dart     # Widget to display tasks from Firestore
```

## Testing

### Unit Tests with Fakes

The app uses `fake_cloud_firestore` for testing, which simulates Firestore behavior without requiring a real Firebase connection.

**Key Testing Concepts:**

1. **Fake Database**: `FakeFirebaseFirestore()` simulates Firestore
2. **Data Population**: Pre-populate fake database with test data
3. **Stream Testing**: Test real-time updates using `tester.idle()` and `tester.pump()`
4. **Widget Interaction**: Test user interactions like tapping buttons and checkboxes

### Test Coverage

- ✅ Display tasks from Firestore
- ✅ Show empty state when no tasks
- ✅ Add new tasks via floating action button
- ✅ Toggle task completion
- ✅ Loading states
- ✅ Individual widget testing

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
- `fake_cloud_firestore`: Testing fakes (dev dependency)

## Testing Best Practices Demonstrated

1. **Use Fakes for Unit Tests**: Avoid real Firebase calls in tests
2. **Test Stream Behavior**: Handle async streams properly with `tester.idle()`
3. **Isolate Components**: Test individual widgets separately
4. **Mock User Interactions**: Test button taps, form submissions, etc.
5. **Verify UI States**: Check loading, empty, and populated states

## Integration Testing

For integration tests with the Firestore emulator:

1. Start Firestore emulator: `firebase emulators:start --only firestore`
2. Configure app to use emulator (see `test/integration_test.dart` example)
3. Run integration tests

## References

- [FlutterFire Testing Documentation](https://firebase.flutter.dev/docs/testing/testing/)
- [fake_cloud_firestore Package](https://pub.dev/packages/fake_cloud_firestore)
- [Flutter Testing Guide](https://flutter.dev/docs/testing)
