import 'package:dio/dio.dart';

class ProjectManagementApi {
  Dio dio = Dio(BaseOptions(connectTimeout: Duration(seconds: 5)));
}
