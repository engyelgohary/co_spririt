import 'dart:io';
import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/ui/superadmin/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class Addcollaborator extends StatefulWidget {
  const Addcollaborator({super.key});

  @override
  State<Addcollaborator> createState() => _AddcollaboratorState();
}

class _AddcollaboratorState extends State<Addcollaborator> {
  late CollaboratorCubit viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = CollaboratorCubit(
        collaboratorRepository: injectCollaboratorRepository());
  }

  Widget build(BuildContext context) {
    return BlocListener<CollaboratorCubit, CollaboratorState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is CollaboratorLoading) {
          CircularProgressIndicator();
        } else if (state is CollaboratorError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? ""),
          ));
        } else if (state is CollaboratorSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Collabrator Added Successfully"),
          ));
        }
      },
      child: SingleChildScrollView(
        child: Container(
          height: 500.h,
          margin: EdgeInsets.all(20),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: viewModel.selectImage,
                  child: BlocBuilder<CollaboratorCubit, CollaboratorState>(
                    bloc: viewModel,
                    builder: (context, state) {
                      if (state is CollaboratorImageSelected) {
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
                          child: Icon(Icons.cameraswitch_outlined,
                              size: 40, color: AppColor.blackColor),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                CustomText(
                  keyboardType: TextInputType.name,
                  fieldName: 'First Name :',
                  controller: viewModel.firstNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 11),
                CustomText(
                  fieldName: 'Last Name :',
                  controller: viewModel.lastNameController,
                  width: 7,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 11),
                CustomText(
                  fieldName: 'Mobile :',
                  controller: viewModel.phoneController,
                  width: 35,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 11),
                CustomText(
                  fieldName: 'Email :',
                  controller: viewModel.emailController,
                  width: 44,
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
                SizedBox(height: 11),
                Text(
                  "Contract Info : ",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColor.basicColor),
                ),
                SizedBox(height: 11),
                Row(
                  children: [
                    Container(
                      height: 32.h,
                      width: 140.w,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: viewModel.contractStartController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your Date';
                          }
                          return null;
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 4.0.h, horizontal: 10.0.w),
                          fillColor: AppColor.whiteColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.borderColor),
                              borderRadius: BorderRadius.circular(5.r)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.errorColor),
                              borderRadius: BorderRadius.circular(5.r)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                          focusColor: AppColor.basicColor,
                          hoverColor: AppColor.basicColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 9),
                    Text(
                      "To",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColor.basicColor),
                    ),
                    SizedBox(width: 9),
                    Container(
                      height: 32.h,
                      width: 140.w,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: viewModel.contractEndController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your Date';
                          }
                          return null;
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 4.0.h, horizontal: 10.0.w),
                          fillColor: AppColor.whiteColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.borderColor),
                              borderRadius: BorderRadius.circular(5.r)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.errorColor),
                              borderRadius: BorderRadius.circular(5.r)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                          focusColor: AppColor.basicColor,
                          hoverColor: AppColor.basicColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      "Cv :",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColor.basicColor),
                    ),
                    SizedBox(width: 150.w),
                    Container(
                      height: 35.h,
                      width: 135.w,
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.selectCv();
                        },
                        child: Center(
                            child: Text('Upload',
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
                SizedBox(height: 25),
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
                          viewModel.addCollaborator();
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
      ),
    );
  }
}
