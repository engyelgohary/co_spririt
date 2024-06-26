import 'package:bloc/bloc.dart';
import 'package:co_spririt/ui/collaborator/home/home_colla.dart';
import 'package:co_spririt/ui/superadmin/home/home_superadmin.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../../core/app_util.dart';
import '../../admin/home/home_admin.dart';
part 'login_model_view_state.dart';

class LoginModelViewCubit extends Cubit<LoginModelViewState> {
  LoginModelViewCubit() : super(LoginModelViewInitial());
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  bool isObscure = true;
  void login(BuildContext context){
    // if (formKey.currentState!.validate() == true){
      //SuperAdmin
       AppUtil.mainNavigator(context, HomeScreenSuperAdmin());
      //Admin
      // AppUtil.mainNavigator(context, HomeScreenAdmin());
      //Collaborator
      //AppUtil.mainNavigator(context, HomeScreenColla());

    // }
  }
}
