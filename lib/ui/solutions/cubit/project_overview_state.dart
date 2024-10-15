part of 'project_overview_cubit.dart';

@immutable
sealed class SolutionsState {}

final class SolutionsInitialState extends SolutionsState {}

final class SolutionsLoadingState extends SolutionsState {}

final class SolutionsSuccessfulState extends SolutionsState {
  final Map solutions;
  SolutionsSuccessfulState(this.solutions);
}

final class SolutionsFailureState extends SolutionsState {
  final String error;
  SolutionsFailureState(this.error);
}
