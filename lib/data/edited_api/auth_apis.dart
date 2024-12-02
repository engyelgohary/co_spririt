import 'package:co_spirit/core/constants.dart';
import 'package:dio/dio.dart';

import '../api_response.dart';

class AuthApi {
  Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    baseUrl: authApiUrl,
    contentType: "application/json",
  ));

  Future<ApiResponse?> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post("signup", data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
      });
      return ApiResponse.fromJson(res.data, AuthApiResponse.fromJson(res.data["data"]));
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<ApiResponse<AuthApiResponse>?> login(
      {required String email, required String password}) async {
    try {
      final res = await dio.post("login", data: {"email": email, "password": password});
      return ApiResponse.fromJson(res.data, AuthApiResponse.fromJson(res.data["data"]));
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<ApiResponse<AuthApiResponse>?> refreshToken({required String refreshToken}) async {
    try {
      final res = await dio.post("refreshToken", data: {"refreshToken": refreshToken});
      return ApiResponse.fromJson(res.data, AuthApiResponse.fromJson(res.data["data"]));
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class AuthApiResponse {
  late String token;
  late String tokenExpiresOn;
  late String refreshToken;
  late String refreshTokenExpiration;
  late String role;

  AuthApiResponse.fromJson(Map json) {
    token = json["token"];
    tokenExpiresOn = json["tokenExpiresOn"];
    refreshToken = json["refreshToken"];
    refreshTokenExpiration = json["refreshTokenExpiration"];
    role = json["role"];
  }
}

class Role {
  late String name;
  late String id;

  Role.fromJson(Map json) {
    name = json["name"];
    id = json["id"];
  }
}
  // {
  //   "id": "0e8169fa-6b8f-43db-a2fe-d21aef1653a6",
  //   "name": "Opportunity Analyzer"
  // },
  // {
  //   "id": "7c37105b-1e3e-4b69-a244-f337c857e44e",
  //   "name": "Super Admin"
  // },
  // {
  //   "id": "8ecfcf86-bba7-4cdb-9eb5-398d8b3a27c6",
  //   "name": "Solution Contributor"
  // },
  // {
  //   "id": "9e0d645b-df2e-4c52-8965-7a3b12583fb5",
  //   "name": "Opportunity Manager"
  // },
  // {
  //   "id": "e95fd726-5668-42ad-a2ec-7ee45844d59a",
  //   "name": "Solution Manager"
  // },
  // {
  //   "id": "82321084-b653-476c-b2c1-18a20a27e28e",
  //   "name": "Opportunity Detector"
  // }