// ignore_for_file: library_private_types_in_public_api, use_super_parameters, sort_child_properties_last

import 'package:animal_reminder/data/model/model.dart';
import 'package:animal_reminder/logic/cubit/task_cubit.dart';
import 'package:animal_reminder/core/services/notification_service.dart';
import 'package:animal_reminder/logic/cubit/task_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  //Color _selectedColor = Colors.blue;
  String? _selectedTaskType;

  final List<String> taskTypes = [
    'Feed',
    'Grooming',
    'Potty Clean',
    'Vet Appointment',
    'Medication',
    'Buy Food',
    'Bath',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Add Task',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedTaskType,
                  items:
                      taskTypes.map((task) {
                        return DropdownMenuItem(value: task, child: Text(task));
                      }).toList(),
                  onChanged:
                      (value) => setState(() => _selectedTaskType = value!),
                  decoration: const InputDecoration(
                    labelText: 'Task Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Select Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  controller: TextEditingController(
                    text:
                        _selectedDate == null
                            ? ""
                            : DateFormat.yMMMd().format(_selectedDate!),
                  ),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Select Time",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  controller: TextEditingController(
                    text:
                        _selectedTime == null
                            ? ""
                            : _selectedTime!.format(context),
                  ),
                  onTap: () => _selectTime(context),
                ),
                const SizedBox(height: 14),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text("Select Task Color: "),
                //     Wrap(
                //       children:
                //           [Colors.red, Colors.blueGrey, Colors.yellow].map((color) {
                //             return GestureDetector(
                //               onTap: () {
                //                 setState(() => _selectedColor = color);
                //               },
                //               child: Container(
                //                 margin: const EdgeInsets.symmetric(
                //                   horizontal: 5,
                //                 ),
                //                 width: 30,
                //                 height: 30,
                //                 decoration: BoxDecoration(
                //                   color: color,
                //                   shape: BoxShape.circle,
                //                   border:
                //                       _selectedColor == color
                //                           ? Border.all(
                //                             width: 3,
                //                             color: Colors.white30,
                //                           )
                //                           : null,
                //                 ),
                //               ),
                //             );
                //           }).toList(),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                       _saveTask();
                    },
                    child: Text(
                      'Add Task',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      fixedSize: Size(366, 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveTask() {
    if (_selectedTaskType == null) {
      _showError("Please select a task type");
      return;
    }
    if (_selectedDate == null) {
      _showError("Please select a date");
      return;
    }
    if (_selectedTime == null) {
      _showError("Please select a time");
      return;
    }

    final DateTime scheduledDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _selectedTaskType!,
      dateTime: scheduledDate,
    );

    BlocProvider.of<TaskCubit>(context).addTask(newTask);

    NotificationService().scheduleNotification(
      id: newTask.id!,
      title: "Task Reminder",
      body: "It's time for ${newTask.title}!",
      scheduledDate: scheduledDate,
    );

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
