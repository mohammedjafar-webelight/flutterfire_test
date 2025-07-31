// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:flutterfire_test/task_app.dart';

void main() {
  testWidgets('Task app smoke test', (WidgetTester tester) async {
    // Create fake Firestore for testing
    final firestore = FakeFirebaseFirestore();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: TaskHomePage(firestore: firestore)));

    // Wait for the stream to initialize
    await tester.idle();
    await tester.pump();

    // Verify that our app shows the empty state initially.
    expect(find.text('No tasks yet. Tap + to add one!'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.idle();
    await tester.pump();

    // Verify that a new task was added.
    expect(find.text('New Task'), findsOneWidget);
  });
}
