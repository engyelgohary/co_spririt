import '../model/AdminUser.dart';
import '../model/GetAdmin.dart';

abstract class AuthRepository{
  Future<String?>  login({required String email,required String password});
  Future<List<GetAdmin>>getAllAdmins({int page = 1});
  Future<AdminUser> registerAdmin({required String firstName,
    required String email, required String password,required  String lastName, required String phone});
}

abstract class AuthRemoteDataSource {
  Future<String?>  login({required String email,required String password});
  Future<List<GetAdmin>>getAllAdmins({int page = 1});
  Future<AdminUser> registerAdmin({required String firstName,
    required String email, required String password, required String lastName, required String phone});
}