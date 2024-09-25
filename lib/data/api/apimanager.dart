import 'dart:convert';
import 'dart:io';
import 'package:co_spirit/data/model/Client.dart';
import 'package:co_spirit/data/model/ClientReq.dart';
import 'package:co_spirit/data/model/Collaborator.dart';
import 'package:co_spirit/data/model/GetAdmin.dart';
import 'package:co_spirit/data/model/Notification.dart';
import 'package:co_spirit/data/model/OpportunityAnalyzer.dart';
import 'package:co_spirit/data/model/OpportunityOwner.dart';
import 'package:co_spirit/data/model/Post.dart';
import 'package:co_spirit/data/model/RequestsReq.dart';
import 'package:co_spirit/data/model/RequestsResponse.dart';
import 'package:co_spirit/data/model/message.dart';
import 'package:co_spirit/data/model/typeReq.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/OA.dart';
import '../model/OW.dart';
import '../model/Type.dart';
import '../model/opportunities.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../model/opportunity.dart';

class ApiConstants {
  static const String baseUrl = '10.100.102.6:3090';
  static const String loginApi = '/api/auth/signin';
  static const String adminApi = '/api/v1/admin';
  static const String clientApi = '/api/v1/client';
  static const String collaboratorApi = '/api/v1/collaborator';
  static const String opportunitiesApi = '  /api/v1/opportunities/suggest';
  static const String opportunitiesColApi = '/api/v1/opportunities/collaborator';
  static const String opportunitiesDeleteApi = '/api/v1/opportunities/remove';
  static const String opportunitiesAdminApi = '/api/v1/opportunities';
  static const String opportunityOwnerApi = '/api/OpportunityOwner/';
  static const String opportunityAnalyzerApi = '/api/OpportunityAnalyzer/';
  static const String superAdminTypes = '/api/v1/request-type';
  static const String adminRequests = '/api/v1/requests';
  static const String allPostsApi = '/api/v1/post';
  static const String fetchPostsByAdminApi = '/api/v1/post/GetPostsAdmin';
  static const String messagingApi = '/api/v1/messages';
  static const String superAdminApi = '/api/v1/SuperAdmin';
  static const String notificationApi = '/api/v1/NotificationMessage';
  static const String opportunityStatusApi = '/api/Status';
  static const String solutionApi = '/api/Solution';
  static const String scoreApi = '/api/Score';
  static const String riskApi = '/api/Risk';
}

class ApiManager {
  ApiManager._();
  static ApiManager? _instance;
  static ApiManager getInstance() {
    _instance ??= ApiManager._();
    return _instance!;
  }

