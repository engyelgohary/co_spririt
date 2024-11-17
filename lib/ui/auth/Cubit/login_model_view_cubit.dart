import 'package:bloc/bloc.dart';
import 'package:co_spirit/core/Cubit/cubit_state.dart';
import 'package:co_spirit/data/repository/data_source.dart';
import 'package:co_spirit/ui/home/oa_home.dart';
import 'package:co_spirit/edited_ui/home/od_home.dart';
import 'package:co_spirit/ui/home/om_home.dart';
import 'package:co_spirit/ui/home/ow_home.dart';
import 'package:co_spirit/ui/home/sc_home.dart';
import 'package:co_spirit/ui/home/sm_home.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_model_view_state.dart';

class LoginCubit extends Cubit<CubitState> {
  AuthDataSource authDataSource;
  LoginCubit({required this.authDataSource}) : super(CubitInitialState());
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  bool isObscure = true;

  void login() async {
    emit(CubitLoadingState());

    String token = await authDataSource.login(
      email: emailController.text,
      password: passwordController.text,
    );

    if (token.isEmpty) {
      return emit(CubitFailureState('Login failed.'));
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token); // Save the token
    print('Token: $token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print(decodedToken);

    if (!decodedToken.containsKey('Type') && !decodedToken.containsKey('type')) {
      print('Role key "Type" not found in the token.');
      return emit(CubitFailureState('Role key "Type" not found in the token.'));
    }

    if (decodedToken.containsKey('Type') || decodedToken.containsKey('type')) {
      String roleType = (decodedToken['Type'] ?? decodedToken['type']).toString();
      String? userId = decodedToken['nameid']?.toString();

      switch (roleType) {
        case "0":
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int? superAdminId = int.tryParse(decodedToken['nameid']?.toString() ?? '');
          if (superAdminId != null) {
            await prefs.setInt('superAdminId', superAdminId);
          }
          if (userId != null) {
            emit(CubitSuccessState(OMHomeScreen(
              OMId: userId,
            )));
            print(decodedToken);
          } else {
            print('Role ID "nameid" not found for Admin.');
            emit(CubitFailureState('Role ID "nameid" not found for Admin.'));
          }
          break;

        // case "1":
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //   int? adminId = int.tryParse(decodedToken['nameid']?.toString() ?? '');
        //   print('Admin ID: $adminId');

        //   if (adminId != null) {
        //     await prefs.setInt('adminId', adminId);
        //   } else {
        //     emit(CubitFailureState('Invalid admin ID.'));
        //     return;
        //   }
        //   print('Fetching admin details for ID: $adminId');
        //   GetAdmin? admin = await authRepository.fetchAdminDetails(adminId);
        //   if (userId != null) {
        //     emit(CubitSuccessfulState(HomeScreenAdmin(
        //       OMId: userId,
        //       admin: admin!,
        //     )));
        //     print(decodedToken);
        //   } else {
        //     print('Role ID "nameid" not found for Admin.');
        //     emit(CubitFailureState('Role ID "nameid" not found for Admin.'));
        //   }
        //   break;
        case "2":
          if (userId != null) {
            emit(CubitSuccessState(ODHomeScreen(ODId: userId)));
            print(decodedToken);
          } else {
            print('Role ID "nameid" not found for Collaborator.');
            emit(CubitFailureState('Role ID "nameid" not found for Collaborator.'));
          }
          break;
        case "3":
          if (userId != null) {
            emit(CubitSuccessState(OAHomeScreen(OAId: userId)));
            print(decodedToken);
          } else {
            print('Role ID "nameid" not found for Opportunity Analyzer.');
            emit(CubitFailureState('Role ID "nameid" not found for Opportunity Analyzer.'));
          }
          break;
        case "4":
          if (userId != null) {
            emit(CubitSuccessState(OWHomeScreen(OWId: userId)));
            print(decodedToken);
          } else {
            print('Role ID "nameid" not found for Opportunity Owner.');
            emit(CubitFailureState('Role ID "nameid" not found for Opportunity Owner.'));
          }
          break;
        case "5": //sc
          if (userId != null) {
            emit(CubitSuccessState(const SCHomePage()));
            print(decodedToken);
          } else {
            print('Role ID "nameid" not found for Opportunity Owner.');
            emit(CubitFailureState('Role ID "nameid" not found for Opportunity Owner.'));
          }
          break;
        case "6": //sm
          if (userId != null) {
            // emit(CubitSuccessfulState(HomePageSm(SMId: userId)));
            emit(CubitSuccessState(const SMHomePage()));
            print(decodedToken);
          } else {
            print('Role ID "nameid" not found for Opportunity Owner.');
            emit(CubitFailureState('Role ID "nameid" not found for Opportunity Owner.'));
          }
          break;
        default:
          print('Unknown role: $roleType');
          emit(CubitFailureState('Unknown role: $roleType'));
      }
    }
  }
}
