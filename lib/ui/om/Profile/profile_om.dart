import 'dart:io';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';
import '../../auth/login.dart';
import 'edit_profile_om.dart';

class ProfileScreenOM extends StatefulWidget {
  const ProfileScreenOM({super.key});

  @override
  State<ProfileScreenOM> createState() => _ProfileScreenOMState();
}

class _ProfileScreenOMState extends State<ProfileScreenOM> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  XFile? _selectedImage;
  File? cv;
  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    firstNameController.text = "Super";
    lastNameController.text = "Admin";
    phoneController.text = "N/A";
    emailController.text = "N/A";
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: customAppBar(
        title: "Profile",
        context: context,
        backArrowColor: OMColorScheme.mainColor,
        textColor: OMColorScheme.textColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60.r,
                backgroundImage: _selectedImage != null
                    ? FileImage(File(_selectedImage!.path))
                    : const NetworkImage('http://${ApiConstants.baseUrl}') as ImageProvider,
                child: _selectedImage == null ? const Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Center(
              child: Text("${firstNameController.text} ${lastNameController.text}",
                  style: const TextStyle(color: OMColorScheme.textColor, fontSize: 18)),
            ),
            SizedBox(
              height: 16.h,
            ),
            CustomTextFormField(
              fieldName: 'First Name',
              controller: firstNameController,
              enabled: false,
              textColor: OMColorScheme.textColor,
            ),
            CustomTextFormField(
              fieldName: 'Last Name',
              controller: lastNameController,
              enabled: false,
              textColor: OMColorScheme.textColor,
            ),
            CustomTextFormField(
              fieldName: 'Email',
              controller: emailController,
              enabled: false,
              textColor: OMColorScheme.textColor,
            ),
            CustomTextFormField(
              fieldName: 'Phone',
              controller: phoneController,
              enabled: false,
              textColor: OMColorScheme.textColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: width / 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notification",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.textColor),
                  ),
                  Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: OMColorScheme.mainColor,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: width / 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.textColor),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Change",
                      style: TextStyle(
                        fontSize: 16,
                        color: OMColorScheme.mainColor,
                        decoration: TextDecoration.underline,
                        decorationColor: OMColorScheme.buttonColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: width / 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Import Data",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.textColor),
                  ),
                  IconButton(
                    onPressed: () async {
                      final path = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ["csv"],
                      );
                      if (path != null) {
                        uploadCsvFile(context, ApiManager.getInstance(), path.paths[0]!);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: OMColorScheme.mainColor,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: width / 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Users",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.textColor),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: OMColorScheme.mainColor,
                      ))
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: width / 13),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: OMColorScheme.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.r),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Log Out',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 16, color: AppColor.whiteColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
