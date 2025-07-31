import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestHelper {
  static MockFirebaseAuth createMockAuth() {
    return MockFirebaseAuth();
  }

  static Widget createTestApp({required Widget child}) {
    return MaterialApp(home: child);
  }
}
