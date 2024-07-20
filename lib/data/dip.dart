import 'package:co_spririt/data/repository/datasource/remotdatasourceimpl.dart';
import 'package:co_spririt/data/repository/repoContract.dart';
import 'package:co_spririt/data/repository/repository/repository_impl.dart';
import 'api/apimanager.dart';

AuthRepository injectAuthRepository(){
  return AuthRepositoryImpl(authRemoteDataSource:injectAuthRemoteDataSource());
}
AuthRemoteDataSource injectAuthRemoteDataSource(){
  return AuthDataSourceImpl(apiManager:ApiManager.getInstanace());
}
AdminRepository injectAdminRepository(){
  return AdminRepositoryImpl(adminRemoteDataSource: injectAdminRemoteDataSource());
}
AdminRemoteDataSource injectAdminRemoteDataSource(){
  return AdminDataSourceImpl(apiManager:ApiManager.getInstanace());
}

ClientRepository injectClientRepository(){
  return ClientRepositoryImpl(clientRemoteDataSource: injectClientRemoteDataSource());
}
ClientRemoteDataSource injectClientRemoteDataSource(){
  return ClientDataSourceImpl(apiManager:ApiManager.getInstanace());
}
CollaboratorRepository injectCollaboratorRepository(){
  return CollaboratorRepositoryImpl(collaboratorRemoteDataSource: injectCollaboratorRemoteDataSource());
}
CollaboratorRemoteDataSource injectCollaboratorRemoteDataSource(){
  return CollaboratorDataSourceImpl(apiManager:ApiManager.getInstanace());
}
OpportunitiesRepository injectOpportunitiesRepository(){
  return OpportunitiesRepositoryImpl(opportunitiesDataSource: injectOpportunitiesRemoteDataSource());
}
OpportunitiesDataSource injectOpportunitiesRemoteDataSource(){
  return OpportunitiesDataSourceImpl(apiManager:ApiManager.getInstanace());
}

