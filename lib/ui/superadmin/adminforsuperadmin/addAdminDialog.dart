import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/dip.dart';
import '../../../../utils/components/textFormField.dart';
import 'Cubit/add_admin_cubit.dart';

class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  AddAdminCubit viewModel =
      AddAdminCubit(authRepository: injectAuthRepository());

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: viewModel,
        listener: (context, state) {
          if (state is AddAdminLoading) {
            CircularProgressIndicator();
          } else if (state is AddAdminError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage ?? ""),
            ));
            print(state.errorMessage);
          } else if (state is AddAdminSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text(state.adminUser!.firstName ?? "Admin Added Successful"),
            ));
          }
        },
        child: Container(
          height: 482.h,
          width: 369.w,
          margin: EdgeInsets.all(20),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColor.disableColor,
                  child: Icon(Icons.cameraswitch_outlined,
                      size: 40, color: AppColor.blackColor),
                ),
                SizedBox(height: 20),
                CustomText(
                  keyboardType: TextInputType.name,
                  fieldName: 'First Name :',
                  controller: viewModel.firstName_controller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'please enter your First name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 11),
                CustomText(
                  fieldName: 'Last Name :',
                  controller: viewModel.lastName_controller,
                  width: 7,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 11),
                CustomText(
                  fieldName: 'Mobile :',
                  controller: viewModel.phone_controller,
                  width: 35,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'please enter your Mobile Number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 11),
                CustomText(
                  fieldName: 'Email :',
                  controller: viewModel.email_controller,
                  width: 44,
                  keyboardType: TextInputType.emailAddress,
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
                SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Can Post :',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColor.basicColor)),
                    SizedBox(width: 65.w),
                    Radio<bool>(
                      value: false,
                      groupValue: viewModel.canPost,
                      onChanged: (value) {
                        setState(() {
                          viewModel.canPost = value!;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text('NO',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColor.basicColor)),
                    SizedBox(width: 24.w),
                    Radio<bool>(
                      value: true,
                      groupValue: viewModel.canPost,
                      onChanged: (value) {
                        setState(() {
                          viewModel.canPost = value!;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text('Yes',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColor.basicColor)),
                  ],
                ),
                SizedBox(height: 26.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 35.h,
                      width: 135.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Center(
                            child: Text('Cancel',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontSize: 16,
                                        color: AppColor.thirdColor,
                                        fontWeight: FontWeight.w400))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.greyColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.r)))),
                      ),
                    ),
                    Container(
                      height: 35.h,
                      width: 135.w,
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.register();
                        },
                        child: Center(
                            child: Text('Add',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontSize: 16,
                                        color: AppColor.whiteColor))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.buttonColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.r)))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
