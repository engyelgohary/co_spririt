part of 'colloborator_to_admin_cubit.dart';

@immutable
sealed class CollaboratorToAdminState {}

final class CollaboratorToAdminInitial extends CollaboratorToAdminState {}
final class CollaboratorLoading extends CollaboratorToAdminState {}
final class CollaboratorLoaded extends CollaboratorToAdminState {
  final List<Collaborator> getCollaborator;
  CollaboratorLoaded(this.getCollaborator);
  @override
  List<Object> get props => [getCollaborator];
}
final class CollaboratorFailure extends CollaboratorToAdminState {
  final String error;

  CollaboratorFailure(this.error);

  @override
  List<Object> get props => [error];
}