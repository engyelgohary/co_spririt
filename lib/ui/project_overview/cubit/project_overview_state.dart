part of 'project_overview_cubit.dart';

@immutable
sealed class ProjectsOverviewState {}

final class ProjectsOverviewInitialState extends ProjectsOverviewState {}

final class ProjectsOverviewLoadingState extends ProjectsOverviewState {}

final class ProjectsOverviewSuccessfulState extends ProjectsOverviewState {
  final Map tasksMap;
  ProjectsOverviewSuccessfulState(this.tasksMap);
  Map get props => tasksMap;
}

final class ProjectsOverviewFailureState extends ProjectsOverviewState {
  final String error;
  ProjectsOverviewFailureState(this.error);
  get props => error;
}
