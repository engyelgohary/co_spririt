part of 'new_task_cubit.dart';

@immutable
sealed class NewTaskState {}

final class NewTaskInitialState extends NewTaskState {}

final class NewTaskLoadingState extends NewTaskState {}

final class NewTaskSuccessfulState extends NewTaskState {
  final List response;
  NewTaskSuccessfulState(this.response);
}

final class NewTaskFailureState extends NewTaskState {
  final String error;
  NewTaskFailureState(this.error);
}
