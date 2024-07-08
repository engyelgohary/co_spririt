import 'package:co_spririt/data/model/Client.dart';
import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
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
}
