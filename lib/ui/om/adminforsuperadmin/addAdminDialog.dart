import 'dart:io';
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../data/dip.dart';
import '../../../../utils/components/textFormField.dart';
import 'Cubit/admin_cubit.dart';

class AddAdmin extends StatefulWidget {
  final VoidCallback onOpportunityAdded;
const AddAdmin({super.key, required this.onOpportunityAdded});
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  late AdminCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AdminCubit(adminRepository: injectAdminRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is AdminLoading) {
          const CircularProgressIndicator();
        } else if (state is AdminError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage??""),
          ));
        }  else if (state is AdminSuccess) {
          widget.onOpportunityAdded(); // Call the callback
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin submitted successfully')));
        }
      },
      builder: (context, state) {
        return  SingleChildScrollView(
          child: Container(
            height: 600.h,
            width: 369.w,
            margin: const EdgeInsets.all(15),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: viewModel.selectImage,
                    child: BlocBuilder<AdminCubit, AdminState>(
                      bloc: viewModel,
                      builder: (context, state) {
                        if (state is AdminImageSelected) {
                          return Center(
                            child: CircleAvatar(
                              radius: 60.r,
                              backgroundImage: FileImage(File(state.image.path)),
                            ),
                          );
                        }
                        return Center(
                          child: CircleAvatar(
                            radius: 60.r,
                            backgroundColor: AppColor.disableColor,
                            child: const Icon(Icons.cameraswitch_outlined, size: 40, color: AppColor.blackColor),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomText(
                    keyboardType: TextInputType.name,
                    fieldName: 'First Name :',
                    controller: viewModel.firstName_controller,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 11.h),
                  CustomText(
                    fieldName: 'Last Name :',
                    controller: viewModel.lastName_controller,
                    width: 7.w,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 11.h),
                  CustomText(
                    fieldName: 'Mobile :',
                    controller: viewModel.phone_controller,
                    width: 35.w,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 11.h),
                  CustomText(
                    fieldName: 'Email :',
                    controller: viewModel.email_controller,
                    width: 45.w,
                    keyboardType: TextInputType.emailAddress,
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
                  SizedBox(height: 11.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Can Post :',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: AppColor.basicColor),
                      ),
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
                      Text(
                        'NO',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 18, fontWeight: FontWeight.w400, color: AppColor.basicColor),
                      ),
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
                      Text(
                        'Yes',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 18, fontWeight: FontWeight.w400, color: AppColor.basicColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
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
                     SizedBox(
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
          ),
        );
      },
    );
  }
}
