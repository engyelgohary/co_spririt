import 'package:bloc/bloc.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:co_spririt/data/repository/repoContract.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:co_spririt/ui/collaborator/home/home_colla.dart';
import 'package:co_spririt/ui/superadmin/home/home_superadmin.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/home/home_admin.dart';
part 'login_model_view_state.dart';

class LoginModelViewCubit extends Cubit<LoginModelViewState> {
  LoginModelViewCubit({required this.authRepository}) : super(LoginModelViewInitial());
  AuthRepository authRepository;
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  bool isObscure = true;

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      emit(LoginModelViewLoading());
      String? token = await authRepository.login(email: emailController.text, password: passwordController.text);
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);  // Save the token
        print('Token: $token');
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print(decodedToken);

        if (decodedToken.containsKey('Type') || decodedToken.containsKey('type')) {
          String roleType = (decodedToken['Type'] ?? decodedToken['type']).toString();
          String? roleId = decodedToken['nameid']?.toString();

          switch (roleType) {
            case "0":
            // Super Admin doesn't require roleId
              emit(LoginModelViewSuccess(HomeScreenSuperAdmin()));
              print(decodedToken);
              break;
            case "1":
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int? adminId = int.tryParse(decodedToken['nameid']?.toString() ?? '');
              print('Admin ID: $adminId');

              if (adminId != null) {
                await prefs.setInt('adminId', adminId);
              } else {
                emit(LoginModelViewError('Invalid admin ID.'));
                return;
              }
              print('Fetching admin details for ID: $adminId');
              GetAdmin? admin = await authRepository.fetchAdminDetails(adminId);
              if (roleId != null) {
                emit(LoginModelViewSuccess(HomeScreenAdmin(adminId: roleId,admin: admin!,)));
                print(decodedToken);
              } else {
                print('Role ID "nameid" not found for Admin.');
                emit(LoginModelViewError('Role ID "nameid" not found for Admin.'));
              }
              break;
            case "2":
              if (roleId != null) {
                emit(LoginModelViewSuccess(HomeScreenColla(CollaboratorId:roleId)));
                print(decodedToken);
              } else {
                print('Role ID "nameid" not found for Collaborator.');
                emit(LoginModelViewError('Role ID "nameid" not found for Collaborator.'));
              }
              break;
            default:
              print('Unknown role: $roleType');
              emit(LoginModelViewError('Unknown role: $roleType'));
          }
        } else {
          print('Role key "Type" not found in the token.');
          emit(LoginModelViewError('Role key "Type" not found in the token.'));
        }
      } else {
        emit(LoginModelViewError('Login failed.'));
      }
    }
  }
}
