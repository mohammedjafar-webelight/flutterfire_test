import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_test/task_list.dart';

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: TaskHomePage(firestore: FirebaseFirestore.instance),
    );
  }
}

class TaskHomePage extends StatelessWidget {
  const TaskHomePage({super.key, required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference get tasks => firestore.collection('tasks');

  Future<void> _addTask() async {
    await tasks.add({'title': 'New Task', 'completed': false, 'created_at': FieldValue.serverTimestamp()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text('Task Manager')),
      body: TaskList(firestore: firestore),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
