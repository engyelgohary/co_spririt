import 'package:dio/dio.dart';

import '../edited_model/oppy_configurations.dart';

class OppyConfigurationApis {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    baseUrl: "http://10.100.102.6:5204/api/v1/Oppy_Configuration/",
    contentType: "application/json",
  ));

  // Customer Endpoints
  Future<void> addCustomer({required String token, required String name}) async {
    try {
      await dio.post(
        "AddCustomer",
        data: {
          "names": [name], // Wrap the name in a list
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("Customer added.");
    } catch (e) {
      throw Exception("Error adding customer: $e");
    }
  }

  Future<List<Customer>> getCustomers({required String token}) async {
    try {
      final response = await dio.get(
        "GetCustomer",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      return (response.data['data'] as List)
          .map((e) => Customer.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Error fetching customers: $e");
    }
  }

  Future<void> deleteCustomer({required String token, required String id}) async {
    try {
      await dio.delete(
        "DeleteCustomer/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("Customer deleted.");
    } catch (e) {
      throw Exception("Error deleting customer: $e");
    }
  }

  // Feasibility Endpoints
  Future<List<Feasibility>> getFeasibility({required String token}) async {
    try {
      final response = await dio.get(
        "GetFeasibility",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      return (response.data['data'] as List)
          .map((e) => Feasibility.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Error fetching feasibility: $e");
    }
  }

  Future<void> addFeasibility({required String token, required List<String> names}) async {
    try {
      await dio.post(
        "AddFeasibility",
        data: {"names": names},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("Feasibility added.");
    } catch (e) {
      throw Exception("Error adding feasibility: $e");
    }
  }

  // Risk Endpoints
  Future<List<Risk>> getRisks({required String token}) async {
    final response = await dio.get(
      "GetRisks",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Risk.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch risks: ${response.statusCode}");
    }
  }


  Future<void> addRisk({
    required String token,
    required String name,
  }) async {
    try {
      final response = await dio.post(
        "AddRisk",
        data: {
          "names": [name], // Wrap the name in a list
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "*/*",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Risk added successfully.");
      } else {
        print("Unexpected response: ${response.data}");
        throw Exception("Failed to add risk.");
      }
    } on DioException catch (e) {
      print("Error adding risk: ${e.response?.data ?? e.message}");
      throw Exception("Error adding risk: ${e.message}");
    }
  }



  // Solution Endpoints
  Future<List<Solution>> getSolutions({required String token}) async {
    try {
      final response = await dio.get(
        "GetSolution",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      return (response.data['data'] as List)
          .map((e) => Solution.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Error fetching solutions: $e");
    }
  }

  Future<void> addSolution({required String token, required String name}) async {
    try {
      await dio.post(
        "AddSolution",
        data: {
          "names": [name], // Wrap the name in a list
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("Solution added.");
    } catch (e) {
      throw Exception("Error adding solution: $e");
    }
  }

  // Status Endpoints
  Future<void> addStatus({required String token, required String name}) async {
    try {
      await dio.post(
        "AddStatus",
        data: {"name": name},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("Status added.");
    } catch (e) {
      throw Exception("Error adding status: $e");
    }
  }

  // Team Endpoints
  Future<List<Team>> getTeams({required String token}) async {
    try {
      final response = await dio.get(
        "GetTeam",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      return (response.data['data'] as List)
          .map((e) => Team.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Error fetching teams: $e");
    }
  }

  Future<void> addTeam({required String token, required String name}) async {
    try {
      await dio.post(
        "AddTeam",
        data: {
          "names": [name], // Wrap the name in a list
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("Team added.");
    } catch (e) {
      throw Exception("Error adding team: $e");
    }
  }
}