  final storage = const FlutterSecureStorage();
//Auth
  Future<String?> login({required String email, required String password}) async {
    try {
      final storage = const FlutterSecureStorage();
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
    request.fields['password'] = adminData['password'];

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

      if (response.statusCode == 204) {
        // No Content
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

  Future<List<Collaborator>> getCollaboratorsToAdmin({int page = 1}) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      final response = await http.get(
        Uri.parse(
            'http://${ApiConstants.baseUrl}${ApiConstants.adminApi}/collaborators?page=$page'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        print('Response data: $responseData'); // Add debug print statement
        List<Collaborator> opportunities =
            responseData.map((data) => Collaborator.fromJson(data)).toList();
        print('Opportunities: $opportunities'); // Add debug print statement
        return opportunities;
      } else {
        throw Exception('Failed to load collaborator data');
      }
    } catch (e) {
      rethrow;
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
      headers: {'Content-Type': 'application/json'},
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

  Future<void> updateClient(
      int id, String firstName, String lastName, String email, String contactNumber) async {
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
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> setStatusToCollaborator(int collaboratorId, int selectStatus) async {
    final url = Uri.parse(
        "http://${ApiConstants.baseUrl}/api/v1/admin/set-status/$collaboratorId?status=$selectStatus"); // Ensure the URL starts with http:// or https://
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 204) {
        print('status assigned successfully to Collaborator');
      } else {
        print('Failed to assign status: ${response.statusCode}');
        throw Exception('Failed to assign status');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to assign status due to an error');
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
        final List<Collaborator> collaborator =
            jsonList.map((json) => Collaborator.fromJson(json)).toList();
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

  Future<Collaborator> addCollaborator(
      Map<String, dynamic> collaboratorData, XFile? image, File? cv) async {
    var uri = Uri.http(ApiConstants.baseUrl, ApiConstants.collaboratorApi);
    var request = http.MultipartRequest('POST', uri);
    request.fields['FirstName'] = collaboratorData['FirstName'];
    request.fields['LastName'] = collaboratorData['LastName'];
    request.fields['Phone'] = collaboratorData['Phone'];
    request.fields['Email'] = collaboratorData['Email'];
    request.fields['ContractStart'] = collaboratorData['ContractStart'];
    request.fields['ContractEnd'] = collaboratorData['ContractEnd'];
    request.fields['Password'] = "AdminAdmin";
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
    if (cv != null) {
      final mimeTypeData = lookupMimeType(cv.path)!.split('/');
      request.files.add(
        http.MultipartFile(
          'Cv',
          File(cv.path).readAsBytes().asStream(),
          File(cv.path).lengthSync(),
          filename: basename(cv.path),
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );
    }
    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        var responseData = await http.Response.fromStream(response);
        return Collaborator.fromJson(jsonDecode(responseData.body));
      } else {
        var responseData = await http.Response.fromStream(response);
        throw Exception('Failed to add Collaborator: ${responseData.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Collaborator> fetchCollaboratorDetails(int? id) async {
    try {
      if (id == null) {
        final token = await storage.read(key: 'token');
        if (token == null) {
          throw Exception('No token found. Please log in.');
        }
        Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
        id = int.parse(decodedToken['nameid'].toString());
      }
      var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.collaboratorApi}/$id');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return Collaborator.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to load collaborator details');
    } catch (e) {
      rethrow;
    }
  }

  Future<Collaborator> updateCollaborator(
      Map<String, dynamic> collaboratorData, XFile? image, File? cv) async {
    try {
      var uri = Uri.http(
          ApiConstants.baseUrl, '${ApiConstants.collaboratorApi}/${collaboratorData['id']}');
      var request = http.MultipartRequest('PUT', uri);

      // Adding fields to the request
      request.fields['FirstName'] = collaboratorData['firstName'];
      request.fields['LastName'] = collaboratorData['lastName'];
      request.fields['Phone'] = collaboratorData['phone'];
      request.fields['Email'] = collaboratorData['email'];
      request.fields['ContractStart'] = collaboratorData['ContractStart'];
      request.fields['ContractEnd'] = collaboratorData['ContractEnd'];
      request.fields['Password'] = "AdminAdmin";

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
      if (cv != null) {
        final mimeTypeData = lookupMimeType(cv.path)!.split('/');
        request.files.add(
          http.MultipartFile(
            'Cv',
            File(cv.path).readAsBytes().asStream(),
            File(cv.path).lengthSync(),
            filename: basename(cv.path),
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }
      var response = await request.send().timeout(const Duration(seconds: 30));

      if (response.statusCode == 204) {
        // No Content
        return Collaborator(); // Assuming an empty GetAdmin object
      } else if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        return Collaborator.fromJson(jsonDecode(responseData.body));
      } else {
        var responseData = await http.Response.fromStream(response);
        throw Exception('Failed to update collaborator: ${responseData.body}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

  Future<Collaborator> assignCollaboratorToAdmin(int collaboratorId, int adminId) async {
    final url = Uri.parse(
        "http://${ApiConstants.baseUrl}${ApiConstants.collaboratorApi}/$collaboratorId/admin/$adminId"); // Ensure the URL starts with http:// or https://

    try {
      final response = await http.put(url);

      if (response.statusCode == 204) {
        print('Collaborator assigned successfully to Admin');
        return Collaborator();
      } else {
        print('Failed to assign collaborator: ${response.statusCode}');
        throw Exception('Failed to assign collaborator');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to assign collaborator due to an error');
    }
  }

  Future<Collaborator> assignCollaboratorToClient(int collaboratorId, int clientId) async {
    final url = Uri.parse(
        "http://${ApiConstants.baseUrl}${ApiConstants.collaboratorApi}/$collaboratorId/client/$clientId"); // Ensure the URL starts with http:// or https://

    try {
      final response = await http.put(url);

      if (response.statusCode == 204) {
        print('Collaborator assigned successfully to client');
        return Collaborator();
      } else {
        print('Failed to assign collaborator: ${response.statusCode}');
        throw Exception('Failed to assign client');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to assign collaborator due to an error');
    }
  }

//Opportunities
  Future<void> submitOpportunity(Opportunities opportunity, File? descriptionFile) async {
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('No token found. Please log in.');
    }
    var uri = Uri.parse("http://${ApiConstants.baseUrl} ${ApiConstants.opportunitiesApi}");
    var request = http.MultipartRequest('POST', uri)
      ..fields['Title'] = opportunity.title ?? ''
      ..fields['Description'] = opportunity.description ?? ''
      ..fields['ClientId'] = opportunity.clientId.toString()
      ..headers['Authorization'] = 'Bearer $token'; // Add the token to the headers

    if (descriptionFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'DescriptionFile',
          descriptionFile.path,
        ),
      );
    }
    var response = await request.send();

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('please choose a client');
    }
  }

  Future<List<Client>> fetchClientsByCollaborator() async {
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('No token found. Please log in.');
    }
    final response = await http.get(
      Uri.parse('http://${ApiConstants.baseUrl}${ApiConstants.collaboratorApi}/clients?page=1'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> clientJson = jsonDecode(response.body);
      return clientJson.map((json) => Client.fromJson(json)).toList();
    } else {
      print(Exception);
      print(response.statusCode);
      throw Exception('Failed to load clients');
    }
  }

  Future<List<Opportunities>> getOpportunityData() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      int collaboratorId = int.parse(decodedToken['nameid'].toString());
      final response = await http.get(
        Uri.parse(
            'http://${ApiConstants.baseUrl}${ApiConstants.opportunitiesColApi}?collaboratorId=$collaboratorId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        print('Response data: $responseData'); // Add debug print statement
        List<Opportunities> opportunities =
            responseData.map((data) => Opportunities.fromJson(data)).toList();
        print('Opportunities: $opportunities'); // Add debug print statement
        return opportunities;
      } else {
        throw Exception('Failed to load collaborator data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Opportunities> deleteOpportunities(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.opportunitiesDeleteApi}/$id');
    final response = await http.delete(uri);
    if (response.statusCode == 204) {
      return Opportunities(); // No content, return an empty Opportunities object
    } else if (response.statusCode == 200) {
      // Handle the response correctly when it is not JSON
      if (response.body.isNotEmpty) {
        int result = int.parse(response.body);
        return Opportunities(result: result);
      } else {
        throw Exception('Failed to delete Opportunities: Response body is empty');
      }
    } else {
      throw Exception('Failed to delete Opportunities: ${response.statusCode}');
    }
  }

  Future<List<Opportunities>> getOpportunityDataAdmin() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      final response = await http.get(
        Uri.parse('http://${ApiConstants.baseUrl}${ApiConstants.opportunitiesAdminApi}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        print('Response data: $responseData'); // Add debug print statement
        List<Opportunities> opportunities =
            responseData.map((data) => Opportunities.fromJson(data)).toList();
        print('Opportunities: $opportunities'); // Add debug print statement
        return opportunities;
      } else {
        throw Exception('Failed to load admin data');
      }
    } catch (e) {
      rethrow;
    }
  }

  //RequestsType SuperAdmin
  Future<Types> addType(String type) async {
    var uri = Uri.http(ApiConstants.baseUrl, ApiConstants.superAdminTypes);
    var registerReq = TypeReq(type: type);

    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registerReq.toJson()), // Encode to JSON string
    );

    if (response.statusCode == 201) {
      var registerResponse = Types.fromJson(jsonDecode(response.body));
      return registerResponse;
    } else {
      throw Exception('Failed to add Type: ${response.body}');
    }
  }

  Future<List<Types>> fetchAllTypes({int page = 1}) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.superAdminTypes, {
      "page": page.toString(),
    });
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Types> types = jsonList.map((json) => Types.fromJson(json)).toList();
        return types;
      } else {
        throw Exception('Failed to load Types. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching Types: $error');
      throw Exception('Error fetching Types: $error');
    }
  }

  Future<Types> deleteTypes(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.superAdminTypes}/$id');
    final response = await http.delete(uri);
    if (response.statusCode == 204) {
      return Types();
    } else if (response.statusCode == 200) {
      return Types.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete Type. Status code: ${response.statusCode}');
    }
  }

  Future<Types> fetchTypeDetails(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.superAdminTypes}/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Types.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load type details');
    }
  }

  Future<void> updateTypes(int id, String type) async {
    try {
      var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.superAdminTypes}/$id');
      var typeData = TypeReq(type: type);
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(typeData),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to update type. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

//Request Collaborator
  Future<RequestsResponse> addRequest(String title, int typeId) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      var uri = Uri.http(ApiConstants.baseUrl, ApiConstants.adminRequests);
      var registerReq = RequestsReq(description: title, requestTypeId: typeId);
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(registerReq.toJson()), // Encode to JSON string
      );

      if (response.statusCode == 201) {
        var registerResponse = RequestsResponse.fromJson(jsonDecode(response.body));
        return registerResponse;
      } else {
        throw Exception('Failed to add Request: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RequestsResponse>> fetchAllRequests({int page = 1}) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.adminRequests, {
      "page": page.toString(),
    });
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<RequestsResponse> requests =
            jsonList.map((json) => RequestsResponse.fromJson(json)).toList();
        return requests;
      } else {
        throw Exception('Failed to load Requests. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching Requests: $error');
      throw Exception('Error fetching Requests: $error');
    }
  }

  Future<RequestsResponse> deleteRequests(int id) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.adminRequests}/$id');
      final response = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 204) {
        return RequestsResponse();
      } else if (response.statusCode == 200) {
        return RequestsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to delete Request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RequestsResponse> fetchRequestDetails(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.adminRequests}/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return RequestsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load type details');
    }
  }

  Future<void> respondToRequest(int requestId, bool response) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      String url =
          'http://${ApiConstants.baseUrl}${ApiConstants.adminRequests}/$requestId/respond?response=$response';
      final http.Response res = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (res.statusCode == 204) {
        print('Request responded successfully');
      } else {
        print('Failed to respond to the request: ${res.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  //Posts

  Future<List<Post>> fetchPosts({int page = 1}) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.allPostsApi, {'page': '$page'});
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('No token found. Please log in.');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        for (var postJson in jsonList) {
          final post = Post.fromJson(postJson);
          print('Post ID: ${post.id}');
          print('User ID: ${post.userId}');
          print('Content: ${post.content}');
          print('Tittle: ${post.title}');
          print('Last Edit: ${post.lastEdit}');
          print('Picture Location: ${post.pictureLocation}');
          print('user picture: ${post.pictureLocationUser}');
          print('---');
        }

        final List<Post> posts = jsonList.map((json) => Post.fromJson(json)).toList();
        return posts;
      } else {
        throw Exception('Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching posts: $error');
      throw Exception('Error fetching posts: $error');
    }
  }

  Future<bool> createPost(String title, String content, {File? image}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Authorization token not found.');
      return false;
    }

    var uri = Uri.parse('http://${ApiConstants.baseUrl}${ApiConstants.allPostsApi}');
    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = title;
    request.fields['content'] = content;

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

    request.headers['Authorization'] = 'Bearer $token';

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        print('Post created successfully: ${responseData.body}');
        return true;
      } else {
        print(
            'Failed to create post for superadmin: ${responseData.statusCode}, ${responseData.body}');
        print('Headers: ${response.headers}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<Post> deletePost(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.allPostsApi}/$id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Authorization token not found.');
    }

    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 204) {
      return Post(id: id);
    } else if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete post ');
    }
  }

  Future<List<Post>> fetchAdminPosts({int page = 1}) async {
    final Uri url =
        Uri.http(ApiConstants.baseUrl, ApiConstants.fetchPostsByAdminApi, {'page': '$page'});
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('No token found. Please log in.');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Post> posts = jsonList.map((json) => Post.fromJson(json)).toList();
        return posts;
      } else {
        throw Exception('Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching posts: $error');
      throw Exception('Error fetching posts: $error');
    }
  }

  Future<bool> updatePost(int id, String title, String content) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, '${ApiConstants.allPostsApi}/$id', {
      'Title': title,
      'Content': content,
    });

    final token = await storage.read(key: 'token');

    if (token == null) {
      print('Authorization token not found.');
      return false;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Title': title,
          'Content': content,
        }),
      );

      if (response.statusCode == 200) {
        print('Post updated successfully');
        return true;
      } else {
        print('Failed to update post: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error updating post: $error');
      return false;
    }
  }

  // Messages
  Future<List> getUserMessages(int id) async {
    final List<Message> output = [];
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      final uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.messagingApi}/$id');
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List messages = jsonDecode(response.body);
        if (messages.isNotEmpty) {
          for (var message in messages) {
            output.add(Message.fromJson(message, id != message["fromId"]));
          }
          return output;
        }
      } else if (response.statusCode == 404) {
        return output;
      }
      throw Exception("Failed to get user messages code: ${response.statusCode}");
    } catch (e) {
      print("Could not get the message error: $e");
      rethrow;
    }
  }

