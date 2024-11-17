import 'package:co_spirit/core/Cubit/cubit_state.dart';
import 'package:co_spirit/core/app_ui.dart';
import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/text_form_field.dart';
import 'package:co_spirit/core/constants.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:co_spirit/ui/auth/Cubit/login_model_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;
  bool rememberMe = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  LoginCubit loginCubit = LoginCubit(
    authDataSource: AuthDataSourceRemote(apiManager: ApiManager.getInstance()),
  );
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;

    return BlocListener(
      bloc: loginCubit,
      listener: (context, state) {
        if (state is CubitLoadingState) {
          loadingIndicatorDialog(context);
        } else if (state is CubitFailureState) {
          Navigator.of(context).pop();
          snackBar(context, state.error);
        } else if (state is CubitSuccessState<Widget>) {
          Navigator.of(context).pop();
          snackBar(context, "Sign In Success", duration: 3);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => state.response),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: scColorMap["mainColor"],
        body: Column(
          children: [
            SizedBox(
              height: height * 0.35,
              child: Center(child: SvgPicture.asset("${assetsPaths["sc"]}/logo.svg")),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              height: height * 0.65,
              width: width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: width * 0.06, right: width * 0.06, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 100),
                      Form(
                        key: key,
                        child: Column(
                          children: [
                            AuthTextFormField(
                              fieldName: "Email",
                              controller: loginCubit.emailController,
                              hintText: "email@example.com",
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email address';
                                }
                                bool emailValid = RegExp(emailRegex).hasMatch(value);
                                if (!emailValid) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            AuthTextFormField(
                              fieldName: "Password",
                              controller: loginCubit.passwordController,
                              hintText: "●●●●●●●●",
                              keyboardType: TextInputType.visiblePassword,
                              isObscure: isObscure,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: InkWell(
                                  child: isObscure
                                      ? const Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                        )
                                      : const Icon(
                                          Icons.visibility,
                                          color: Colors.black,
                                        ),
                                  onTap: () => setState(
                                    () => isObscure = !isObscure,
                                  ),
                                ),
                              ),
                              validator: (value) => (value == null || value.trim().isEmpty)
                                  ? 'Please enter password'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.green,
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                              ),
                              const Text(
                                "Remember me",
                                style: TextStyle(color: ODColorScheme.mainColor, fontSize: 15),
                              )
                            ],
                          ),
                          TextButton(
                            onPressed: () => snackBar(context, "Not implemented"),
                            child: const Text(
                              "Forgot Password?",
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

                      const SizedBox(height: 24),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (key.currentState != null && key.currentState!.validate()) {
                                  loginCubit.login();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: scColorMap["buttonColor"],
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Row(children: [
                              Expanded(child: Divider()),
                              Text("    OR    "),
                              Expanded(child: Divider()),
                            ]),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () {
                                if (key.currentState != null && key.currentState!.validate()) {
                                  loginCubit.login();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              child: const Text(
                                'Continue with Google',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                if (key.currentState != null && key.currentState!.validate()) {
                                  loginCubit.login();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              child: const Text(
                                'Continue with Facebook',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
  // double width = AppUtil.responsiveWidth(context);
  // return BlocListener<LoginModelViewCubit, LoginModelViewState>(
  //   bloc: modelView,
  //   listener: (BuildContext context, state) {
  //     if (state is LoginModelViewLoading) {
  //       loadingIndicatorDialog(context); // to fix later
  //     } else if (state is LoginModelViewError) {
  //       Navigator.pop(context);
  //       snackBar(context, state.error);
  //     } else if (state is LoginModelViewSuccess) {
  //       Navigator.pop(context);
  //       snackBar(context, "Sign In Success", duration: 3);
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => state.homeScreen),
  //         (Route<dynamic> route) => false,
  //       );
  //     }
  //   },
  //   child: Scaffold(
  //     body: Center(
  //       child: SingleChildScrollView(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 100),
  //           child: Column(
  //             children: [
  //               Image.asset(
  //                 "assets/images/logo-corelia.png",
  //                 width: 194,
  //                 height: 56,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 26),
  //                 child: Form(
  //                   key: key,
  //                   child: Column(
  //                     children: [
  //                       AuthTextFormField(
  //                         fieldName: 'Email',
  //                         hintText: "email@example.com",
  //                         controller: modelView.emailController,
  //                         validator: (value) {
  //                           if (value == null || value.trim().isEmpty) {
  //                             return 'Please enter your email address';
  //                           }
  //                           bool emailValid = RegExp(emailRegex).hasMatch(value);
  //                           if (!emailValid) {
  //                             return 'Invalid email';
  //                           }
  //                           return null;
  //                         },
  //                       ),
  //                       AuthTextFormField(
  //                         fieldName: 'Password',
  //                         hintText: "●●●●●●●●",
  //                         controller: modelView.passwordController,
  //                         validator: (value) {
  //                           if (value == null || value.trim().isEmpty) {
  //                             return 'Please enter password';
  //                           }
  //                           return null;
  //                         },
  //                         isObscure: modelView.isObscure,
  //                         suffixIcon: Padding(
  //                           padding: const EdgeInsets.only(right: 16),
  //                           child: InkWell(
  //                             child: modelView.isObscure
  //                                 ? const Icon(
  //                                     Icons.visibility_off,
  //                                     color: Colors.black,
  //                                   )
  //                                 : const Icon(
  //                                     Icons.visibility,
  //                                     color: Colors.black,
  //                                   ),
  //                             onTap: () {
  //                               if (modelView.isObscure) {
  //                                 modelView.isObscure = false;
  //                               } else {
  //                                 modelView.isObscure = true;
  //                               }
  //                               setState(() {});
  //                             },
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: width / 11),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Checkbox(
  //                                   activeColor: ODColorScheme.buttonColor,
  //                                   value: rememberMe,
  //                                   onChanged: (value) {
  //                                     setState(() {
  //                                       rememberMe = value ?? false;
  //                                     });
  //                                   },
  //                                 ),
  //                                 const Text(
  //                                   "Remember me",
  //                                   style:
  //                                       TextStyle(color: ODColorScheme.mainColor, fontSize: 15),
  //                                 )
  //                               ],
  //                             ),
  //                             TextButton(
  //                               onPressed: () => snackBar(context, "Not implemented"),
  //                               child: const Text(
  //                                 "Forgot Password?",
  //                                 style: TextStyle(
  //                                   color: ODColorScheme.mainColor,
  //                                   fontSize: 15,
  //                                   decoration: TextDecoration.underline,
  //                                   decorationColor: ODColorScheme.mainColor,
  //                                 ),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 15),
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             if (key.currentState != null && key.currentState!.validate()) {
  //                               modelView.login(context);
  //                             }
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                               padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
  //                               backgroundColor: ODColorScheme.buttonColor,
  //                               shape: const RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.all(Radius.circular(30)))),
  //                           child: const Text(
  //                             'Login',
  //                             style: TextStyle(fontSize: 16, color: Colors.white),
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 15),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             const Text(
  //                               "Don't have an account? ",
  //                               style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
  //                             ),
  //                             InkWell(
  //                               onTap: () => snackBar(context, "Not implemented"),
  //                               child: const Text(
  //                                 "Register",
  //                                 style: TextStyle(
  //                                   color: ODColorScheme.mainColor,
  //                                   fontSize: 15,
  //                                   decoration: TextDecoration.underline,
  //                                   decorationColor: ODColorScheme.mainColor,
  //                                 ),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ),
  // );

