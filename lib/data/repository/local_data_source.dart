import 'dart:io';
import 'package:co_spirit/data/model/Client.dart';
import 'package:co_spirit/data/model/Collaborator.dart';
import 'package:co_spirit/data/model/admin.dart';
import 'package:co_spirit/data/model/OA.dart';
import 'package:co_spirit/data/model/OW.dart';
import 'package:co_spirit/data/model/RequestsResponse.dart';
import 'package:co_spirit/data/model/Type.dart';
import 'package:co_spirit/data/model/opportunities.dart';
import 'package:image_picker/image_picker.dart';
import '../api/apimanager.dart';

class AuthDataSourceLocal {
  ApiManager apiManager;
  AuthDataSourceLocal({required this.apiManager});
  Future<String?> login({required String email, required String password}) async {
    return await apiManager.login(email: email, password: password);
  }

  Future<Admin?> fetchAdminDetails(int token) async {
    return await apiManager.fetchAdminDetails(token);
  }
}

class AdminDataSourceLocal {
  ApiManager apiManager;
  AdminDataSourceLocal({required this.apiManager});

  Future<Admin> registerAdmin(Map<String, dynamic> adminData, XFile? image) async {
    return await apiManager.addAdmin(adminData, image);
  }

  Future<List<Admin>> getAllAdmins({int page = 1}) async {
    return await apiManager.getAllAdmins(page: page);
  }

  Future<Admin> fetchAdminDetails(int id) async {
    return await apiManager.fetchAdminDetails(id);
  }

  Future<Admin> updateAdmin(Map<String, dynamic> adminData, XFile? image) async {
    return await apiManager.updateAdmin(adminData, image);
  }

  Future<Admin> deleteAdmin(int id) async {
    return await apiManager.deleteAdmin(id);
  }

  Future<List<Collaborator>> getCollaboratorsToAdmin({int page = 1}) async {
    return await apiManager.getCollaboratorsToAdmin(page: page);
  }

  Future<void> setStatusToCollaborator(int collaboratorId, int selectStatus) async {
    return await apiManager.setStatusToCollaborator(collaboratorId, selectStatus);
  }
}

class ClientDataSourceLocal {
  ApiManager apiManager;
  ClientDataSourceLocal({required this.apiManager});
  Future<List<Client>> fetchAllClients({int page = 1}) async {
    return await apiManager.fetchAllClients(page: page);
  }

  Future<Client> addClient(String first, String email, String last, String phone) async {
    return await apiManager.addClient(first, email, last, phone);
  }

  Future<Client> deleteClient(int id) async {
    return await apiManager.deleteClient(id);
  }

  Future<Client> fetchClientDetails(int id) async {
    return await apiManager.fetchClientDetails(id);
  }

  Future<void> updateClient(
      int id, String firstName, String lastName, String email, String contactNumber) async {
    return await apiManager.updateClient(id, firstName, lastName, email, contactNumber);
  }
}

class CollaboratorDataSourceLocal {
  ApiManager apiManager;
  CollaboratorDataSourceLocal({required this.apiManager});
  Future<List<Collaborator>> fetchAllCollaborators({int page = 1}) async {
    return await apiManager.fetchAllCollaborators(page: page);
  }

  Future<Collaborator> deleteCollaborator(int id) async {
    return await apiManager.deleteCollaborator(id);
  }

  Future<Collaborator> addCollaborator(
      Map<String, dynamic> collaboratorData, XFile? image, File? cv) async {
    return await apiManager.addCollaborator(collaboratorData, image, cv);
  }

  Future<Collaborator> fetchCollaboratorDetails(int id) async {
    return await apiManager.fetchCollaboratorDetails(id);
  }

  Future<Collaborator> updateCollaborator(
      Map<String, dynamic> collaboratorData, XFile? image, File? cv) async {
    return await apiManager.updateCollaborator(collaboratorData, image, cv);
  }

  Future<Collaborator> assignCollaboratorToAdmin(int collaboratorId, int adminId) async {
    return await apiManager.assignCollaboratorToAdmin(collaboratorId, adminId);
  }

  Future<Collaborator> assignCollaboratorToClient(int collaboratorId, int clientId) async {
    return await apiManager.assignCollaboratorToClient(collaboratorId, clientId);
  }
}

class OpportunitiesDataSourceLocal {
  ApiManager apiManager;
  OpportunitiesDataSourceLocal({required this.apiManager});
  Future<void> submitOpportunity(Opportunities opportunity, File? descriptionFile) async {
    return await apiManager.submitOpportunity(opportunity, descriptionFile);
  }

