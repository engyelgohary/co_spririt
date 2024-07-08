import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/model/GetAdmin.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';
import 'Cubit/admin_cubit.dart';

class UpdateAdminDialog extends StatefulWidget {
  final GetAdmin admin;
  UpdateAdminDialog({required this.admin});

  @override
  _UpdateAdminDialogState createState() => _UpdateAdminDialogState();
}

class _UpdateAdminDialogState extends State<UpdateAdminDialog> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  bool canPost = false;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.admin.firstName);
    lastNameController = TextEditingController(text: widget.admin.lastName);
    phoneController = TextEditingController(text: widget.admin.phone);
    emailController = TextEditingController(text: widget.admin.email);
    canPost = widget.admin.canPost ?? false;
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void updateAdmin() {
    context.read<AdminCubit>().updateAdmin({
      'id': widget.admin.id,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'password': "AdminAdmin",
      'canPost': canPost.toString(),
    }, _selectedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 60.r,
              backgroundImage: _selectedImage != null
                  ? FileImage(File(_selectedImage!.path))
                  : widget.admin.pictureLocation != null
                  ? NetworkImage('http://10.10.99.13:3090${widget.admin.pictureLocation}')
                  : AssetImage('assets/placeholder.png') as ImageProvider,
              child: _selectedImage == null && widget.admin.pictureLocation == null
                  ? Icon(Icons.camera_alt, size: 50)
                  : null,
            ),
          ),
          SizedBox(height: 20),
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
          SizedBox(height: 11),
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
          SizedBox(height: 11),
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
          SizedBox(height: 11),
          CustomText(
            fieldName: 'Email :',
            controller: emailController,
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
                groupValue: canPost,
                onChanged: (value) {
                  setState(() {
                    canPost = value!;
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
                groupValue: canPost,
                onChanged: (value) {
                  setState(() {
                    canPost = value!;
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
          SizedBox(height: 20),
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
                          borderRadius: BorderRadius.all(Radius.circular(5.r)))),
                ),
              ),
              Container(
                height: 35.h,
                width: 135.w,
                child: ElevatedButton(
                  onPressed: () {
                    updateAdmin();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Admin Update Successfully"),
                    ));
                  },
                  child: Center(
                      child: Text('Update',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                              fontSize: 16,
                              color: AppColor.whiteColor))),
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
    );
  }
}
