import 'package:co_spririt/ui/auth/Cubit/login_model_view_cubit.dart';
import 'package:co_spririt/utils/components/textFormField.dart';
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/dip.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginModelViewCubit modelView = LoginModelViewCubit(authRepository: injectAuthRepository());
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginModelViewCubit,LoginModelViewState>(
      bloc: modelView,
      listener: (BuildContext context, state) {
        if (state is LoginModelViewLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator(color: AppColor.secondColor,));
            },
          );
        } else if (state is LoginModelViewError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
          ));
        } else if (state is LoginModelViewSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Sign IN Success"),
            duration: Duration(seconds: 3),
          ));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => state.homeScreen),
                (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 252.h, left: 84.w, right: 82.w),
                child: Image.asset(
                  "assets/images/logo-corelia.png",
                  width: 194.w,
                  height: 56.h,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 26.h),
                child: Form(
                  key: modelView.formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        fieldName: 'Email',
                        controller: modelView.emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'please enter your email address';
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            return 'invalid email';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        fieldName: 'Password',
                        controller: modelView.passwordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'please enter password';
                          }
                          return null;
                        },
                        isObscure: modelView.isObscure,
                        suffixIcon: InkWell(
                          child: modelView.isObscure
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: AppColor.basicColor,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: AppColor.basicColor,
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
                      Padding(
                        padding:
                            EdgeInsets.only(top: 15.h, right: 100.w, left: 100.w),
                        child: ElevatedButton(
                          onPressed: () {
                            modelView.login(context);

                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.secondColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.r)))),
                          child: SizedBox(
                            height:35.h,
                            width: 135.w,
                            child: Center(
                              child: Text('Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
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
    );
  }
}
