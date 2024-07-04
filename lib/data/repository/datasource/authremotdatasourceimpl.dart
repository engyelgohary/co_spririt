import 'package:co_spririt/data/model/AdminUser.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
import '../../api/apimanager.dart';
import '../repoContract.dart';

class AuthDataSourceImpl implements AuthRemoteDataSource{
  ApiManager apiManager;
  AuthDataSourceImpl({required this.apiManager});

  @override
  Future<AdminUser> registerAdmin({required String firstName, required String email, required String password, required String lastName, required String phone}) async{
    return await apiManager.registerAdmin(firstName: firstName, email: email, password: password, lastName: lastName, phone: phone);
  }

  @override
  Future<String?> login({required String email, required String password})async{
    return await apiManager.login(email: email,password:password);
  }

  @override
  Future<List<GetAdmin>> getAllAdmins({int page = 1}) async{
    // TODO: implement getAllAdmins
    return await apiManager.getAllAdmins(page: page);
  }
  }
