import 'package:co_spirit/core/constants.dart';
import 'package:dio/dio.dart';
import '../edited_model/role.dart';
import '../edited_model/user.dart';

class UserManagementApis {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      baseUrl: usersManagementApisUrl,
      contentType: "application/json",
    ),
  );

  Future<List<User>> getUsers(String token) async {
    try {
      final response = await dio.get(
        "GetUsers",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "*/*",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data["data"] as List<dynamic>;
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception(
            "Failed to load users. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error fetching users: $error");
    }
  }

  Future<List<Role>> getRoles(String token) async {
    try {
      final response = await dio.get(
        "GetRoles",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "*/*",
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        return data.map((role) => Role.fromJson(role)).toList();
      } else {
        throw Exception('Failed to fetch roles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching roles: $e');
    }
  }

  Future<void> assignRoleToUser(String userId, String roleId,String token) async {
    try {
      final response = await dio.post(
       "AssignRoleToUser",
        data: {
          'userId': userId,
          'roleId': roleId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "*/*",
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to assign role: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error assigning role: $e');
    }
  }

  Future<void> addUser(String firstName, String lastName,String email,String password,String roleId,String token) async {
    try {
      final response = await dio.post(
        "AddUser",
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'roleId': roleId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "*/*",
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add user: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }
}