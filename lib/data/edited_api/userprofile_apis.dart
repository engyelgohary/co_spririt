import 'package:co_spirit/core/constants.dart';
import 'package:dio/dio.dart';
import '../api_response.dart';
import '../edited_model/user_profile.dart';

class UserProfileApis{
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    baseUrl: userProfileApisUrl,
    contentType: "application/json",
  ));


  Future<ApiResponse<UserProfile>?> getCurrentUser({required String token}) async {
    try {
      final res = await dio.get("CurrentUser",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "*/*",
          },
        ),
      );

      return ApiResponse.fromJson(
        res.data,
        UserProfile.fromJson(res.data["data"]),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error Response: ${e.response!.data}");
      } else {
        print("DioException: ${e.message}");
      }
      throw Exception("Failed to fetch current user: ${e.message}");
    } catch (e) {
      print("Error: $e");
      throw Exception("Unexpected error: $e");
    }
  }

  Future<ApiResponse<UserProfile>?> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final res = await dio.put(
        "UpdateProfile",
        data: {
          "firstName": firstName,
          "lastName": lastName,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "*/*",
          },
        ),
      );

      // Log the response to debug its structure
      print("Response data: ${res.data}");

      // Check if the response is a valid Map
      if (res.data is Map<String, dynamic>) {
        return ApiResponse<UserProfile>.fromJson(
          res.data,
          UserProfile.fromJson(res.data["data"]),
        );
      } else {
        throw Exception("Unexpected response format: ${res.data}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error Response: ${e.response!.data}");
      } else {
        print("DioException: ${e.message}");
      }
      throw Exception("Failed to update profile: ${e.message}");
    } catch (e) {
      print("Error: $e");
      throw Exception("Unexpected error: $e");
    }
  }


}