  Future<List<Client>> fetchClientsByCollaborator() async {
    return await apiManager.fetchClientsByCollaborator();
  }

  Future<List<Opportunities>> getOpportunityData() async {
    return await apiManager.getOpportunityData();
  }

  Future<Opportunities> deleteOpportunities(int id) async {
    return await apiManager.deleteOpportunities(id);
  }

  Future<List<Opportunities>> getOpportunityDataAdmin() async {
    return await apiManager.getOpportunityDataAdmin();
  }
}

class TypesDataSourceLocal {
  ApiManager apiManager;
  TypesDataSourceLocal({required this.apiManager});
  Future<Types> addType(String type) async {
    return await apiManager.addType(type);
  }

  Future<List<Types>> fetchAllTypes({int page = 1}) async {
    return await apiManager.fetchAllTypes(page: page);
  }

  Future<Types> deleteTypes(int id) async {
    return await apiManager.deleteTypes(id);
  }

  Future<Types> fetchTypeDetails(int id) async {
    return await apiManager.fetchTypeDetails(id);
  }

  Future<void> updateTypes(int id, String type) async {
    return await apiManager.updateTypes(id, type);
  }
}

class RequestsDataSourceLocal {
  ApiManager apiManager;
  RequestsDataSourceLocal({required this.apiManager});

  Future<RequestsResponse> addRequest(String title, int typeId) async {
    return await apiManager.addRequest(title, typeId);
  }

  Future<RequestsResponse> deleteRequests(int id) async {
    return await apiManager.deleteRequests(id);
  }

  Future<List<RequestsResponse>> fetchAllRequests({int page = 1}) async {
    return await apiManager.fetchAllRequests(page: page);
  }

  Future<RequestsResponse> fetchRequestDetails(int id) async {
    return await apiManager.fetchRequestDetails(id);
  }

  Future<void> respondToRequest(int requestId, bool response) async {
    return await apiManager.respondToRequest(requestId, response);
  }
}

class AuthRepositoryLocal {
  ApiManager apiManager;

  AuthRepositoryLocal({required this.apiManager});
  Future<String?> login({required String email, required String password}) {
    return apiManager.login(email: email, password: password);
  }

  Future<Admin?> fetchAdminDetails(int token) {
    return apiManager.fetchAdminDetails(token);
  }
}

class AdminRepositoryLocal {
  ApiManager apiManager;
  AdminRepositoryLocal({required this.apiManager});
  Future<Admin> registerAdmin(Map<String, dynamic> adminData, XFile? image) {
    return apiManager.addAdmin(adminData, image);
  }

  Future<List<Admin>> getAllAdmins({int page = 1}) {
    return apiManager.getAllAdmins(page: page);
  }

  Future<Admin> fetchAdminDetails(int id) {
    return apiManager.fetchAdminDetails(id);
  }

  Future<Admin> updateAdmin(Map<String, dynamic> adminData, XFile? image) {
    return apiManager.updateAdmin(adminData, image);
  }

  Future<Admin> deleteAdmin(int id) {
    return apiManager.deleteAdmin(id);
  }

  Future<List<Collaborator>> getCollaboratorsToAdmin({int page = 1}) {
    return apiManager.getCollaboratorsToAdmin(page: page);
  }

  Future<void> setStatusToCollaborator(int collaboratorId, int selectStatus) {
    return apiManager.setStatusToCollaborator(collaboratorId, selectStatus);
  }
}

class ClientRepositoryLocal {
  ApiManager apiManager;

  ClientRepositoryLocal({required this.apiManager});
  Future<List<Client>> fetchAllClients({int page = 1}) {
    return apiManager.fetchAllClients(page: page);
  }

  Future<Client> addClient(String first, String email, String last, String phone) {
    return apiManager.addClient(first, email, last, phone);
  }

  Future<Client> deleteClient(int id) {
    return apiManager.deleteClient(id);
  }

  Future<Client> fetchClientDetails(int id) {
    return apiManager.fetchClientDetails(id);
  }

  Future<void> updateClient(
      int id, String firstName, String lastName, String email, String contactNumber) {
    return apiManager.updateClient(id, firstName, lastName, email, contactNumber);
  }
}

class CollaboratorRepositoryLocal {
  ApiManager apiManager;
  CollaboratorRepositoryLocal({required this.apiManager});
  Future<List<Collaborator>> fetchAllCollaborators({int page = 1}) {
    return apiManager.fetchAllCollaborators(page: page);
  }

  Future<Collaborator> deleteCollaborator(int id) {
    return apiManager.deleteCollaborator(id);
  }

