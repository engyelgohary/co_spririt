import 'dart:convert';
import 'dart:io';
import 'package:co_spririt/data/model/Client.dart';
import 'package:co_spririt/data/model/ClientReq.dart';
import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:co_spririt/data/model/Post.dart';
import 'package:co_spririt/data/model/RequestsReq.dart';
import 'package:co_spririt/data/model/RequestsResponse.dart';
import 'package:co_spririt/data/model/typeReq.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Type.dart';
import '../model/opportunities.dart';
import 'package:jwt_decode/jwt_decode.dart';



class ApiConstants {
  static const String baseUrl = '10.10.99.13:3090';
  static const String loginApi = '/api/auth/signin';
  static const String adminApi = '/api/v1/admin';
  static const String clientApi = '/api/v1/client';
  static const String collaboratorApi = '/api/v1/collaborator';
  static const String opportunitiesApi = '  /api/v1/opportunities/suggest';
  static const String opportunitiesColApi='/api/v1/opportunities/collaborator';
  static const String opportunitiesDeleteApi='/api/v1/opportunities/remove';
  static const String opportunitiesAdminApi='/api/v1/opportunities';
  static const String superAdminTypes= '/api/v1/request-type';
  static const String adminRequests= '/api/v1/requests';
  static const String allPostsApi ='/api/v1/post';
  static const String fetchPostsByAdminApi ='/api/v1/post/GetPostsAdmin';
}

class ApiManager {
  ApiManager._();
  static ApiManager? _instance;
  static ApiManager getInstanace() {
    _instance ??= ApiManager._();
    return _instance!;
  }
  final storage = FlutterSecureStorage();
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
        final List<GetAdmin> admins =
            jsonList.map((json) => GetAdmin.fromJson(json)).toList();
        return admins;
      } else {
        throw Exception(
            'Failed to load admins. Status code: ${response.statusCode}');
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
      var uri = Uri.http(
          ApiConstants.baseUrl, '${ApiConstants.adminApi}/${adminData['id']}');
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
        Uri.parse('http://${ApiConstants.baseUrl}${ApiConstants.adminApi}/collaborators?page=$page'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        print('Response data: $responseData'); // Add debug print statement
        List<Collaborator> opportunities = responseData.map((data) => Collaborator.fromJson(data)).toList();
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
        final List<Client> clients =
            jsonList.map((json) => Client.fromJson(json)).toList();
        return clients;
      } else {
        throw Exception(
            'Failed to load clients. Status code: ${response.statusCode}');
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
      throw Exception(
          'Failed to delete client. Status code: ${response.statusCode}');
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
        throw Exception(
            'Failed to update client. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<void> setStatusToCollaborator(int collaboratorId,int selectStatus) async {
    final url = Uri.parse("http://${ApiConstants.baseUrl}/api/v1/admin/set-status/$collaboratorId?status=$selectStatus"); // Ensure the URL starts with http:// or https://
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      final response = await http.put(url,
          headers: {
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
    final Uri url =
        Uri.http(ApiConstants.baseUrl, ApiConstants.collaboratorApi, {
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
        throw Exception(
            'Failed to load collaborator. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching collaborator: $error');
      throw Exception('Error fetching collaborator: $error');
    }
  }
  Future<Collaborator> deleteCollaborator(int id) async {
    var uri =
        Uri.http(ApiConstants.baseUrl, '${ApiConstants.collaboratorApi}/$id');
    final response = await http.delete(uri);
    if (response.statusCode == 204) {
      return Collaborator();
    } else if (response.statusCode == 200) {
      return Collaborator.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete collaborator ');
    }
  }
  Future<Collaborator> addCollaborator(Map<String, dynamic> collaboratorData, XFile? image, File? cv) async {
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
  Future<Collaborator> fetchCollaboratorDetails(int id) async {
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.collaboratorApi}/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Collaborator.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load collaborator details');
    }
  }
  Future<Collaborator> updateCollaborator(Map<String, dynamic> collaboratorData, XFile? image,File? cv) async {
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
    final url = Uri.parse("http://${ApiConstants.baseUrl}${ApiConstants.collaboratorApi}/$collaboratorId/admin/$adminId"); // Ensure the URL starts with http:// or https://

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
    final url = Uri.parse("http://${ApiConstants.baseUrl}${ApiConstants.collaboratorApi}/$collaboratorId/client/$clientId"); // Ensure the URL starts with http:// or https://

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
      throw Exception('Failed to submit opportunity');
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
        Uri.parse('http://${ApiConstants.baseUrl}${ApiConstants.opportunitiesColApi}?collaboratorId=$collaboratorId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        print('Response data: $responseData'); // Add debug print statement
        List<Opportunities> opportunities = responseData.map((data) => Opportunities.fromJson(data)).toList();
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
    var uri =
    Uri.http(ApiConstants.baseUrl, '${ApiConstants.opportunitiesDeleteApi}/$id');
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
        List<Opportunities> opportunities = responseData.map((data) => Opportunities.fromJson(data)).toList();
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
    var registerReq = TypeReq(
     type: type
    );

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
        final List<Types> types =
        jsonList.map((json) => Types.fromJson(json)).toList();
        return types;
      } else {
        throw Exception(
            'Failed to load Types. Status code: ${response.statusCode}');
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
      throw Exception(
          'Failed to delete Type. Status code: ${response.statusCode}');
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
      var typeData = TypeReq(
       type: type
      );
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(typeData),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
            'Failed to update type. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
//Request Collaborator
  Future<RequestsResponse> addRequest(String title,int typeId) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in.');
      }
      var uri = Uri.http(ApiConstants.baseUrl, ApiConstants.adminRequests);
      var registerReq = RequestsReq(
          description: title,
          requestTypeId: typeId
      );
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(registerReq.toJson()), // Encode to JSON string
      );

      if (response.statusCode == 201) {
        var registerResponse = RequestsResponse.fromJson(
            jsonDecode(response.body));
        return registerResponse;
      } else {
        throw Exception('Failed to add Request: ${response.body}');
      }
    }catch(e){
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
      final response = await http.get(url,
      headers:  {
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
        throw Exception(
            'Failed to load Requests. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching Requests: $error');
      throw Exception('Error fetching Requests: $error');
    }
  }
  Future<RequestsResponse> deleteRequests(int id) async {
    try{
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('No token found. Please log in.');
    }
    var uri = Uri.http(ApiConstants.baseUrl, '${ApiConstants.adminRequests}/$id');
    final response = await http.delete(
        uri,
        headers:
    {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 204) {
      return RequestsResponse();
    } else if (response.statusCode == 200) {
      return RequestsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to delete Request. Status code: ${response.statusCode}');
    }
    }catch(e){
      throw(e);
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
    if (image!= null) {
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

    var response = await request.send();

    var responseData = await http.Response.fromStream(response);

    if (response.statusCode == 201) {
      print('$responseData');
      return true;
    } else {
      print('Failed to create post: ${responseData.body}');
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
    final Uri url = Uri.http(ApiConstants.baseUrl, ApiConstants.fetchPostsByAdminApi, {'page': '$page'});
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
    final Uri url= Uri.http(ApiConstants.baseUrl, '${ApiConstants.allPostsApi}/$id', {
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
}


