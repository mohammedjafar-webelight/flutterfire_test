import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_test/task_list.dart';
import 'package:flutterfire_test/auth_service.dart';
import 'package:flutterfire_test/auth_screens.dart';

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          // User is signed in
          return TaskHomePage(firestore: FirebaseFirestore.instance, authService: AuthService());
        }

        // User is not signed in
        return LoginScreen(authService: AuthService());
      },
    );
  }
}

class TaskHomePage extends StatelessWidget {
  const TaskHomePage({super.key, required this.firestore, required this.authService});

  final FirebaseFirestore firestore;
  final AuthService authService;

  CollectionReference get tasks => firestore.collection('tasks');

  Future<void> _addTask() async {
    await tasks.add({'title': 'New Task', 'completed': false, 'created_at': FieldValue.serverTimestamp()});
  }

  Future<void> _signOut() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Task Manager'),
        actions: [
          if (user != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'signout') {
                  _signOut();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'signout',
                  child: Row(
                    children: [
                      const Icon(Icons.logout),
                      const SizedBox(width: 8),
                      Text('Sign Out (${user.email ?? 'Anonymous'})'),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [const Icon(Icons.person), const SizedBox(width: 4), Text(user?.email ?? 'Anonymous')],
                ),
              ),
            ),
        ],
      ),
      body: TaskList(firestore: firestore),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
