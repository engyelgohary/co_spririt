import 'package:bloc/bloc.dart';
import 'package:co_spirit/core/Cubit/cubit_state.dart';
import 'package:co_spirit/data/repository/data_source.dart';
import 'package:co_spirit/edited_ui/home/oa_home.dart';
import 'package:co_spirit/edited_ui/home/od_home.dart';
import 'package:co_spirit/ui/home/om_home.dart';
import 'package:co_spirit/ui/home/ow_home.dart';
import 'package:co_spirit/ui/home/sc_home.dart';
import 'package:co_spirit/ui/home/sm_home.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/edited_api/auth_apis.dart';
part 'login_model_view_state.dart';

class LoginCubit extends Cubit<CubitState> {
  final AuthApi authApi;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;

  LoginCubit({required this.authApi}) : super(CubitInitialState());

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      emit(CubitFailureState("Email and password must not be empty."));
      return;
    }

    emit(CubitLoadingState());

    try {
      final response = await authApi.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response == null || !response.succeeded) {
        emit(CubitFailureState(response?.message ?? "Login failed."));
        return;
      }

      final authData = response.data;

      // Save token and refresh token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", authData.token);
      await prefs.setString("refreshToken", authData.refreshToken);

      // Extract role directly from the AuthApiResponse
      final roleName = authData.role;

      if (roleName == null || roleName.isEmpty) {
        emit(CubitFailureState("Role not found in the response."));
        return;
      }

      // Navigate based on the role name
      _navigateByRole(roleName);
    } catch (e) {
      emit(CubitFailureState("An error occurred: ${e.toString()}"));
    }
  }

  void _navigateByRole(String roleName) {
    switch (roleName) {
      case "Opportunity Analyzer":
       print("OA Logged in");
        break;
      case "Opportunity Owner":
        print("OW Logged in");
        break;
      case "Opportunity Detector":
        emit(CubitSuccessState(ODHomeScreen()));
        break;
      case "Solution Contributor":
        print("SC Logged in");
        break;
      case "Opportunity Manager":
        print("OM Logged in");
        break;
      case "Solution Manager":
        print("SM Logged in");
        break;
      default:
        emit(CubitFailureState("Unknown role: $roleName"));
    }
  }
}

