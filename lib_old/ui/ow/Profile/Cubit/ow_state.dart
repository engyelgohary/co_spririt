
part of 'ow_cubit.dart';

@immutable
sealed class OpportunityOwnerState {}

final class OpportunityOwnerInitial extends OpportunityOwnerState {}
final class OpportunityOwnerLoading extends OpportunityOwnerState {}
final class OpportunityOwnerError extends OpportunityOwnerState {
  final String? errorMessage;
  OpportunityOwnerError({required this.errorMessage});
}
final class OpportunityOwnerSuccess extends OpportunityOwnerState {
  final OW? opportunityOwnerData;
  final List<OW>? getOWs;
  OpportunityOwnerSuccess({this.getOWs, this.opportunityOwnerData});
}
class OpportunityOwnerImageSelected extends OpportunityOwnerState {
  final XFile image;
  OpportunityOwnerImageSelected(this.image);
}
final class OpportunityOwnerDetailsSuccess extends OpportunityOwnerState {
  final OW opportunityOwnerData;
  OpportunityOwnerDetailsSuccess({required this.opportunityOwnerData});
}
