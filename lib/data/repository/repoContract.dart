import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../model/Client.dart';
import '../model/Collaborator.dart';
import '../model/GetAdmin.dart';
import '../model/OA.dart';
import '../model/RequestsResponse.dart';
import '../model/Type.dart';
import '../model/opportunities.dart';
//Auth
abstract class AuthRepository{
  Future<String?>  login({required String email,required String password});
  Future<GetAdmin?> fetchAdminDetails(int token);

}
abstract class AuthRemoteDataSource {
  Future<String?>  login({required String email,required String password});
  Future<GetAdmin?> fetchAdminDetails(int token);
}
//Admin
abstract class AdminRepository{
  Future<List<GetAdmin>>getAllAdmins({int page = 1});
  Future<GetAdmin> registerAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<GetAdmin> fetchAdminDetails(int id);
  Future<GetAdmin> updateAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<GetAdmin> deleteAdmin(int id);
  Future<List<Collaborator>> getCollaboratorsToAdmin({int page = 1});
  Future<void> setStatusToCollaborator(int collaboratorId,int selectStatus);
}
abstract class AdminRemoteDataSource {
  Future<List<GetAdmin>>getAllAdmins({int page = 1});
  Future<GetAdmin> registerAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<GetAdmin> fetchAdminDetails(int id);
  Future<GetAdmin> updateAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<GetAdmin> deleteAdmin(int id);
  Future<List<Collaborator>> getCollaboratorsToAdmin({int page = 1});
  Future<void> setStatusToCollaborator(int collaboratorId,int selectStatus);
}
//Client
abstract class ClientRepository{
  Future<List<Client>> fetchAllClients({int page = 1});
  Future<Client> addClient(String first, String email, String last, String phone);
  Future<Client> deleteClient(int id);
  Future<Client> fetchClientDetails(int id);
  Future<void> updateClient(int id, String firstName, String lastName, String email, String contactNumber);
}
abstract class ClientRemoteDataSource{
  Future<List<Client>> fetchAllClients({int page = 1});
  Future<Client> addClient(String first, String email, String last, String phone);
  Future<Client> deleteClient(int id);
  Future<Client> fetchClientDetails(int id);
  Future<void> updateClient(int id, String firstName, String lastName, String email, String contactNumber);
}
//Collaborator
abstract class CollaboratorRepository{
  Future<List<Collaborator>> fetchAllCollaborators({int page = 1});
  Future<Collaborator> deleteCollaborator(int id);
  Future<Collaborator> addCollaborator( Map<String, dynamic> collaboratorData, XFile? image, File? cv);
  Future<Collaborator> fetchCollaboratorDetails(int id);
  Future<Collaborator> updateCollaborator(Map<String, dynamic> collaboratorData, XFile? image,File? cv);
  Future<Collaborator> assignCollaboratorToAdmin(int collaboratorId, int adminId);
  Future<Collaborator> assignCollaboratorToClient(int collaboratorId, int clientId);
}
abstract class CollaboratorRemoteDataSource{
  Future<List<Collaborator>> fetchAllCollaborators({int page = 1});
  Future<Collaborator> deleteCollaborator(int id);
  Future<Collaborator> addCollaborator( Map<String, dynamic> collaboratorData, XFile? image, File? cv);
  Future<Collaborator> fetchCollaboratorDetails(int id);
  Future<Collaborator> updateCollaborator(Map<String, dynamic> collaboratorData, XFile? image,File? cv);
  Future<Collaborator> assignCollaboratorToAdmin(int collaboratorId, int adminId);
  Future<Collaborator> assignCollaboratorToClient(int collaboratorId, int clientId);
}
//opportunities
abstract class OpportunitiesRepository{
  Future<void> submitOpportunity(Opportunities opportunity, File? descriptionFile);
  Future<List<Client>> fetchClientsByCollaborator();
  Future<List<Opportunities>> getOpportunityData();
  Future<Opportunities> deleteOpportunities(int id);
  Future<List<Opportunities>> getOpportunityDataAdmin();
  }
abstract class OpportunitiesDataSource{
  Future<void> submitOpportunity(Opportunities opportunity, File? descriptionFile);
  Future<List<Client>> fetchClientsByCollaborator();
  Future<List<Opportunities>> getOpportunityData();
  Future<Opportunities> deleteOpportunities(int id);
  Future<List<Opportunities>> getOpportunityDataAdmin();
  }
  //types
abstract class TypesRepository{
  Future<Types> addType(String type);
  Future<List<Types>> fetchAllTypes({int page = 1});
  Future<Types> deleteTypes(int id);
  Future<Types> fetchTypeDetails(int id);
  Future<void> updateTypes(int id, String type);
}
abstract class TypesDataSource{
  Future<Types> addType(String type);
  Future<List<Types>> fetchAllTypes({int page = 1});
  Future<Types> deleteTypes(int id);
  Future<Types> fetchTypeDetails(int id);
  Future<void> updateTypes(int id, String type);
}
//Requetst
abstract class RequestsRepository{
  Future<RequestsResponse> addRequest(String title,int typeId);
  Future<List<RequestsResponse>> fetchAllRequests({int page = 1});
  Future<RequestsResponse> deleteRequests(int id);
  Future<RequestsResponse> fetchRequestDetails(int id);
  Future<void> respondToRequest(int requestId, bool response);
}
abstract class RequestsDataSource{
  Future<RequestsResponse> addRequest(String title,int typeId);
  Future<List<RequestsResponse>> fetchAllRequests({int page = 1});
  Future<RequestsResponse> deleteRequests(int id);
  Future<RequestsResponse> fetchRequestDetails(int id);
  Future<void> respondToRequest(int requestId, bool response);

}

//OA
abstract class OpportunityAnalyzerRepository{
  Future<List<OA>>getAllOAs({int page = 1});
  Future<OA> addOA(Map<String, dynamic> opportunityAnalyzerData, XFile? image);

}