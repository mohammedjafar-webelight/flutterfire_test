import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('tasks').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final int taskCount = snapshot.data!.docs.length;

        if (taskCount == 0) {
          return const Center(child: Text('No tasks yet. Tap + to add one!'));
        }

        return ListView.builder(
          itemCount: taskCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data!.docs[index];
            final String title = document['title'] ?? 'No title';
            final bool completed = document['completed'] ?? false;

            return ListTile(
              title: Text(title, style: TextStyle(decoration: completed ? TextDecoration.lineThrough : null)),
              subtitle: Text('Task ${index + 1} of $taskCount'),
              trailing: Checkbox(
                value: completed,
                onChanged: (bool? value) {
                  document.reference.update({'completed': value});
                },
              ),
            );
          },
        );
      },
    );
  }
}
