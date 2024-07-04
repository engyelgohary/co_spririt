import 'package:co_spririt/data/model/AdminUser.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
import '../repoContract.dart';

class AuthRepositoryImpl implements AuthRepository{
  AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl({required this.authRemoteDataSource});
  @override
  Future< AdminUser> registerAdmin({required String firstName, required String email, required String password, required String lastName, required String phone}) {
    return authRemoteDataSource.registerAdmin(firstName: firstName, email: email, password: password, lastName: lastName, phone: phone);
  }

  @override
  Future<String?> login({required String email, required String password}) {
    return authRemoteDataSource.login(email: email, password: password);
  }

  @override
  Future<List<GetAdmin>> getAllAdmins({int page = 1}) {
 return authRemoteDataSource.getAllAdmins(page: page);
  }
}