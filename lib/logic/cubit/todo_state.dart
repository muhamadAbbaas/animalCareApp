part of 'todo_cubit.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodosLoading extends TodoState {}

final class TodosLoaded extends TodoState {
  final List<Todo> todos;
  TodosLoaded(this.todos);
}

class TodoAdded extends TodoState {}

class TodoDeleted extends TodoState {}

final class TodoError extends TodoState {
  final String error;
  TodoError(this.error);
}
