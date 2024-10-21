import 'package:co_spirit/core/constants.dart';
import 'package:dio/dio.dart';

class UserApi {
  static UserApi? _instance;
  factory UserApi() => _instance ??= UserApi();

  Dio dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 5),
    baseUrl: userApiUrl,
    contentType: "application/json",
  ));

  Future<ApiResponse?> getUsers({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    
    try {
      final res = await dio.get("getUsers",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return ApiResponse.fromJson(res.data, LoginApiResponse.fromJson(res.data["data"]));
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<ApiResponse<LoginApiResponse>?> login(
      {required String email, required String password}) async {
    try {
      final res = await dio.post("login", data: {"email": email, "password": password});
      return ApiResponse.fromJson(res.data, LoginApiResponse.fromJson(res.data["data"]));
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<ApiResponse<LoginApiResponse>?> refreshToken({required String refreshToken}) async {
    try {
      final res = await dio.post("refreshToken", data: {"refreshToken": refreshToken});
      return ApiResponse.fromJson(res.data, LoginApiResponse.fromJson(res.data["data"]));
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

class ApiResponse<T> {
  late int statusCode;
  late String meta;
  late bool succeeded;
  late String message;
  late String errors;
  late T data;

  ApiResponse.fromJson(Map json, this.data) {
    this.statusCode = json["statusCode"];
    this.meta = json["meta"];
    this.succeeded = json["succeeded"];
    this.message = json["message"];
    this.errors = json["errors"];
  }
}

class LoginApiResponse {
  late String token;
  late String tokenExpiresOn;
  late String refreshToken;
  late String refreshTokenExpiration;
  late String role;

  LoginApiResponse.fromJson(Map json) {
    token = json["token"];
    tokenExpiresOn = json["tokenExpiresOn"];
    refreshToken = json["refreshToken"];
    refreshTokenExpiration = json["refreshTokenExpiration"];
    role = json["role"];
  }
}

void main(List<String> args) {}


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