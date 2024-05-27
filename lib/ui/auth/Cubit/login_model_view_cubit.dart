import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../superadmin/Notifactions/notifictions_superadmin.dart';

part 'login_model_view_state.dart';

class LoginModelViewCubit extends Cubit<LoginModelViewState> {
  LoginModelViewCubit() : super(LoginModelViewInitial());
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  bool isObscure = true;
  void login(BuildContext context){
    if (formKey.currentState!.validate() == true){
      Navigator.pushNamed(context, NotifactionScreenSuperAdmin.routName);
    }
  }
}