// Messages
  Future<Map> sendMessage(int receiverId, String content, List attachments) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.messagingApi);
      final body = {"toId": receiverId.toString(), "content": content};

      final request = http.MultipartRequest("POST", uri);

      request.fields.addAll(body);

      for (final file in attachments) {
        final mimeTypeData = lookupMimeType(file)!.split('/');
        request.files.add(await http.MultipartFile.fromPath(
          "Attachments",
          file,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      final response = await request.send();
      final responseData = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception('Failed to get Messages: ${response.statusCode}');
      }
    } catch (e) {
      print("Could not send the message error $e");
      rethrow;
    }
  }

  Future<List> getSuperAdminData() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.superAdminApi);
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        responseData = List.from(responseData.map((e) => GetAdmin.fromJson(e)));
        return responseData;
      } else {
        throw Exception('Failed to get super admin data code: ${response.statusCode}');
      }
    } catch (e) {
      print("Could not get super admin data $e");
      rethrow;
    }
  }

  Future<List<UserNotification>> getUserNotification() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.notificationApi);
      final response = await http.get(
        uri,
        headers: {
          "accept": '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        return List.from(responseData.map((e) => UserNotification.fromJson(e)));
      } else if (response.statusCode == 404) {
        return [];
      }
      throw Exception('Failed to get user notification code: ${response.statusCode}');
    } catch (e) {
      print("Could not get user notification $e");
      rethrow;
    }
  }

  Future<bool> readUserNotification(int id) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, "${ApiConstants.notificationApi}/Read/$id");
      final response = await http.put(
        uri,
        headers: {
          "accept": '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to read user notification code: ${response.statusCode}');
    } catch (e) {
      print("Could not read user notification $e");
      rethrow;
    }
  }

  //OA
  Future<List<OA>> getAllOAs({int page = 1}) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.opportunityAnalyzerApi, {
      "page": page.toString(),
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<OA> allOAs = jsonList.map((json) => OA.fromJson(json)).toList();
        return allOAs;
      } else {
        throw Exception('Failed to load OAs. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching OAs: $error');
      throw Exception('Error fetching OAs: $error');
    }
  }

  Future<OA> addOA(Map<String, dynamic> opportunityAnalyzerData, XFile? image) async {
    var uri = Uri.http(ApiConstants.baseUrl, ApiConstants.opportunityAnalyzerApi);
    var request = http.MultipartRequest('POST', uri);

    request.fields['firstName'] = opportunityAnalyzerData['firstName'];
    request.fields['lastName'] = opportunityAnalyzerData['lastName'];
    request.fields['phone'] = opportunityAnalyzerData['phone'];
    request.fields['email'] = opportunityAnalyzerData['email'];
    request.fields['canPost'] = opportunityAnalyzerData['canPost'];
    request.fields['password'] = opportunityAnalyzerData['password'];

    if (image != null) {
      var mimeTypeData = lookupMimeType(image.path)?.split('/');
      if (mimeTypeData != null) {
        request.files.add(
          http.MultipartFile(
            'picture',
            File(image.path).readAsBytes().asStream(),
            File(image.path).lengthSync(),
            filename: basename(image.path),
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      } else {
        throw Exception('Could not determine MIME type for image.');
      }
    }

    var response = await request.send();
    print("Response Status: ${response.statusCode}");

    var responseData = await http.Response.fromStream(response);
    print("Response Body: ${responseData.body}");

    if (response.statusCode == 201) {
      return OA.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to add admin: ${responseData.statusCode} - ${responseData.body}');
    }
  }

  Future<OA> fetchOADetails(String id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.opportunityAnalyzerApi}$id');

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return OA.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch Opportunity Analyzer details: ${response.body}');
    }
  }

  //OW
  Future<List<OW>> getAllOWs({int page = 1}) async {
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.opportunityOwnerApi, {
      "page": page.toString(),
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<OW> allOWs = jsonList.map((json) => OW.fromJson(json)).toList();
        return allOWs;
      } else {
        throw Exception('Failed to load OWs. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching OWs: $error');
      throw Exception('Error fetching OWs: $error');
    }
  }

  Future<OA> updateOA(Map<String, dynamic> OADAta, XFile? image) async {
    try {
      var uri =
          Uri.http(ApiConstants.baseUrl, '${ApiConstants.opportunityAnalyzerApi}${OADAta['id']}');
      print(uri.toString());
      var request = http.MultipartRequest('PUT', uri);

      // Adding fields to the request
      request.fields['id'] = OADAta['id'];
      request.fields['FirstName'] = OADAta['firstName'];
      request.fields['LastName'] = OADAta['lastName'];
      request.fields['Phone'] = OADAta['phone'];
      request.fields['Email'] = OADAta['email'];
      request.fields['CanPost'] = OADAta['canPost'];
      request.fields['Password'] = OADAta['password'];

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
      print("update oa response code: ${response.statusCode}");
      if (response.statusCode == 204) {
        // No Content
        return OA(); // Assuming an empty OA object
      } else if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        return OA.fromJson(jsonDecode(responseData.body));
      } else {
        var responseData = await http.Response.fromStream(response);
        throw Exception('Failed to update opportunity Analyzer: ${responseData.body}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

  // Add a new Opportunity Owner
  Future<OW> addOW(Map<String, dynamic> opportunityOwnerData, XFile? image) async {
    var uri = Uri.http(ApiConstants.baseUrl, ApiConstants.opportunityOwnerApi);
    var request = http.MultipartRequest('POST', uri);

    request.fields['firstName'] = opportunityOwnerData['firstName'];
    request.fields['lastName'] = opportunityOwnerData['lastName'];
    request.fields['phone'] = opportunityOwnerData['phone'];
    request.fields['email'] = opportunityOwnerData['email'];
    request.fields['canPost'] = opportunityOwnerData['canPost'];
    request.fields['password'] = opportunityOwnerData['password'];

    if (image != null) {
      var mimeTypeData = lookupMimeType(image.path)?.split('/');
      if (mimeTypeData != null) {
        request.files.add(
          http.MultipartFile(
            'picture',
            File(image.path).readAsBytes().asStream(),
            File(image.path).lengthSync(),
            filename: basename(image.path),
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      } else {
        throw Exception('Could not determine MIME type for image.');
      }
    }

    var response = await request.send();
    print("Response Status: ${response.statusCode}");

    var responseData = await http.Response.fromStream(response);
    print("Response Body: ${responseData.body}");

    if (response.statusCode == 201) {
      return OW.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception(
          'Failed to add Opportunity Owner: ${responseData.statusCode} - ${responseData.body}');
    }
  }

  // Fetch details of a specific Opportunity Owner
  Future<OW> fetchOWDetails(String id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.opportunityOwnerApi}$id');

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return OW.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch Opportunity Owner details: ${response.body}');
    }
  }

  Future<OW> updateOW(Map<String, dynamic> OWDAta, XFile? image) async {
    try {
      var uri =
          Uri.http(ApiConstants.baseUrl, '${ApiConstants.opportunityOwnerApi}/${OWDAta['id']}');
      var request = http.MultipartRequest('PUT', uri);

      // Adding fields to the request
      request.fields['id'] = OWDAta['id'];
      request.fields['FirstName'] = OWDAta['firstName'];
      request.fields['LastName'] = OWDAta['lastName'];
      request.fields['Phone'] = OWDAta['phone'];
      request.fields['Email'] = OWDAta['email'];
      request.fields['CanPost'] = OWDAta['canPost'];
      request.fields['Password'] = OWDAta['password'];

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

      if (response.statusCode == 204) {
        // No Content
        return OW(); // Assuming an empty OW object
      } else if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        return OW.fromJson(jsonDecode(responseData.body));
      } else {
        var responseData = await http.Response.fromStream(response);
        throw Exception('Failed to update opportunity owner: ${responseData.body}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

  Future<List<Opportunity>> getOpportunities() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.opportunitiesAdminApi);
      final response = await http.get(
        uri,
        headers: {
          "accept": '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return List.from(responseData.map((e) => Opportunity.fromJson(e)));
      }
      throw Exception('Failed to read user notification code: ${response.statusCode}');
    } catch (e) {
      print("Could not read user notification $e");
      rethrow;
    }
  }

  Future<List<Opportunity>> getOpportunityAnalyzerOpportunities() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final id = int.parse(Jwt.parseJwt(token)["nameid"]);
      final uri = Uri.http(ApiConstants.baseUrl, "${ApiConstants.opportunityAnalyzerApi}/$id");
      final response = await http.get(
        uri,
        headers: {
          "accept": '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return List.from(responseData.map((e) => Opportunity.fromJson(e)));
      }
      throw Exception('Failed to read user notification code: ${response.statusCode}');
    } catch (e) {
      print("Could not read user notification $e");
      rethrow;
    }
  }

  Future<List<Opportunity>> getOpportunityOwnerOpportunities() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final id = int.parse(Jwt.parseJwt(token)["nameid"]);
      final uri = Uri.http(ApiConstants.baseUrl, "${ApiConstants.opportunityOwnerApi}/$id");
      final response = await http.get(
        uri,
        headers: {
          "accept": '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return List.from(responseData.map((e) => Opportunity.fromJson(e)));
      }
      throw Exception('Failed to read user notification code: ${response.statusCode}');
    } catch (e) {
      print("Could not read user notification $e");
      rethrow;
    }
  }

  Future<List<OpportunityAnalyzer>> getOpportunityAnalyzers() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, "api${ApiConstants.opportunityAnalyzerApi}");
      print(uri.toString());
      final response = await http.get(
        uri,
        headers: {
          "accept": '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return List.from(responseData.map((e) => OpportunityAnalyzer.fromJson(e)));
      }
      throw Exception('Failed to get opportunity analyzers code: ${response.statusCode}');
    } catch (e) {
      print("Could not get opportunity analyzers $e");
      rethrow;
    }
  }

  Future<List<OpportunityOwner>> getOpportunityOwners() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, "api${ApiConstants.opportunityOwnerApi}");
      final response = await http.get(
        uri,
        headers: {
          "accept": '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return List.from(responseData.map((e) => OpportunityOwner.fromJson(e)));
      }
      throw Exception('Failed to get opportunity owners code: ${response.statusCode}');
    } catch (e) {
      print("Could not get opportunity owners $e");
      rethrow;
    }
  }

  Future<bool> addOpportunity(
    String title,
    String description,
    String clientId,
    String opportunityType,
    String feasibility,
    String risks,
    String score,
    String solution,
    String status,
    String? descriptionFile,
  ) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri =
          Uri.http(ApiConstants.baseUrl, "${ApiConstants.opportunitiesAdminApi}/AddWithPdf");
      final request = http.MultipartRequest("POST", uri);

      final body = {
        "Description": description,
        "ClientId": clientId,
        "Opportunity_Title": title,
        "Opportunity_Type": opportunityType,
        "Industry": "None ",
        "Feasibility": feasibility,
        "Risks": risks,
        "Score": score,
        "Solution": solution,
        "Status": status,
      };

      if (descriptionFile != null) {
        final mimeTypeData = lookupMimeType(descriptionFile)!.split('/');
        request.files.add(await http.MultipartFile.fromPath(
          "DescriptionFile",
          descriptionFile,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }

      request.fields.addAll(body);

      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      print(await response.stream.bytesToString());
      throw Exception('Failed to add opportunity: ${response.statusCode}');
    } catch (e) {
      print("Could not add opportunity $e");
      rethrow;
    }
  }

  Future<bool> deleteOpportunity(int id) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, "${ApiConstants.opportunitiesAdminApi}/$id");
      final response = await http.delete(uri, headers: {
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      print(response.body);
      throw Exception('Failed to delete opportunity: ${response.statusCode}');
    } catch (e) {
      print("Could not delete opportunity $e");
      rethrow;
    }
  }

  Future<bool> updateOpportunityStatus(int id, int status) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri =
          Uri.http(ApiConstants.baseUrl, "${ApiConstants.opportunitiesAdminApi}/changeStatus");
      final response =
          await http.put(uri, body: jsonEncode({"id": id, "statusId": status}), headers: {
        'Content-Type': 'application/json',
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 204) {
        return true;
      }
      print(response.body);
      throw Exception('Failed to update opportunity: ${response.statusCode}');
    } catch (e) {
      print("Could not update opportunity $e");
      rethrow;
    }
  }

  Future<bool> assignOpportunityAnalyzer(int id, int analyzer) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      final uri = Uri.http(ApiConstants.baseUrl,
          "${ApiConstants.opportunitiesAdminApi}/$id/opportunityAnalyzer/$analyzer");
      final response = await http.put(uri, headers: {
        'Content-Type': 'application/json',
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 204) {
        return true;
      }
      print(response.body);
      throw Exception('Failed to assign opportunity analyzer: ${response.statusCode}');
    } catch (e) {
      print("Could not assign opportunity analyzer $e");
      rethrow;
    }
  }

  Future<bool> assignOpportunityOwner(int id, int owner) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      final uri = Uri.http(ApiConstants.baseUrl,
          "${ApiConstants.opportunitiesAdminApi}/$id/opportunityOwner/$owner");
      final response = await http.put(uri, headers: {
        'Content-Type': 'application/json',
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 204) {
        return true;
      }
      print(response.body);
      throw Exception('Failed to assign opportunity owner: ${response.statusCode}');
    } catch (e) {
      print("Could not assign opportunity owner $e");
      rethrow;
    }
  }

  Future<List> getOpportunityStatus() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.opportunityStatusApi);
      final response = await http.get(uri, headers: {
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to get opportunity status: ${response.statusCode}');
    } catch (e) {
      print("Could not get opportunity status $e");
      rethrow;
    }
  }

  Future<bool> addOpportunityStatus(String name, int score) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.opportunityStatusApi);
      final response =
          await http.post(uri, body: jsonEncode({"name": name, "score": score}), headers: {
        'Content-Type': 'application/json',
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to add opportunity status: ${response.statusCode}');
    } catch (e) {
      print("Could not add opportunity status $e");
      rethrow;
    }
  }

  Future<bool> deleteOpportunityStatus(int id) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, "${ApiConstants.opportunityStatusApi}/$id");
      final response = await http.delete(uri, headers: {
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to delete opportunity status: ${response.statusCode}');
    } catch (e) {
      print("Could not delete opportunity status $e");
      rethrow;
    }
  }

  Future<List> getSolutions() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.solutionApi);
      final response = await http.get(uri, headers: {
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to get Solutions: ${response.statusCode}');
    } catch (e) {
      print("Could not get Solutions $e");
      rethrow;
    }
  }

  Future<bool> addSolution(String name) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.solutionApi);
      final response = await http.post(uri, body: jsonEncode({"name": name}), headers: {
        'Content-Type': 'application/json',
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to add Solutions: ${response.statusCode}');
    } catch (e) {
      print("Could not add Solutions $e");
      rethrow;
    }
  }

  Future<bool> deleteSolution(int id) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, "${ApiConstants.solutionApi}/$id");
      final response = await http.delete(uri, headers: {
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to delete Solutions: ${response.statusCode}');
    } catch (e) {
      print("Could not delete Solutions $e");
      rethrow;
    }
  }

  Future<List> getRisks() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.riskApi);
      final response = await http.get(uri, headers: {
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to get risk: ${response.statusCode}');
    } catch (e) {
      print("Could not get risk $e");
      rethrow;
    }
  }

  Future<bool> addRisk(String name) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.riskApi);
      final response = await http.post(uri, body: jsonEncode({"name": name}), headers: {
        'Content-Type': 'application/json',
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to add risk: ${response.statusCode}');
    } catch (e) {
      print("Could not add risk $e");
      rethrow;
    }
  }

  Future<bool> deleteRisk(int id) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, "${ApiConstants.riskApi}/$id");
      final response = await http.delete(uri, headers: {
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to delete risk: ${response.statusCode}');
    } catch (e) {
      print("Could not delete risk $e");
      rethrow;
    }
  }

  Future<List> getScore() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.scoreApi);
      final response = await http.get(uri, headers: {
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to get score: ${response.statusCode}');
    } catch (e) {
      print("Could not get score $e");
      rethrow;
    }
  }

  Future<bool> addScore(String name, int value) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, ApiConstants.scoreApi);
      final response =
          await http.post(uri, body: jsonEncode({"name": name, "value": value}), headers: {
        'Content-Type': 'application/json',
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to add score: ${response.statusCode}');
    } catch (e) {
      print("Could not add score $e");
      rethrow;
    }
  }

  Future<bool> deleteScore(int id) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      final uri = Uri.http(ApiConstants.baseUrl, "${ApiConstants.scoreApi}/$id");
      final response = await http.delete(uri, headers: {
        "accept": '*/*',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to delete score: ${response.statusCode}');
    } catch (e) {
      print("Could not delete score $e");
      rethrow;
    }
  }
}
