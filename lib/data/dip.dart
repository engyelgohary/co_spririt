import 'package:co_spririt/data/repository/datasource/authremotdatasourceimpl.dart';
import 'package:co_spririt/data/repository/repoContract.dart';
import 'package:co_spririt/data/repository/repository/auth_repository_impl.dart';
import 'api/apimanager.dart';

AuthRepository injectAuthRepository(){
  return AuthRepositoryImpl(authRemoteDataSource: injectAuthRemoteDataSource());
}
AuthRemoteDataSource injectAuthRemoteDataSource(){
  return AuthDataSourceImpl(apiManager:ApiManager.getInstanace());
}
