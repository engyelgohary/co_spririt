part of 'opportunites_admin_cubit.dart';

@immutable
sealed class OpportunitesAdminState {}

final class OpportunitesAdminInitial extends OpportunitesAdminState {}
final class OpportunityLoading extends OpportunitesAdminState {}
final class OpportunitySuccess extends OpportunitesAdminState {}
final class OpportunityLoaded extends OpportunitesAdminState {
  final List<Opportunities> getOpportunites;
  OpportunityLoaded(this.getOpportunites);
  @override
  List<Object> get props => [getOpportunites];
}
final class OpportunityFailure extends OpportunitesAdminState {
  final String error;

  OpportunityFailure(this.error);

  @override
  List<Object> get props => [error];
}
