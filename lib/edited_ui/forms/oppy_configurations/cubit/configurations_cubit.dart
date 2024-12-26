import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/Cubit/cubit_state.dart';
import '../../../../data/edited_api/oppyconfigurations_apis.dart';
import '../../../../data/edited_model/oppy_configurations.dart';
import 'configurations_state.dart';

class OppyConfigurationCubit extends Cubit<ConfigurationsState> {
  final OppyConfigurationApis oppyApis;

  OppyConfigurationCubit({required this.oppyApis}) : super(ConfigurationsLoadingState());

  // Helper: Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Fetch all customers
  Future<void> fetchCustomers() async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      final customers = await oppyApis.getCustomers(token: token);
      emit(CustomersLoadedState(customers));
    } catch (e) {
      emit(ConfigurationsFailureState("Error fetching customers: $e"));
    }
  }

  // Add a new customer
  Future<void> addCustomer(String name) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.addCustomer(token: token, name: name);
      emit(AddCustomerSuccessState());
      fetchCustomers(); // Refetch after adding
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding customer: $e"));
    }
  }

  // Fetch feasibility list
  Future<void> fetchFeasibilities() async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      final feasibilities = await oppyApis.getFeasibility(token: token);
      emit(FeasibilitiesLoadedState(feasibilities));
    } catch (e) {
      emit(ConfigurationsFailureState("Error fetching feasibilities: $e"));
    }
  }

  // Add feasibility
  Future<void> addFeasibility(List<String> names) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.addFeasibility(token: token, names: names);
      emit(AddFeasibilitySuccessState());
      fetchFeasibilities(); // Refetch after adding
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding feasibility: $e"));
    }
  }

  // Fetch risks
  Future<void> fetchRisks() async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      final risks = await oppyApis.getRisks(token: token);
      emit(RisksLoadedState(risks));
    } catch (e) {
      emit(ConfigurationsFailureState("Error fetching risks: $e"));
    }
  }

  // Add a risk
  Future<void> addRisk(String name) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.addRisk(token: token, name: name);
      emit(AddRiskSuccessState());
      fetchRisks(); // Refetch after adding
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding risk: $e"));
    }
  }

  // Fetch solutions
  Future<void> fetchSolutions() async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      final solutions = await oppyApis.getSolutions(token: token);
      emit(SolutionsLoadedState(solutions));
    } catch (e) {
      emit(ConfigurationsFailureState("Error fetching solutions: $e"));
    }
  }

  // Add a solution
  Future<void> addSolution(String name) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.addSolution(token: token, name: name);
      emit(AddSolutionSuccessState());
      fetchSolutions(); // Refetch after adding
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding solution: $e"));
    }
  }

  // Fetch teams
  Future<void> fetchTeams() async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      final teams = await oppyApis.getTeams(token: token);
      emit(TeamsLoadedState(teams));
    } catch (e) {
      emit(ConfigurationsFailureState("Error fetching teams: $e"));
    }
  }

  // Add a team
  Future<void> addTeam(String name) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.addTeam(token: token, name: name);
      emit(AddTeamSuccessState());
      fetchTeams(); // Refetch after adding
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding team: $e"));
    }
  }
}
