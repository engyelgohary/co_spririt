import 'dart:convert';
import 'dart:io';
import 'package:co_spririt/data/model/Client.dart';
import 'package:co_spririt/data/model/ClientReq.dart';
import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';


class ApiConstants {
  static const String baseUrl = '10.10.99.13:3090';
  static const String loginApi = '/api/auth/signin';
  static const String adminApi = '/api/v1/admin';
  static const String clientApi = '/api/v1/client';
  static const String collaboratorApi = '/api/v1/collaborator';


}

class ApiManager {
  ApiManager._();
  static ApiManager? _instance;
  static ApiManager getInstanace(){
    _instance??= ApiManager._();
    return _instance!;
  }
//Auth
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
//Admin
  Future<List<GetAdmin>> getAllAdmins({int page = 1}) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.adminApi, {
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
    var uri = Uri.http(ApiConstants.baseUrl, ApiConstants.adminApi);
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
  Future<GetAdmin> fetchAdminDetails(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.adminApi}/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return GetAdmin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load admin details');
    }
  }
  Future<GetAdmin> updateAdmin(Map<String, dynamic> adminData, XFile? image) async {
    try {
      var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.adminApi}/${adminData['id']}');
      var request = http.MultipartRequest('PUT', uri);

      // Adding fields to the request
      request.fields['FirstName'] = adminData['firstName'];
      request.fields['LastName'] = adminData['lastName'];
      request.fields['Phone'] = adminData['phone'];
      request.fields['Email'] = adminData['email'];
      request.fields['CanPost'] = adminData['canPost'];
      request.fields['Password'] = adminData['password'];

      // Adding image if present
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

      var response = await request.send().timeout(const Duration(seconds: 30));

      if (response.statusCode == 204) { // No Content
        return GetAdmin(); // Assuming an empty GetAdmin object
      } else if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        return GetAdmin.fromJson(jsonDecode(responseData.body));
      } else {
        var responseData = await http.Response.fromStream(response);
        throw Exception('Failed to update admin: ${responseData.body}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }
  Future<GetAdmin> deleteAdmin(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.adminApi}/$id');
    final response = await http.delete(uri);
    if (response.statusCode == 204) {
      return GetAdmin();
    } else if (response.statusCode == 200) {
      return GetAdmin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete admin ');
    }
  }
//Client
  Future<List<Client>> fetchAllClients({int page = 1}) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.clientApi, {
      "page": page.toString(),
    });
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Client> clients = jsonList.map((json) => Client.fromJson(json)).toList();
        return clients;
      } else {
        throw Exception('Failed to load clients. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching clients: $error');
      throw Exception('Error fetching clients: $error');
    }
  }
  Future<Client> addClient(String first, String email, String last, String phone) async {
    var uri = Uri.http(ApiConstants.baseUrl, ApiConstants.clientApi);
    var registerReq = ClientReq(
      email: email,
      contactNumber: phone,
      firstName: first,
      lastName: last,
    );

    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(registerReq.toJson()), // Encode to JSON string
    );

    if (response.statusCode == 201) {
      var registerResponse = Client.fromJson(jsonDecode(response.body));
      return registerResponse;
    } else {
      throw Exception('Failed to add client: ${response.body}');
    }
  }
  Future<Client> deleteClient(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.clientApi}/$id');
    final response = await http.delete(uri);
    if (response.statusCode == 204) {
      return Client();
    } else if (response.statusCode == 200) {
      return Client.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete client. Status code: ${response.statusCode}');
    }
  }
  Future<Client> fetchClientDetails(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.clientApi}/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Client.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load client details');
    }
  }
  Future<void> updateClient(int id, String firstName, String lastName, String email, String contactNumber) async {
    try {
      var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.clientApi}/$id');
      var clientData = ClientReq(
        firstName: firstName,
        contactNumber: contactNumber,
        email: email,
        lastName: lastName,
      );
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(clientData),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to update client. Status code: ${response.statusCode}');
      }
  }catch(e){
     throw Exception(e);
    }
    }
//Collaborator
  Future<List<Collaborator>> fetchAllCollaborators({int page = 1}) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.collaboratorApi, {
      "page": page.toString(),
    });
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Collaborator> collaborator = jsonList.map((json) => Collaborator.fromJson(json)).toList();
        return collaborator;
      } else {
        throw Exception('Failed to load collaborator. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching collaborator: $error');
      throw Exception('Error fetching collaborator: $error');
    }
  }
  Future<Collaborator> deleteCollaborator(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.collaboratorApi}/$id');
    final response = await http.delete(uri);
    if (response.statusCode == 204) {
      return Collaborator();
    } else if (response.statusCode == 200) {
      return Collaborator.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete collaborator ');
    }
  }
}


