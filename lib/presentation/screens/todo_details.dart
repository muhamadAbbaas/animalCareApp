// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animal_reminder/data/model/model.dart'; 
import 'package:animal_reminder/logic/cubit/todo_cubit.dart';
import 'package:intl/intl.dart'; 

class TodoDetailsScreen extends StatelessWidget {
  final Todo todo;

  TodoDetailsScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditTaskDialog(context, todo),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              context.read<TodoCubit>().deleteTodo(todo.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task: ${todo.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Description: ${todo.description}'),
            SizedBox(height: 10),
            Text('Date: ${DateFormat('yyyy-MM-dd – hh:mm a').format(todo.dateTime)}'),
            SizedBox(height: 10),
            Text('Status: ${todo.isCompleted ? 'Completed' : 'Pending'}'),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);
    DateTime selectedDate = todo.dateTime;
    bool isCompleted = todo.isCompleted;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                  }
                },
                child: Text('Select Date'),
              ),
              CheckboxListTile(
                title: Text('Completed'),
                value: isCompleted,
                onChanged: (value) {
                  isCompleted = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  final updatedTask = todo.copyWith(
                    title: titleController.text,
                    description: descriptionController.text,
                    dateTime: selectedDate,
                    isCompleted: isCompleted,
                  );

                  context.read<TodoCubit>().updateTodo(updatedTask);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}