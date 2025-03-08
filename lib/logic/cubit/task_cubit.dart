// ignore_for_file: avoid_print

import 'package:animal_reminder/core/services/notification_service.dart';
import 'package:animal_reminder/data/data_sources/database_helper.dart';
import 'package:animal_reminder/data/model/model.dart';
import 'package:animal_reminder/logic/cubit/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<TaskState> {
  final DatabaseHelper databaseHelper;
  final NotificationService notificationService = NotificationService();

  TaskCubit(this.databaseHelper) : super(TaskInitial());

  Future<void> getAllTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await databaseHelper.getAllTasks();
      print("Tasks Loaded: ${tasks.length}");
      emit(TaskLoaded(tasks));
    } catch (error) {
      emit(TaskError(error.toString()));
    }
  }

  Future<void> addTask(TaskModel task) async {
    emit(TaskLoading());

    try {
      int id = await databaseHelper.insertTask(task);
      print("Task inserted with ID: $id"); 

      await notificationService.requestExactAlarmPermission();
      await notificationService.scheduleNotification(
        id: id,
        title: "Task Reminder",
        body: "It's time for ${task.title}!",
        scheduledDate: task.dateTime,
      );
      emit(TaskAdded());
      await getAllTasks();
    } catch (error) {
      emit(TaskError(error.toString()));
    }
  }
}
