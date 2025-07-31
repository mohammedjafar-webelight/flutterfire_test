import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfire_test/task_app.dart';
import 'package:flutterfire_test/task_list.dart';

const String tasksCollection = 'tasks';

void main() {
  group('Task App Tests', () {
    testWidgets('shows tasks from Firestore', (WidgetTester tester) async {
      // Populate the fake database with test data
      final firestore = FakeFirebaseFirestore();
      await firestore.collection(tasksCollection).add({
        'title': 'Test Task 1',
        'completed': false,
        'created_at': FieldValue.serverTimestamp(),
      });
      await firestore.collection(tasksCollection).add({
        'title': 'Test Task 2',
        'completed': true,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Render the widget
      await tester.pumpWidget(MaterialApp(home: TaskHomePage(firestore: firestore)));

      // Let the snapshots stream fire a snapshot
      await tester.idle();
      await tester.pump();

      // Verify the output
      expect(find.text('Test Task 1'), findsOneWidget);
      expect(find.text('Test Task 2'), findsOneWidget);
      expect(find.text('Task 1 of 2'), findsOneWidget);
      expect(find.text('Task 2 of 2'), findsOneWidget);
    });

    testWidgets('shows empty state when no tasks', (WidgetTester tester) async {
      // Create empty fake database
      final firestore = FakeFirebaseFirestore();

      // Render the widget
      await tester.pumpWidget(MaterialApp(home: TaskHomePage(firestore: firestore)));

      // Let the snapshots stream fire a snapshot
      await tester.idle();
      await tester.pump();

      // Verify empty state
      expect(find.text('No tasks yet. Tap + to add one!'), findsOneWidget);
    });

    testWidgets('adds new task when floating action button is pressed', (WidgetTester tester) async {
      // Create empty fake database
      final firestore = FakeFirebaseFirestore();

      // Render the widget
      await tester.pumpWidget(MaterialApp(home: TaskHomePage(firestore: firestore)));

      // Verify that there is no data initially
      expect(find.text('New Task'), findsNothing);

      // Tap the Add button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Let the snapshots stream fire a snapshot
      await tester.idle();
      await tester.pump();

      // Verify the output
      expect(find.text('New Task'), findsOneWidget);
      expect(find.text('Task 1 of 1'), findsOneWidget);
    });

    testWidgets('toggles task completion when checkbox is tapped', (WidgetTester tester) async {
      // Populate the fake database
      final firestore = FakeFirebaseFirestore();
      final _ = await firestore.collection(tasksCollection).add({
        'title': 'Toggle Test Task',
        'completed': false,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Render the widget
      await tester.pumpWidget(MaterialApp(home: TaskHomePage(firestore: firestore)));

      // Let the snapshots stream fire a snapshot
      await tester.idle();
      await tester.pump();

      // Verify initial state (unchecked)
      expect(find.byType(Checkbox), findsOneWidget);
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);

      // Tap the checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Let the snapshots stream fire a snapshot
      await tester.idle();
      await tester.pump();

      // Verify the checkbox is now checked
      final updatedCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(updatedCheckbox.value, true);

      // Verify the task title has strikethrough decoration
      final textWidget = tester.widget<Text>(find.text('Toggle Test Task'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('shows loading indicator while data is loading', (WidgetTester tester) async {
      // Create fake database with delayed response
      final firestore = FakeFirebaseFirestore();

      // Render the widget
      await tester.pumpWidget(MaterialApp(home: TaskHomePage(firestore: firestore)));

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('TaskList widget displays tasks correctly', (WidgetTester tester) async {
      // Populate the fake database
      final firestore = FakeFirebaseFirestore();
      await firestore.collection(tasksCollection).add({
        'title': 'List Test Task',
        'completed': false,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Render the TaskList widget directly
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TaskList(firestore: firestore)),
        ),
      );

      // Let the snapshots stream fire a snapshot
      await tester.idle();
      await tester.pump();

      // Verify the task is displayed
      expect(find.text('List Test Task'), findsOneWidget);
      expect(find.text('Task 1 of 1'), findsOneWidget);
    });
  });
}
