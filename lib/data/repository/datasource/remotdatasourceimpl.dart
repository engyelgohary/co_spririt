import 'dart:io';
import 'package:co_spririt/data/model/Client.dart';
import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:co_spririt/data/model/RequestsResponse.dart';
import 'package:co_spririt/data/model/Type.dart';
import 'package:co_spririt/data/model/opportunities.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/apimanager.dart';
import '../repoContract.dart';

class AuthDataSourceImpl implements AuthRemoteDataSource {
  ApiManager apiManager;
  AuthDataSourceImpl({required this.apiManager});
  @override
  Future<String?> login(
      {required String email, required String password}) async {
    return await apiManager.login(email: email, password: password);
  }

  @override
  Future<GetAdmin?> fetchAdminDetails(int token) async {
    return await apiManager.fetchAdminDetails(token);
  }
}

class AdminDataSourceImpl implements AdminRemoteDataSource {
  ApiManager apiManager;
  AdminDataSourceImpl({required this.apiManager});

  @override
  Future<GetAdmin> registerAdmin(
      Map<String, dynamic> adminData, XFile? image) async {
    return await apiManager.addAdmin(adminData, image);
  }

  @override
  Future<List<GetAdmin>> getAllAdmins({int page = 1}) async {
    return await apiManager.getAllAdmins(page: page);
  }

  @override
  Future<GetAdmin> fetchAdminDetails(int id) async {
    return await apiManager.fetchAdminDetails(id);
  }

  @override
  Future<GetAdmin> updateAdmin(
      Map<String, dynamic> adminData, XFile? image) async {
    return await apiManager.updateAdmin(adminData, image);
  }

  @override
  Future<GetAdmin> deleteAdmin(int id) async {
    return await apiManager.deleteAdmin(id);
  }

  @override
  Future<List<Collaborator>> getCollaboratorsToAdmin({int page = 1}) async{
    return await apiManager.getCollaboratorsToAdmin(page: page);
  }

  @override
  Future<void> setStatusToCollaborator(int collaboratorId,int selectStatus) async{
   return await apiManager.setStatusToCollaborator(collaboratorId,selectStatus);
  }
}

class ClientDataSourceImpl implements ClientRemoteDataSource {
  ApiManager apiManager;
  ClientDataSourceImpl({required this.apiManager});
  @override
  Future<List<Client>> fetchAllClients({int page = 1}) async {
    return await apiManager.fetchAllClients(page: page);
  }

  @override
  Future<Client> addClient(String first, String email, String last, String phone) async{
    return await apiManager.addClient(first,email,last,phone);
  }

  @override
  Future<Client> deleteClient(int id) async {
  return await apiManager.deleteClient(id);
  }

  @override
  Future<Client> fetchClientDetails(int id) async{
   return await apiManager.fetchClientDetails(id);
  }

  @override
  Future<void> updateClient(int id, String firstName, String lastName, String email, String contactNumber) async{
   return await apiManager.updateClient(id, firstName, lastName, email, contactNumber);
  }
}

class CollaboratorDataSourceImpl implements CollaboratorRemoteDataSource{
  ApiManager apiManager;
  CollaboratorDataSourceImpl({required this.apiManager});
  @override
  Future<List<Collaborator>> fetchAllCollaborators({int page = 1}) async{
   return await apiManager.fetchAllCollaborators(page: page);
  }

  @override
  Future<Collaborator> deleteCollaborator(int id) async{
   return await apiManager.deleteCollaborator(id);
  }

  @override
  Future<Collaborator> addCollaborator( Map<String, dynamic> collaboratorData, XFile? image, File? cv) async{
   return await apiManager.addCollaborator(collaboratorData, image, cv);
  }

  @override
  Future<Collaborator> fetchCollaboratorDetails(int id) async {
  return await apiManager.fetchCollaboratorDetails(id);
  }

  @override
  Future<Collaborator> updateCollaborator(Map<String, dynamic> collaboratorData, XFile? image, File? cv) async{
    return await apiManager.updateCollaborator(collaboratorData, image, cv);
  }

  @override
  Future<Collaborator> assignCollaboratorToAdmin(int collaboratorId, int adminId) async{
   return await apiManager.assignCollaboratorToAdmin(collaboratorId, adminId);
  }

  @override
  Future<Collaborator> assignCollaboratorToClient(int collaboratorId, int clientId) async {
return await apiManager.assignCollaboratorToClient(collaboratorId, clientId);
  }
}
class OpportunitiesDataSourceImpl implements OpportunitiesDataSource{
  ApiManager apiManager;
  OpportunitiesDataSourceImpl({required this.apiManager});
  @override
  Future<void> submitOpportunity(Opportunities opportunity, File? descriptionFile) async{
     return await apiManager.submitOpportunity(opportunity, descriptionFile);
  }

  @override
  Future<List<Client>> fetchClientsByCollaborator() async{
 return await apiManager.fetchClientsByCollaborator();
  }

  @override
  Future<List<Opportunities>> getOpportunityData() async{
    return await apiManager.getOpportunityData();
  }

  @override
  Future<Opportunities> deleteOpportunities(int id) async {
    return await apiManager.deleteOpportunities(id);

  }

  @override
  Future<List<Opportunities>> getOpportunityDataAdmin() async {
  return await apiManager.getOpportunityDataAdmin();
  }
}
class TypesDataSourceImpl implements TypesDataSource{
  ApiManager apiManager;
  TypesDataSourceImpl({required this.apiManager});
  @override
  Future<Types> addType(String type) async{
    return await apiManager.addType(type);
  }

  @override
  Future<List<Types>> fetchAllTypes({int page = 1}) async {
   return await apiManager.fetchAllTypes(page: page);
  }

  @override
  Future<Types> deleteTypes(int id) async{
    return await apiManager.deleteTypes(id);
  }

  @override
  Future<Types> fetchTypeDetails(int id) async{
  return await apiManager.fetchTypeDetails(id);
  }

  @override
  Future<void> updateTypes(int id, String type) async{
  return await apiManager.updateTypes(id, type);
  }

}
class RequestsDataSourceImpl implements RequestsDataSource{
  ApiManager apiManager;
  RequestsDataSourceImpl({required this.apiManager});

  @override
  Future<RequestsResponse> addRequest(String title, int typeId) async{
  return await apiManager.addRequest(title, typeId);
  }

  @override
  Future<RequestsResponse> deleteRequests(int id) async{
  return await apiManager.deleteRequests(id);
  }

  @override
  Future<List<RequestsResponse>> fetchAllRequests({int page = 1}) async{
return await apiManager.fetchAllRequests(page: page);
  }

  @override
  Future<RequestsResponse> fetchRequestDetails(int id) async{
 return await apiManager.fetchRequestDetails(id);
  }

  @override
  Future<void> respondToRequest(int requestId, bool response) async {
    return await apiManager.respondToRequest(requestId, response);
  }

}