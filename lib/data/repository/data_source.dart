import 'package:co_spirit/data/model/Collaborator.dart';
import 'package:co_spirit/data/model/admin.dart';
import 'package:image_picker/image_picker.dart';

abstract class AuthDataSource {
  Future<String> login({required String email, required String password});
}

abstract class AdminDataSource {
  Future<Admin> registerAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<List<Admin>> getAllAdmins({int page = 1});
  Future<Admin> fetchAdminDetails(int id);
  Future<Admin> updateAdmin(Map<String, dynamic> adminData, XFile? image);
  Future<Admin> deleteAdmin(int id);
  Future<List<Collaborator>> getCollaboratorsToAdmin({int page = 1});
  Future<void> setStatusToCollaborator(int collaboratorId, int selectStatus);
}

abstract class SMDataSource {
  Future<List> getTasks();
  Future<List> projectNameAndId();
  Future<List> categoryNameAndId({required int projectId});
  Future<List> getTargetService();
  Future<List> memberNameAndId();
  Future<List> taskStatusNameAndId();
  Future<List> getSolutions({required int id});
  Future<List> taskNameAndId({required int categoryId});
}

abstract class SCDataSource {
  Future<List> getTasks();
  Future<List> projectNameAndId();
  Future<List> categoryNameAndId({required int projectId});
  Future<List> getTargetService();
  Future<List> getSolutions({required int id});
}