  Future<Collaborator> addCollaborator(
      Map<String, dynamic> collaboratorData, XFile? image, File? cv) {
    return apiManager.addCollaborator(collaboratorData, image, cv);
  }

  Future<Collaborator> fetchCollaboratorDetails(int id) {
    return apiManager.fetchCollaboratorDetails(id);
  }

  Future<Collaborator> updateCollaborator(
      Map<String, dynamic> collaboratorData, XFile? image, File? cv) {
    return apiManager.updateCollaborator(collaboratorData, image, cv);
  }

  Future<Collaborator> assignCollaboratorToAdmin(int collaboratorId, int adminId) {
    return apiManager.assignCollaboratorToAdmin(collaboratorId, adminId);
  }

  Future<Collaborator> assignCollaboratorToClient(int collaboratorId, int clientId) {
    return apiManager.assignCollaboratorToClient(collaboratorId, clientId);
  }
}

class OpportunitiesRepositoryLocal {
  final ApiManager apiManager;
  OpportunitiesRepositoryLocal({required this.apiManager});
  Future<void> submitOpportunity(Opportunities opportunity, File? descriptionFile) {
    return apiManager.submitOpportunity(opportunity, descriptionFile);
  }

  Future<List<Client>> fetchClientsByCollaborator() {
    return apiManager.fetchClientsByCollaborator();
  }

  Future<List<Opportunities>> getOpportunityData() {
    return apiManager.getOpportunityData();
  }

  Future<Opportunities> deleteOpportunities(int id) {
    return apiManager.deleteOpportunities(id);
  }

  Future<List<Opportunities>> getOpportunityDataAdmin() {
    return apiManager.getOpportunityDataAdmin();
  }
}

class TypesRepositoryLocal {
  final ApiManager apiManager;
  TypesRepositoryLocal({required this.apiManager});
  Future<Types> addType(String type) {
    return apiManager.addType(type);
  }

  Future<List<Types>> fetchAllTypes({int page = 1}) {
    return apiManager.fetchAllTypes(page: page);
  }

  Future<Types> deleteTypes(int id) {
    return apiManager.deleteTypes(id);
  }

  Future<Types> fetchTypeDetails(int id) {
    return apiManager.fetchTypeDetails(id);
  }

  Future<void> updateTypes(int id, String type) {
    return apiManager.updateTypes(id, type);
  }
}

class RequestRepositoryLocal {
  final ApiManager apiManager;
  RequestRepositoryLocal({required this.apiManager});
  Future<RequestsResponse> addRequest(String title, int typeId) {
    return apiManager.addRequest(title, typeId);
  }

  Future<RequestsResponse> deleteRequests(int id) {
    return apiManager.deleteRequests(id);
  }

  Future<List<RequestsResponse>> fetchAllRequests({int page = 1}) {
    return apiManager.fetchAllRequests(page: page);
  }

  Future<RequestsResponse> fetchRequestDetails(int id) {
    return apiManager.fetchRequestDetails(id);
  }

  Future<void> respondToRequest(int requestId, bool response) {
    return apiManager.respondToRequest(requestId, response);
  }
}

class OpportunityAnalyzerRepositoryLocal {
  final ApiManager apiManager;

  OpportunityAnalyzerRepositoryLocal({required this.apiManager});

  Future<OA> addOA(Map<String, dynamic> opportunityAnalyzerData, XFile? image) {
    return apiManager.addOA(opportunityAnalyzerData, image);
  }

  Future<List<OA>> getAllOAs({int page = 1}) {
    return apiManager.getAllOAs(page: page);
  }

  Future<OA> fetchOADetails(String id) {
    return apiManager.fetchOADetails(id);
  }

  Future<OA> updateOA(Map<String, dynamic> adminData, XFile? image) {
    return apiManager.updateOA(adminData, image);
  }
}

class OpportunityOwnerRepositoryLocal {
  final ApiManager apiManager;

  OpportunityOwnerRepositoryLocal({required this.apiManager});

  Future<OW> addOW(Map<String, dynamic> opportunityOwnerData, XFile? image) {
    return apiManager.addOW(opportunityOwnerData, image);
  }

  Future<List<OW>> getAllOWs({int page = 1}) {
    return apiManager.getAllOWs(page: page);
  }

  Future<OW> fetchOWDetails(String id) {
    return apiManager.fetchOWDetails(id);
  }

  Future<OW> updateOW(Map<String, dynamic> OWData, XFile? image) {
    return apiManager.updateOW(OWData, image);
  }
}
