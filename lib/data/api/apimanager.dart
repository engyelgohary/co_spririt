import 'dart:convert';
import 'dart:io';
import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';


class ApiConstants {
  static const String baseUrl = '10.10.99.13:3090';
  static const String registerAdminApi = '/api/v1/admin';
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


  Future<GetAdmin> addAdmin(Map<String, dynamic> adminData, XFile? image) async {
    var uri = Uri.http(ApiConstants.baseUrl, ApiConstants.registerAdminApi);
    var request = http.MultipartRequest('POST', uri);

    request.fields['firstName'] = adminData['firstName'];
    request.fields['lastName'] = adminData['lastName'];
    request.fields['phone'] = adminData['phone'];
    request.fields['email'] = adminData['email'];
    request.fields['canPost'] = adminData['canPost'];
    request.fields['password']=adminData['password'];

    if (image != null) {
      var mimeTypeData = lookupMimeType(image.path)!.split('/');
      request.files.add(
        http.MultipartFile(
          'picture',
          File(image.path).readAsBytes().asStream(),
          File(image.path).lengthSync(),
          filename: basename(image.path),
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      var responseData = await http.Response.fromStream(response);
      return GetAdmin.fromJson(jsonDecode(responseData.body));
    } else {
      var responseData = await http.Response.fromStream(response);
      throw Exception('Failed to add admin: ${responseData.body}');
    }
  }
  }
