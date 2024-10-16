import 'package:co_spirit/data/model/Client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';
import 'Cubit/client_cubit.dart';

class UpdateClient extends StatefulWidget {
  Client client;

  UpdateClient({super.key, required this.client});

  @override
  State<UpdateClient> createState() => _UpdateClientState();
}

class _UpdateClientState extends State<UpdateClient> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.client.firstName);
    lastNameController = TextEditingController(text: widget.client.lastName);
    phoneController = TextEditingController(text: widget.client.contactNumber);
    emailController = TextEditingController(text: widget.client.email);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void updateClient() {
    context.read<ClientCubit>().updateClient(
          widget.client.id ?? 1,
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          phoneController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 450,
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomText(
                keyboardType: TextInputType.name,
                fieldName: 'First Name :',
                controller: firstNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 11),
              CustomText(
                fieldName: 'Last Name :',
                controller: lastNameController,
                width: 7,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 11),
              CustomText(
                fieldName: 'Mobile :',
                controller: phoneController,
                width: 35,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 11),
              CustomText(
                fieldName: 'Email :',
                controller: emailController,
                width: 44,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email address';
                  }
                  bool emailValid =
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                  if (!emailValid) {
                    return 'Invalid email';
                  }
                  return null;
                },
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
                    height: 35,
                    width: 135,
                    child: ElevatedButton(
                      onPressed: () {
                        updateClient();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Client Update Successfully"),
                        ));
                      },
                      child: Center(
                          child: Text('Update',
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
  }
}
