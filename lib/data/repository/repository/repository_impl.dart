import 'dart:io';
import 'package:co_spririt/data/model/Client.dart';
import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:co_spririt/data/model/RequestsResponse.dart';
import 'package:co_spririt/data/model/Type.dart';
import 'package:co_spririt/data/model/opportunities.dart';
import 'package:image_picker/image_picker.dart';
import '../repoContract.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});
  @override
  Future<String?> login({required String email, required String password}) {
    return authRemoteDataSource.login(email: email, password: password);
  }
  @override
  Future<GetAdmin?> fetchAdminDetails(int token) {
    return authRemoteDataSource.fetchAdminDetails(token);
  }
}

class AdminRepositoryImpl implements AdminRepository{
  AdminRemoteDataSource adminRemoteDataSource;
  AdminRepositoryImpl({required this.adminRemoteDataSource});
  @override
  Future< GetAdmin> registerAdmin(Map<String, dynamic> adminData, XFile? image) {
    return adminRemoteDataSource.registerAdmin(adminData,image);
  }

  @override
  Future<List<GetAdmin>> getAllAdmins({int page = 1}) {
 return adminRemoteDataSource.getAllAdmins(page: page);
  }

  @override
  Future<GetAdmin> fetchAdminDetails(int id) {
    return adminRemoteDataSource.fetchAdminDetails(id);

  }

  @override
  Future<GetAdmin> updateAdmin(Map<String, dynamic> adminData, XFile? image) {
    return adminRemoteDataSource.updateAdmin(adminData, image);
  }

  @override
  Future<GetAdmin> deleteAdmin(int id) {
   return adminRemoteDataSource.deleteAdmin(id);
  }

  @override
  Future<List<Collaborator>> getCollaboratorsToAdmin({int page = 1}) {
   return adminRemoteDataSource.getCollaboratorsToAdmin(page: page);
  }

  @override
  Future<void> setStatusToCollaborator(int collaboratorId,int selectStatus) {
   return adminRemoteDataSource.setStatusToCollaborator(collaboratorId,selectStatus);
  }
}
class ClientRepositoryImpl implements ClientRepository{
  ClientRemoteDataSource clientRemoteDataSource;
  ClientRepositoryImpl({required this.clientRemoteDataSource});
  @override
  Future<List<Client>> fetchAllClients({int page = 1}) {
    return clientRemoteDataSource.fetchAllClients(page: page);
  }

  @override
  Future<Client> addClient(String first,
      String email, String last, String phone) {
return clientRemoteDataSource.addClient(first,email,last,phone);
  }

  @override
  Future<Client> deleteClient(int id) {
   return clientRemoteDataSource.deleteClient(id);
  }

  @override
  Future<Client> fetchClientDetails(int id) {
   return clientRemoteDataSource.fetchClientDetails(id);
  }

  @override
  Future<void> updateClient(int id, String firstName, String lastName, String email, String contactNumber) {
 return clientRemoteDataSource.updateClient(id, firstName, lastName, email, contactNumber);
  }

}
class CollaboratorRepositoryImpl implements CollaboratorRepository{
  CollaboratorRemoteDataSource collaboratorRemoteDataSource;
  CollaboratorRepositoryImpl({required this.collaboratorRemoteDataSource});
  @override
  Future<List<Collaborator>> fetchAllCollaborators({int page = 1}) {
    return collaboratorRemoteDataSource.fetchAllCollaborators(page: page);
  }

  @override
  Future<Collaborator> deleteCollaborator(int id) {
   return collaboratorRemoteDataSource.deleteCollaborator(id);
  }

  @override
  Future<Collaborator> addCollaborator(Map<String, dynamic> collaboratorData, XFile? image, File? cv) {
    return collaboratorRemoteDataSource.addCollaborator(collaboratorData, image, cv);
  }

  @override
  Future<Collaborator> fetchCollaboratorDetails(int id) {
   return collaboratorRemoteDataSource.fetchCollaboratorDetails(id);
  }

  @override
  Future<Collaborator> updateCollaborator(Map<String, dynamic> collaboratorData, XFile? image, File? cv) {
   return collaboratorRemoteDataSource.updateCollaborator(collaboratorData, image, cv);
  }

  @override
  Future<Collaborator> assignCollaboratorToAdmin(int collaboratorId, int adminId) {
 return collaboratorRemoteDataSource.assignCollaboratorToAdmin(collaboratorId, adminId);
  }

  @override
  Future<Collaborator> assignCollaboratorToClient(int collaboratorId, int clientId) {
   return collaboratorRemoteDataSource.assignCollaboratorToClient(collaboratorId, clientId);
  }
}

class OpportunitiesRepositoryImpl implements OpportunitiesRepository{
  OpportunitiesDataSource opportunitiesDataSource;
  OpportunitiesRepositoryImpl({required this.opportunitiesDataSource});
  @override
  Future<void> submitOpportunity(Opportunities opportunity, File? descriptionFile) {
   return opportunitiesDataSource.submitOpportunity(opportunity, descriptionFile);
  }

  @override
  Future<List<Client>> fetchClientsByCollaborator() {
  return opportunitiesDataSource.fetchClientsByCollaborator();
  }

  @override
  Future<List<Opportunities>> getOpportunityData() {
   return opportunitiesDataSource.getOpportunityData();
  }

  @override
  Future<Opportunities> deleteOpportunities(int id) {
    return opportunitiesDataSource.deleteOpportunities(id);
  }

  @override
  Future<List<Opportunities>> getOpportunityDataAdmin() {
 return opportunitiesDataSource.getOpportunityDataAdmin();
  }
}
class TypesRepositoryImpl implements TypesRepository{
  TypesDataSource typesDataSource;
  TypesRepositoryImpl({required this.typesDataSource});
  @override
  Future<Types> addType(String type) {
        return typesDataSource.addType(type);
  }

  @override
  Future<List<Types>> fetchAllTypes({int page = 1}) {
   return typesDataSource.fetchAllTypes(page: page);
  }

  @override
  Future<Types> deleteTypes(int id) {
    return typesDataSource.deleteTypes(id);
  }

  @override
  Future<Types> fetchTypeDetails(int id) {
  return typesDataSource.fetchTypeDetails(id);
  }

  @override
  Future<void> updateTypes(int id, String type) {
 return typesDataSource.updateTypes(id, type);
  }

}
class RequestRepositoryImpl implements RequestsRepository{
  RequestsDataSource requestsDataSource;
  RequestRepositoryImpl({required this.requestsDataSource});
  @override
  Future<RequestsResponse> addRequest(String title, int typeId) {
   return requestsDataSource.addRequest(title, typeId);
  }

  @override
  Future<RequestsResponse> deleteRequests(int id) {
   return requestsDataSource.deleteRequests(id);
  }

  @override
  Future<List<RequestsResponse>> fetchAllRequests({int page = 1}) {
  return requestsDataSource.fetchAllRequests(page: page);
  }

  @override
  Future<RequestsResponse> fetchRequestDetails(int id) {
   return requestsDataSource.fetchRequestDetails(id);
  }

  @override
  Future<void> respondToRequest(int requestId, bool response) {
  return requestsDataSource.respondToRequest(requestId, response);
  }

}
