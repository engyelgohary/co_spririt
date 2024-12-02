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

      // Log response for debugging
      print("Response data: ${res.data}");

      // Ensure response is a valid JSON map
      if (res.data is Map<String, String>) {
        final data = res.data;

        // Create UserProfile from the "data" field
        final userProfile = UserProfile.fromJson(data["data"]);

        // Return ApiResponse<UserProfile>
        return ApiResponse<UserProfile>.fromJson(data, userProfile);
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

  Future<void> updatePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await dio.put(
        "UpdatePassword",
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Authentication token
            "accept": "application/json", // Content type
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Password updated successfully.");
      } 
      else {
        final message = response.data['Message'] ??
            "Unexpected error occurred.";
        throw Exception(message); 
      }
    }
    on DioException catch (e)
    {
      final message = e.response?.data['Message'] ??
          "Failed to update password.";
      throw Exception(message); 
    }
  }

  Future<void> logOut({
    required String token,
    required String refreshToken,
}) async{
    try{
      final response  = await dio.post("logout", data: {
        "refreshToken": refreshToken,
      },
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Authentication token
            "accept": "application/json", // Content type
          },
        ),
      );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("logout done");
    }
    else {
      final message = response.data['Message'] ??
          "Unexpected error occurred.";
      throw Exception(message);
    }
  }
  on DioException catch (e)
  {
  final message = e.response?.data['Message'] ??
  "Failed to logout.";
  throw Exception(message);
  }
}
  }
