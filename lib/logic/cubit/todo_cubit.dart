// ignore_for_file: depend_on_referenced_packages

import 'package:animal_reminder/core/services/notification_service.dart';
import 'package:animal_reminder/data/data_sources/database_helper.dart';
import 'package:animal_reminder/data/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();

  static TodoCubit get(context) => BlocProvider.of(context);

  Future<void> loadTodos() async {
    emit(TodosLoading());
    try {
      final todos = await _dbHelper.getTodos();
      emit(TodosLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> insertTodo(Todo todo) async {
    emit(TodosLoading());
    try {
      final id = await _dbHelper.insertTodo(todo);
      todo.id = id;
      emit(TodoAdded());
      await _notificationService.scheduleNotification(
        todo.id!,
        todo.title,
        todo.description,
        todo.dateTime,
      );
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> updateTodo(Todo todo) async {
    await _dbHelper.updateTodo(todo);
    await _notificationService.cancelNotification(todo.id!);
    await _notificationService.scheduleNotification(
      todo.id!,
      todo.title,
      todo.description,
      todo.dateTime,
    );
    loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await _dbHelper.deleteTodo(id);
    emit(TodoDeleted());
    await _notificationService.cancelNotification(id);
    loadTodos();
  }
}
