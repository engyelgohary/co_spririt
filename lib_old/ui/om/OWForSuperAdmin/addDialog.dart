import 'dart:io';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/components/textFormField.dart';
import 'Cubit/OW_cubit.dart'; // Make sure to create the corresponding OW_cubit.dart file

class AddOW extends StatefulWidget {
  final VoidCallback onOpportunityAdded;

  const AddOW({super.key, required this.onOpportunityAdded});

  @override
  _AddOWState createState() => _AddOWState();
}

class _AddOWState extends State<AddOW> {
  late OpportunityOwnerCubit viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = BlocProvider.of<OpportunityOwnerCubit>(context);

    return BlocConsumer<OpportunityOwnerCubit, OpportunityOwnerState>(
      listener: (context, state) {
        if (state is OpportunityOwnerLoading) {
          const CircularProgressIndicator();
        } else if (state is OpportunityOwnerError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? ""),
          ));
        } else if (state is OpportunityOwnerSuccess) {
          widget.onOpportunityAdded();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opportunity Owner submitted successfully')),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            height: 600,
            width: 369,
            margin: const EdgeInsets.all(15),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: viewModel.selectImage,
                    child: BlocBuilder<OpportunityOwnerCubit, OpportunityOwnerState>(
                      builder: (context, state) {
                        if (state is OpportunityOwnerImageSelected) {
                          return Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(File(state.image.path)),
                            ),
                          );
                        }
                        return Center(
                          child: CircleAvatar(
                            radius: 60,
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColor.basicColor,
                            ),
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppColor.basicColor,
                            ),
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppColor.basicColor,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 35,
                        width: 135,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 16,
                                    color: AppColor.thirdColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.greyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.r)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                        width: 135,
                        child: ElevatedButton(
                          onPressed: () {
                            if (viewModel.formKey.currentState!.validate()) {
                              viewModel.addOW();
                            }
                          },
                          child: Center(
                            child: Text(
                              'Add',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 16,
                                    color: AppColor.whiteColor,
                                  ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.r)),
                            ),
                          ),
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
