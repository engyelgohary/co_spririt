import 'package:equatable/equatable.dart';

import '../../../../data/edited_model/oppy_configurations.dart';

abstract class ConfigurationsState extends Equatable {
  @override
  List<Object> get props => [];
}

// Loading state for each configuration type
class ConfigurationsLoadingState extends ConfigurationsState {}

class ConfigurationsFailureState extends ConfigurationsState {
  final String error;

  ConfigurationsFailureState(this.error);

  @override
  List<Object> get props => [error];
}

// Success states for each configuration type
class CustomersLoadedState extends ConfigurationsState {
  final List<Customer> customers;
  CustomersLoadedState(this.customers);

  @override
  List<Object> get props => [customers];
}

class FeasibilitiesLoadedState extends ConfigurationsState {
  final List<Feasibility> feasibilities;
  FeasibilitiesLoadedState(this.feasibilities);

  @override
  List<Object> get props => [feasibilities];
}

class RisksLoadedState extends ConfigurationsState {
  final List<Risk> risks;
  RisksLoadedState(this.risks);

  @override
  List<Object> get props => [risks];
}

class SolutionsLoadedState extends ConfigurationsState {
  final List<Solution> solutions;
  SolutionsLoadedState(this.solutions);

  @override
  List<Object> get props => [solutions];
}

class TeamsLoadedState extends ConfigurationsState {
  final List<Team> teams;
  TeamsLoadedState(this.teams);

  @override
  List<Object> get props => [teams];
}

// Success state for adding each configuration type
class AddCustomerSuccessState extends ConfigurationsState {}

class AddFeasibilitySuccessState extends ConfigurationsState {}

class AddRiskSuccessState extends ConfigurationsState {}

class AddSolutionSuccessState extends ConfigurationsState {}

class AddTeamSuccessState extends ConfigurationsState {}
