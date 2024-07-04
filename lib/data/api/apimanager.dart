import 'dart:convert';
import 'package:co_spririt/data/model/AdminUser.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class ApiConstants {
  static const String baseUrl = '10.10.99.13:3090';
  static const String registerApi = '/api/v1/admin';
  static const String loginApi = '/api/auth/signin';
  static const String getAllAdmins = '/api/v1/admin';



}

class ApiManager {
  ApiManager._();
  static ApiManager? _instance;
  static ApiManager getInstanace(){
    _instance??= ApiManager._();
    return _instance!;
  }

  Future<String?> login({required String email, required String password}) async {
    try {
      final storage = FlutterSecureStorage();
      Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.loginApi);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'Email': email,
          'Password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.body;
        print(token);
        // Save the token in secure storage
        await storage.write(key: 'token', value: token);

        // Return the token
        return token;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception caught: $e');
      return null;
    }
  }

  Future<List<GetAdmin>> getAllAdmins({int page = 1}) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.getAllAdmins, {
      "page": page.toString(),
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<GetAdmin> admins = jsonList.map((json) => GetAdmin.fromJson(json)).toList();
        return admins;
      } else {
        throw Exception('Failed to load admins. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching admins: $error');
      throw Exception('Error fetching admins: $error');
    }
  }


  Future<AdminUser> registerAdmin({required String firstName,
    required String email, required String password,required  String lastName, required String phone}) async {
    Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.registerApi, {
      "firstName": firstName,
      "lastName":lastName,
      "email":email,
      "phone": phone,
      "password":"Admin2@Admin2_12345",
    });
    try{
      var response = await http.post(url);
      var responsebody = response.body;
      var json = jsonDecode(responsebody);
      return AdminUser.fromJson(json);
    }catch(e){
      print(e);
      throw e;
    }
  }
  }
