import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/apimanager.dart';
import '../repoContract.dart';

class AuthDataSourceImpl implements AuthRemoteDataSource{
  ApiManager apiManager;
  AuthDataSourceImpl({required this.apiManager});

  @override
  Future<GetAdmin> registerAdmin(Map<String, dynamic> adminData, XFile? image) async{
    return await apiManager.addAdmin(adminData,image);
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
