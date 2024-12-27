import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/edited_api/oppyconfigurations_apis.dart';
import '../../../../data/edited_model/oppy_configurations.dart';
import 'configurations_state.dart';

// Define individual Cubits for Customers, Feasibilities, Risks, Solutions, and Teams

// Customers Cubit
class CustomersCubit extends Cubit<ConfigurationsState> {
  final OppyConfigurationApis oppyApis;

  CustomersCubit({required this.oppyApis}) : super(ConfigurationsLoadingState());

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

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
      fetchCustomers();
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding customer: $e"));
    }
  }
  Future<void> deleteCustomer(String id) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.deleteCustomer(token: token, id: id);
      emit(DeleteCustomerSuccessState());
      fetchCustomers();  // Refresh the list after deleting a customer
    } catch (e) {
      emit(ConfigurationsFailureState("Error deleting customer: $e"));
    }
  }
}

// Feasibilities Cubit
class FeasibilitiesCubit extends Cubit<ConfigurationsState> {
  final OppyConfigurationApis oppyApis;

  FeasibilitiesCubit({required this.oppyApis}) : super(ConfigurationsLoadingState());

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

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
      fetchFeasibilities();
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding feasibility: $e"));
    }
  }

  Future<void> deleteFeasibility(String id) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.deleteFeasibility(token: token, id: id);
      emit(DeleteCustomerSuccessState());
      fetchFeasibilities();  // Refresh the list after deleting a Feasibility
    } catch (e) {
      emit(ConfigurationsFailureState("Error deleting Feasibility: $e"));
    }
  }

}

// Risks Cubit
class RisksCubit extends Cubit<ConfigurationsState> {
  final OppyConfigurationApis oppyApis;

  RisksCubit({required this.oppyApis}) : super(ConfigurationsLoadingState());

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> fetchRisks() async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      // Fetch the risks from the API
      final risksData = await oppyApis.getRisks(token: token);
      print("fetched risks from cubit $risksData");

      if (risksData != null && risksData is Map<String, dynamic> && risksData['data'] != null) {
        final risksList = (risksData['data'] as List)
            .map((e) => Risk.fromJson(e))
            .toList();

        emit(RisksLoadedState(risksList));  // Emitting RisksLoadedState with the list of risks
      } else {
        emit(ConfigurationsFailureState("No risks data found"));
      }
    } catch (e) {
      emit(ConfigurationsFailureState("Error fetching risks: $e"));
    }
  }
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
      fetchRisks();
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding risk: $e"));
    }
  }
  Future<void> deleteRisk(String id) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.deleteRisk(token: token, id: id);
      emit(DeleteRiskSuccessState());
      fetchRisks();  // Refresh the list after deleting a Risk
    } catch (e) {
      emit(ConfigurationsFailureState("Error deleting Risk: $e"));
    }
  }
}

// Solutions Cubit
class SolutionsCubit extends Cubit<ConfigurationsState> {
  final OppyConfigurationApis oppyApis;

  SolutionsCubit({required this.oppyApis}) : super(ConfigurationsLoadingState());

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

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
      fetchSolutions();
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding solution: $e"));
    }
  }
  Future<void> deleteSolution(String id) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.deleteSolution(token: token, id: id);
      emit(DeleteSolutionSuccessState());
      fetchSolutions();  // Refresh the list after deleting a solution
    } catch (e) {
      emit(ConfigurationsFailureState("Error deleting solution: $e"));
    }
  }
}

// Teams Cubit
class TeamsCubit extends Cubit<ConfigurationsState> {
  final OppyConfigurationApis oppyApis;

  TeamsCubit({required this.oppyApis}) : super(ConfigurationsLoadingState());

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

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
      fetchTeams();
    } catch (e) {
      emit(ConfigurationsFailureState("Error adding team: $e"));
    }
  }

  Future<void> deleteTeam(String id) async {
    emit(ConfigurationsLoadingState());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ConfigurationsFailureState("Token not found. Please log in."));
        return;
      }

      await oppyApis.deleteTeam(token: token, id: id);
      emit(DeleteTeamSuccessState());
      fetchTeams();  // Refresh the list after deleting a team
    } catch (e) {
      emit(ConfigurationsFailureState("Error deleting team: $e"));
    }
  }
}