import 'dart:io';
import 'package:co_spirit/data/dip.dart';
import 'package:co_spirit/ui/om/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class Addcollaborator extends StatefulWidget {
  final VoidCallback onOpportunityAdded;

  const Addcollaborator({super.key, required this.onOpportunityAdded});

  @override
  State<Addcollaborator> createState() => _AddcollaboratorState();
}

class _AddcollaboratorState extends State<Addcollaborator> {
  late CollaboratorCubit viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository());
  }

  Widget build(BuildContext context) {
    return BlocConsumer<CollaboratorCubit, CollaboratorState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is CollaboratorLoading) {
          const CircularProgressIndicator();
        } else if (state is CollaboratorError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? ""),
          ));
        } else if (state is CollaboratorSuccess) {
          widget.onOpportunityAdded();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Collabrator Added Successfully"),
          ));
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            height: 600.h,
            margin: const EdgeInsets.all(20),
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
                            child: const Icon(Icons.cameraswitch_outlined,
                                size: 40, color: AppColor.blackColor),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomText(
                    keyboardType: TextInputType.name,
                    fieldName: 'First Name :',
                    controller: viewModel.firstNameController,
                    width: 2.w,
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
                    controller: viewModel.lastNameController,
                    width: 2.w,
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
                    controller: viewModel.phoneController,
                    width: 30.w,
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
                    controller: viewModel.emailController,
                    width: 38.w,
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
                  Text(
                    "Contract Info : ",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 18, fontWeight: FontWeight.w700, color: AppColor.basicColor),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      SizedBox(
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
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 10.0.w),
                            fillColor: AppColor.whiteColor,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColor.borderColor),
                                borderRadius: BorderRadius.circular(5.r)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColor.errorColor),
                                borderRadius: BorderRadius.circular(5.r)),
                            focusedErrorBorder:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                            disabledBorder:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                            focusColor: AppColor.basicColor,
                            hoverColor: AppColor.basicColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        "To",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w700, color: AppColor.basicColor),
                      ),
                      const SizedBox(width: 9),
                      SizedBox(
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
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 10.0.w),
                            fillColor: AppColor.whiteColor,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColor.borderColor),
                                borderRadius: BorderRadius.circular(5.r)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColor.errorColor),
                                borderRadius: BorderRadius.circular(5.r)),
                            focusedErrorBorder:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                            disabledBorder:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
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
                            fontSize: 18, fontWeight: FontWeight.w700, color: AppColor.basicColor),
                      ),
                      SizedBox(width: 150.w),
                      SizedBox(
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
                                      .copyWith(fontSize: 16, color: AppColor.whiteColor))),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.buttonColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.r)))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
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
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontSize: 16,
                                      color: AppColor.thirdColor,
                                      fontWeight: FontWeight.w400))),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.greyColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.r)))),
                        ),
                      ),
                      SizedBox(
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
                                      .copyWith(fontSize: 16, color: AppColor.whiteColor))),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.buttonColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.r)))),
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
