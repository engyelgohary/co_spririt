import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:image_picker/image_picker.dart';
import '../repoContract.dart';

class AuthRepositoryImpl implements AuthRepository{
  AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl({required this.authRemoteDataSource});
  @override
  Future< GetAdmin> registerAdmin(Map<String, dynamic> adminData, XFile? image) {
    return authRemoteDataSource.registerAdmin(adminData,image);
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