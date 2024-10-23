import 'package:dio/dio.dart';

class ProjectManagementApi {
  Dio dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));
}
