// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:animal_reminder/data/model/model.dart'; 
import 'package:animal_reminder/logic/cubit/todo_cubit.dart'; 
import 'package:animal_reminder/presentation/screens/todo_details.dart'; 

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AnimalCare Reminder')),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is TodosLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return _buildTaskCard(
                  title: todo.title,
                  date: todo.dateTime,
                  color: Colors.blue,
                  icon: Icons.abc,
                  status: todo.isCompleted ? 'Done' : 'Pending',
                  time: DateFormat('hh:mm a').format(todo.dateTime),
                  todo: todo,
                );
              },
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.error));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final timeController = TextEditingController();
    String? selectedTask;
    bool isDaily = false;

    final List<String> taskOptions = [
      'Feed',
      'Grooming',
      'Potty Clean',
      'Vet Appointment',
      'Medication',
      'Buy Food',
      'Bath',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Task'),
                value: selectedTask,
                onChanged: (newValue) {
                  setState(() {
                    selectedTask = newValue;
                  });
                },
                items:
                    taskOptions.map((todo) {
                      return DropdownMenuItem(value: todo, child: Text(todo));
                    }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a todo';
                  }
                  return null;
                },
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    timeController.text = time.format(context);
                  }
                },
              ),
              CheckboxListTile(
                title: Text('Daily Task'),
                value: isDaily,
                onChanged: (value) {
                  setState(() {
                    isDaily = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedTask != null && timeController.text.isNotEmpty) {
                  final todoCubit = context.read<TodoCubit>();

                  // Parse time from timeController
                  final timeOfDay = TimeOfDay.fromDateTime(
                    DateFormat('hh:mm a').parse(timeController.text),
                  );
                  final now = DateTime.now();
                  final dateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    timeOfDay.hour,
                    timeOfDay.minute,
                  );

                  final todo = Todo(
                    title: selectedTask!,
                    dateTime: dateTime,
                    description: 'Task for $selectedTask',
                    isCompleted: false,
                  );

                  todoCubit.insertTodo(todo);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskCard({
    required String title,
    required IconData icon,
    required DateTime date,
    required String status,
    required String time,
    required Color color,
    required Todo todo,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoDetailsScreen(todo: todo),
          ),
        );
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(date)}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text('Status: $status', style: TextStyle(color: Colors.white)),
            SizedBox(height: 4),
            Text('Time: $time', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
