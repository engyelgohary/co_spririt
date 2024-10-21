import 'dart:io';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/components/textFormField.dart';
import 'Cubit/OA_cubit.dart';

class AddOA extends StatefulWidget {
  final VoidCallback onOpportunityAdded;

  const AddOA({super.key, required this.onOpportunityAdded});

  @override
  _AddOAState createState() => _AddOAState();
}

class _AddOAState extends State<AddOA> {
  late OpportunityAnalyzerCubit viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = BlocProvider.of<OpportunityAnalyzerCubit>(context);

    return BlocConsumer<OpportunityAnalyzerCubit, OpportunityAnalyzerState>(
      listener: (context, state) {
        if (state is OpportunityAnalyzerLoading) {
          const CircularProgressIndicator();
        } else if (state is OpportunityAnalyzerError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? ""),
          ));
        } else if (state is OpportunityAnalyzerSuccess) {
          widget.onOpportunityAdded();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Admin submitted successfully')),
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
                    child: BlocBuilder<OpportunityAnalyzerCubit, OpportunityAnalyzerState>(
                      builder: (context, state) {
                        if (state is OpportunityAnalyzerImageSelected) {
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
                  SizedBox(height: 20),
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
                  SizedBox(height: 11),
                  CustomText(
                    fieldName: 'Last Name :',
                    controller: viewModel.lastName_controller,
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
                    controller: viewModel.phone_controller,
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
                    controller: viewModel.email_controller,
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
                      SizedBox(width: 65),
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
                      SizedBox(width: 24),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.greyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
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
                        ),
                      ),
                      SizedBox(
                        height: 35,
                        width: 135,
                        child: ElevatedButton(
                          onPressed: () {
                            if (viewModel.formKey.currentState!.validate()) {
                              viewModel.addOA(); // Call the addOA method to submit the form
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Add',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 16,
                                    color: AppColor.whiteColor,
                                  ),
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
