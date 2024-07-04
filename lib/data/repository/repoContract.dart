import 'package:image_picker/image_picker.dart';

import '../model/GetAdmin.dart';

abstract class AuthRepository{
  Future<String?>  login({required String email,required String password});
  Future<List<GetAdmin>>getAllAdmins({int page = 1});
  Future<GetAdmin> registerAdmin(Map<String, dynamic> adminData, XFile? image);
}

abstract class AuthRemoteDataSource {
  Future<String?>  login({required String email,required String password});
  Future<List<GetAdmin>>getAllAdmins({int page = 1});
  Future<GetAdmin> registerAdmin(Map<String, dynamic> adminData, XFile? image);
}