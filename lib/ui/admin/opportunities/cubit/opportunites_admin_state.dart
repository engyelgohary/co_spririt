part of 'opportunities_admin_cubit.dart';

@immutable
sealed class OpportunitiesAdminState {}

final class OpportunitiesAdminInitial extends OpportunitiesAdminState {}
final class OpportunityLoading extends OpportunitiesAdminState {}
final class OpportunitySuccess extends OpportunitiesAdminState {}
final class OpportunityLoaded extends OpportunitiesAdminState {
  final List<Opportunities> getOpportunities;
  OpportunityLoaded(this.getOpportunities);
  @override
  List<Object> get props => [getOpportunities];
}
final class OpportunityFailure extends OpportunitiesAdminState {
  final String error;

  OpportunityFailure(this.error);

  @override
  List<Object> get props => [error];
}
