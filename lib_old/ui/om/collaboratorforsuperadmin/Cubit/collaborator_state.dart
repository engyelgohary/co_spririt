part of 'collaborator_cubit.dart';

@immutable
sealed class CollaboratorState {}

final class CollaboratorInitial extends CollaboratorState {}
final class CollaboratorError extends CollaboratorState {
  String?errorMessage;
  CollaboratorError({required this.errorMessage,});
}
final class CollaboratorSuccess extends CollaboratorState {
  Collaborator? collaboratorData;
  List<Collaborator>? getCollaborator;
  CollaboratorSuccess({this.getCollaborator,this.collaboratorData});
}
class CollaboratorImageSelected extends CollaboratorState {
  final XFile image;
  CollaboratorImageSelected(this.image);
}
final class CollaboratorLoading extends CollaboratorState {}

class CollaboratorCvSelected extends CollaboratorState {
  final File cv;

  CollaboratorCvSelected(this.cv);
}