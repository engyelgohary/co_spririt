part of 'new_solution_cubit.dart';

@immutable
sealed class NewSolutionState {}

final class NewSolutionInitialState extends NewSolutionState {}

final class NewSolutionLoadingState extends NewSolutionState {}

final class NewSolutionSuccessfulState extends NewSolutionState {
  final Map response;
  NewSolutionSuccessfulState(this.response);
}

final class NewSolutionFailureState extends NewSolutionState {
  final String error;
  NewSolutionFailureState(this.error);
}
