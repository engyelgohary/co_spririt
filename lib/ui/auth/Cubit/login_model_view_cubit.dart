import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/model/GetAdmin.dart';
import 'package:co_spirit/data/repository/repoContract.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:co_spirit/ui/od/home/home_od.dart';
import 'package:co_spirit/ui/om/home/home_om.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/home/home_admin.dart';
import '../../oa/home/home_oa.dart';
import '../../ow/home/home_ow.dart';
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
      String? token = await authRepository.login(
          email: emailController.text, password: passwordController.text);
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token); // Save the token
        print('Token: $token');
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print(decodedToken);

        if (decodedToken.containsKey('Type') || decodedToken.containsKey('type')) {
          String roleType = (decodedToken['Type'] ?? decodedToken['type']).toString();
          String? roleId = decodedToken['nameid']?.toString();

          switch (roleType) {
            case "0":
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int? superAdminId = int.tryParse(decodedToken['nameid']?.toString() ?? '');
              if (superAdminId != null) {
                await prefs.setInt('superAdminId', superAdminId);
              }
              if (roleId != null) {
                emit(LoginModelViewSuccess(HomeScreenOM(
                  superAdminId: roleId,
                )));
                print(decodedToken);
              } else {
                print('Role ID "nameid" not found for Admin.');
                emit(LoginModelViewError('Role ID "nameid" not found for Admin.'));
              }
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
                emit(LoginModelViewSuccess(HomeScreenAdmin(
                  OMId: roleId,
                  admin: admin!,
                )));
                print(decodedToken);
              } else {
                print('Role ID "nameid" not found for Admin.');
                emit(LoginModelViewError('Role ID "nameid" not found for Admin.'));
              }
              break;
            case "2":
              if (roleId != null) {
                emit(LoginModelViewSuccess(HomeScreenOD(ODId: roleId)));
                print(decodedToken);
              } else {
                print('Role ID "nameid" not found for Collaborator.');
                emit(LoginModelViewError('Role ID "nameid" not found for Collaborator.'));
              }
              break;
            case "3":
              if (roleId != null) {
                emit(LoginModelViewSuccess(HomeScreenOA(OAId: roleId)));
                print(decodedToken);
              } else {
                print('Role ID "nameid" not found for Opportunity Analyzer.');
                emit(LoginModelViewError('Role ID "nameid" not found for Opportunity Analyzer.'));
              }
              break;
            case "4":
              if (roleId != null) {
                emit(LoginModelViewSuccess(HomeScreenOW(OWId: roleId)));
                print(decodedToken);
              } else {
                print('Role ID "nameid" not found for Opportunity Owner.');
                emit(LoginModelViewError('Role ID "nameid" not found for Opportunity Owner.'));
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
