import 'package:co_spririt/ui/auth/Cubit/login_model_view_cubit.dart';
import 'package:co_spririt/utils/components/textFormField.dart';
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_util.dart';
import '../../data/dip.dart';
import '../../utils/helper_functions.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginModelViewCubit modelView = LoginModelViewCubit(authRepository: injectAuthRepository());
  bool RememberMe = false;
  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return BlocListener<LoginModelViewCubit, LoginModelViewState>(
      bloc: modelView,
      listener: (BuildContext context, state) {
        if (state is LoginModelViewLoading) {
          loadingIndicatorDialog(context);
        } else if (state is LoginModelViewError) {
          Navigator.pop(context);
          snackBar(context, state.error);
        } else if (state is LoginModelViewSuccess) {
          Navigator.pop(context);
          snackBar(context, "Sign In Success", duration: 3);
          final signalr = Signalr();
          signalr.start();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => state.homeScreen),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo-corelia.png",
                    width: 194.w,
                    height: 56.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 26.h),
                    child: Form(
                      key: modelView.formKey,
                      child: Column(
                        children: [
                          AuthTextFormField(
                            fieldName: 'Email',
                            hintText: "email@example.com",
                            controller: modelView.emailController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email address';
                              }
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);
                              if (!emailValid) {
                                return 'Invalid email';
                              }
                              return null;
                            },
                          ),
                          AuthTextFormField(
                            fieldName: 'Password',
                            hintText: "●●●●●●●●",
                            controller: modelView.passwordController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            isObscure: modelView.isObscure,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: InkWell(
                                child: modelView.isObscure
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.black,
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                        color: Colors.black,
                                      ),
                                onTap: () {
                                  if (modelView.isObscure) {
                                    modelView.isObscure = false;
                                  } else {
                                    modelView.isObscure = true;
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 11),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      activeColor: ODColorScheme.buttonColor,
                                      value: RememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          RememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                    const Text(
                                      "Remember me",
                                      style:
                                          TextStyle(color: ODColorScheme.mainColor, fontSize: 15),
                                    )
                                  ],
                                ),
                                TextButton(
                                  onPressed: () => snackBar(context, "Not implemented"),
                                  child: const Text(
                                    "Forgot Password  ?",
                                    style: TextStyle(
                                      color: ODColorScheme.mainColor,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      decorationColor: ODColorScheme.mainColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: ElevatedButton(
                              onPressed: () {
                                modelView.login(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 45.w, vertical: 16.h),
                                  backgroundColor: ODColorScheme.buttonColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(30.r)))),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                                ),
                                InkWell(
                                  onTap: () => snackBar(context, "Not implemented"),
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                      color: ODColorScheme.mainColor,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      decorationColor: ODColorScheme.mainColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
