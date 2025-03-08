// ignore_for_file: use_super_parameters

import 'package:animal_reminder/data/model/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          task.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "📅 ${DateFormat.yMMMd().format(task.dateTime)}   ⏰ ${DateFormat.jm().format(task.dateTime)}",
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          _showTaskDetails(context, task);
        },
      ),
    );
  }

  void _showTaskDetails(BuildContext context, TaskModel task) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(task.title),
            content: Text(
              "📅 Date: ${task.dateTime}\n⏰ Time: ${task.dateTime}",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
    );
  }
}
