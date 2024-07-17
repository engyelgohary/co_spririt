import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../model/Client.dart';
import '../model/Collaborator.dart';
import '../model/GetAdmin.dart';
//Auth
abstract class AuthRepository{
  Future<String?>  login({required String email,required String password});
}
abstract class AuthRemoteDataSource {
  Future<String?>  login({required String email,required String password});
}
//Admin
abstract class AdminRepository{
  Future<List<GetAdmin>>getAllAdmins({int page = 1});
  Future<GetAdmin> registerAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<GetAdmin> fetchAdminDetails(int id);
  Future<GetAdmin> updateAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<GetAdmin> deleteAdmin(int id);
}
abstract class AdminRemoteDataSource {
  Future<List<GetAdmin>>getAllAdmins({int page = 1});
  Future<GetAdmin> registerAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<GetAdmin> fetchAdminDetails(int id);
  Future<GetAdmin> updateAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<GetAdmin> deleteAdmin(int id);
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
