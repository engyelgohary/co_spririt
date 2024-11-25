import 'dart:io';

import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/text_form_field.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/ui/AllUsers.dart';
import 'package:co_spirit/ui/profile/upload_data_om.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:co_spirit/ui/auth/login.dart';

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
            const Center(
              child: CircleAvatar(
                radius: 60,
                child: Icon(Icons.camera_alt, size: 50),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Text("${firstNameController.text} ${lastNameController.text}",
                  style: const TextStyle(color: OMColorScheme.textColor, fontSize: 18)),
            ),
            const SizedBox(
              height: 16,
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
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        constraints: BoxConstraints(
                          minHeight: height * 0.4,
                          maxHeight: height * 0.7,
                        ),
                        context: context,
                        builder: (context) => const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Icon(Icons.horizontal_rule_rounded),
                            ),
                            Flexible(child: UploadDataOM()),
                          ],
                        ),
                      );
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
                    onPressed: () {
                      AppUtil.mainNavigator(context, const AllUsersScreen());
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: OMColorScheme.mainColor,
                    ),
                  )
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: OMColorScheme.mainColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
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