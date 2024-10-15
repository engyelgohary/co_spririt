part of 'opportunities_cubit.dart';

@immutable
sealed class OpportunitiesState {}

final class OpportunitiesInitial extends OpportunitiesState {}
final class OpportunityLoading extends OpportunitiesState {}
final class OpportunitySuccess extends OpportunitiesState {}
final class OpportunityLoaded extends OpportunitiesState {
  final List<Opportunities> getOpportunities;
  OpportunityLoaded(this.getOpportunities);
  @override
  List<Object> get props => [getOpportunities];
}
final class OpportunityFailure extends OpportunitiesState {
  final String error;

  OpportunityFailure(this.error);

  @override
  List<Object> get props => [error];
}
class OpportunitiesClientsFetched extends OpportunitiesState {
  final List<Client> clients;
  OpportunitiesClientsFetched(this.clients);

}

