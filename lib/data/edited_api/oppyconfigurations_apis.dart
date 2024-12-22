import 'package:co_spirit/core/constants.dart';
import 'package:dio/dio.dart';
import '../api_response.dart';

class OppyConfigurationApis {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    baseUrl: oppyConfigurationsApisUrl,
    contentType: "application/json",
  ));

  // Helper method to create headers
  Map<String, String> _createHeaders(String token) {
    return {
      "Authorization": "Bearer $token",
      "accept": "*/*",
    };
  }

  // Generic request method to handle POST, PUT, DELETE, and GET requests
  Future<ApiResponse?> _request({
    required String method,
    required String endpoint,
    String? id,
    Map<String, dynamic>? data,
    required String token,
  }) async {
    try {
      Response res;

      if (method == 'POST') {
        res = await dio.post(
          endpoint,
          data: data,
          options: Options(headers: _createHeaders(token)),
        );
      } else if (method == 'GET') {
        res = await dio.get(
          endpoint,
          options: Options(headers: _createHeaders(token)),
        );
      } else if (method == 'PUT') {
        res = await dio.put(
          endpoint,
          data: data,
          options: Options(headers: _createHeaders(token)),
        );
      } else if (method == 'DELETE' && id != null) {
        res = await dio.delete(
          "$endpoint/$id",
          options: Options(headers: _createHeaders(token)),
        );
      } else {
        throw Exception("Invalid HTTP method");
      }

      return ApiResponse.fromJson(res.data, res.data["data"]);
    } on DioException catch (e) {
      _handleDioError(e, "Request failed for $endpoint");
    }
  }

  // Customer APIs
  Future<ApiResponse?> addCustomer({
    required String token,
    required Map<String, dynamic> customerData,
  }) => _request(
    method: 'POST',
    endpoint: "AddCustomer",
    token: token,
    data: customerData,
  );

  Future<ApiResponse?> getCustomers({required String token}) => _request(
    method: 'GET',
    endpoint: "GetCustomer",
    token: token,
  );

  Future<void> deleteCustomer({required String token, required String id}) =>
      _request(
        method: 'DELETE',
        endpoint: "DeleteCustomer",
        token: token,
        id: id,
      );

  // Feasibility APIs
  Future<ApiResponse?> addFeasibility({
    required String token,
    required Map<String, dynamic> feasibilityData,
  }) => _request(
    method: 'POST',
    endpoint: "AddFeasibility",
    token: token,
    data: feasibilityData,
  );

  Future<ApiResponse?> getFeasibilities({required String token}) => _request(
    method: 'GET',
    endpoint: "GetFeasibility",
    token: token,
  );

  Future<void> deleteFeasibility({required String token, required String id}) =>
      _request(
        method: 'DELETE',
        endpoint: "DeleteFeasibility",
        token: token,
        id: id,
      );

  // Point Prize APIs
  Future<ApiResponse?> addPointPrize({
    required String token,
    required Map<String, dynamic> pointPrizeData,
  }) => _request(
    method: 'POST',
    endpoint: "AddPointPrize",
    token: token,
    data: pointPrizeData,
  );

  Future<ApiResponse?> getPointPrizes({required String token}) => _request(
    method: 'GET',
    endpoint: "GetPointPrize",
    token: token,
  );

  Future<void> updatePointPrize({
    required String token,
    required Map<String, dynamic> pointPrizeData,
  }) => _request(
    method: 'PUT',
    endpoint: "UpdatePointPrize",
    token: token,
    data: pointPrizeData,
  );

  Future<void> deletePointPrize({required String token, required String id}) =>
      _request(
        method: 'DELETE',
        endpoint: "DeletePointPrize",
        token: token,
        id: id,
      );

  // Risk APIs
  Future<ApiResponse?> addRisk({
    required String token,
    required Map<String, dynamic> riskData,
  }) => _request(
    method: 'POST',
    endpoint: "AddRisk",
    token: token,
    data: riskData,
  );

  Future<ApiResponse?> getRisks({required String token}) => _request(
    method: 'GET',
    endpoint: "GetRisk",
    token: token,
  );

  Future<void> deleteRisk({required String token, required String id}) =>
      _request(
        method: 'DELETE',
        endpoint: "DeleteRisk",
        token: token,
        id: id,
      );

  // Handle Dio Errors
  void _handleDioError(DioException e, String defaultMessage) {
    final message = e.response?.data['Message'] ?? e.message ?? defaultMessage;
    throw Exception(message);
  }
}
