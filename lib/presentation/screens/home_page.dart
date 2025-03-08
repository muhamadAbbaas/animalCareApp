// ignore_for_file: use_key_in_widget_constructors

import 'package:animal_reminder/logic/cubit/task_cubit.dart';
import 'package:animal_reminder/logic/cubit/task_state.dart';
import 'package:animal_reminder/presentation/screens/task_details.dart';
import 'package:animal_reminder/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AnimalCare Reminder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return state.tasks.isEmpty
                ? const Center(child: Text("No tasks available"))
                : ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    return TaskTile(task: task);
                  },
                );
          } else if (state is TaskError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("No tasks available"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.pinkAccent.shade700,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
        },
      ),
    );
  }
}
