import 'package:bloc/bloc.dart';
import 'package:co_spririt/data/repository/repoContract.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:co_spririt/ui/collaborator/home/home_colla.dart';
import 'package:co_spririt/ui/superadmin/home/home_superadmin.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../../core/app_util.dart';
import '../../admin/home/home_admin.dart';
part 'login_model_view_state.dart';


class LoginModelViewCubit extends Cubit<LoginModelViewState> {
  LoginModelViewCubit({required this.authRepository}) : super(LoginModelViewInitial());
  AuthRepository authRepository;
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController(text: "AdminAdmin");
  var emailController = TextEditingController(text: "Admin@admin.com");
  bool isObscure = true;
  void login(BuildContext context) async {
    if (formKey.currentState!.validate() == true) {
      emit(LoginModelViewLoading());

      String? token = await authRepository.login(email: emailController.text, password: passwordController.text);

      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print(decodedToken);
        if (decodedToken.containsKey('Type')|| decodedToken.containsKey('type')) {
          String roleType = (decodedToken['Type'] ?? decodedToken['type']);
          switch (roleType) {
            case "0":
              emit(LoginModelViewSuccess(HomeScreenSuperAdmin()));
              break;
            case "1":
              emit(LoginModelViewSuccess(HomeScreenAdmin()));
              break;
            case "2":
              emit(LoginModelViewSuccess(HomeScreenColla()));
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
