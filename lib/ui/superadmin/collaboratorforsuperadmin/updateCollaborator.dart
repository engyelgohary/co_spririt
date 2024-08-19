import 'dart:io';

import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:co_spririt/ui/superadmin/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class Updatecollaborator extends StatefulWidget {
  final Collaborator collaborator;
   Updatecollaborator({super.key,required this.collaborator});

  @override
  State<Updatecollaborator> createState() => _UpdatecollaboratorState();
}

class _UpdatecollaboratorState extends State<Updatecollaborator> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController contractStartController;
  late TextEditingController contractEndController;
  XFile? selectedImage;
  File? cv;

  @override
  void initState() {
    super.initState();
    DateTime contractStartDate = DateTime.parse(widget.collaborator.contractStart ?? "");
    DateTime contractEndDate = DateTime.parse(widget.collaborator.contractEnd ?? "");
    String formattedDateStart = DateFormat('yyyy-MM-dd').format(contractStartDate);
    String formattedDateEnd = DateFormat('yyyy-MM-dd').format(contractEndDate);
    firstNameController = TextEditingController(text: widget.collaborator.firstName);
    lastNameController = TextEditingController(text: widget.collaborator.lastName);
    phoneController = TextEditingController(text: widget.collaborator.phone);
    emailController = TextEditingController(text: widget.collaborator.email);
    contractStartController = TextEditingController(text: formattedDateStart);
    contractEndController = TextEditingController(text: formattedDateEnd);
  }
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = pickedImage;
    });
  }
  void selectCv() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      cv = File(result.files.single.path!);
    }
  }
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    contractStartController.dispose();
    contractEndController.dispose();
    super.dispose();
  }

  void updateCollaborator(){
    context.read<CollaboratorCubit>().updateCollaborator({
      'id':widget.collaborator.id,
      'firstName': firstNameController.text,
      'lastName':lastNameController.text,
      'phone': phoneController.text,
      'email':emailController.text,
      'ContractStart':contractStartController.text,
      'ContractEnd':contractEndController.text,
    }
        ,selectedImage, cv);
  }
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          height: 600.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundImage: selectedImage != null
                        ? FileImage(File(selectedImage!.path))
                        : widget.collaborator.pictureLocation != null
                        ? NetworkImage('http://10.10.99.13:3090${widget.collaborator.pictureLocation}')
                        : AssetImage('assets/placeholder.png') as ImageProvider,
                    child: selectedImage == null && widget.collaborator.pictureLocation == null
                        ? Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
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
                      controller: contractStartController,
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
                      controller: contractEndController,
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
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Cv :",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColor.basicColor),
                  ),
                  SizedBox(width: 154.w),
                  Container(
                    height: 35.h,
                    width: 135.w,
                    child: ElevatedButton(
                      onPressed: () {
                        selectCv();
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
                              borderRadius: BorderRadius.all(Radius.circular(5.r)))),
                    ),
                  ),
                  Container(
                    height: 35.h,
                    width: 135.w,
                    child: ElevatedButton(
                      onPressed: () {
                        updateCollaborator();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Collaborator Update Successfully"),
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
        ),
      ),
    );
  }
}
