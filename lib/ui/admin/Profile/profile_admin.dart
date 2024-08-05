import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/dip.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';
import '../../superadmin/adminforsuperadmin/Cubit/admin_cubit.dart';

class ProfileScreenAdmin extends StatefulWidget {
  final String adminId;
  ProfileScreenAdmin({super.key, required this.adminId});

  @override
  State<ProfileScreenAdmin> createState() => _ProfileScreenAdminState();
}

class _ProfileScreenAdminState extends State<ProfileScreenAdmin> {
  late AdminCubit viewModel;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  XFile? _selectedImage;
  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    viewModel = AdminCubit(adminRepository: injectAdminRepository());
    viewModel.fetchAdminDetails(int.parse(widget.adminId));
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
      ),
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AdminSuccess) {
              final admin = state.adminData;
              firstNameController.text = "${admin!.firstName}";
              lastNameController.text = admin.lastName ?? "";
              phoneController.text = admin.phone ?? "";
              emailController.text = admin.email ?? "";
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 60.r,
                          backgroundImage: _selectedImage != null
                              ? FileImage(File(_selectedImage!.path))
                              : NetworkImage(
                                      'http://10.10.99.13:3090${admin.pictureLocation}')
                                  as ImageProvider,
                          child: _selectedImage == null &&
                                  admin.pictureLocation == null
                              ? Icon(Icons.camera_alt, size: 50)
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h,),
                    Center(
                      child: Text(
                        "${firstNameController.text} ${lastNameController.text}",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 15),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Admin',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 15),
                      ),
                    ),
                    CustomTextFormField(
                      fieldName: 'First Name',
                      controller: firstNameController,
                    ),
                    CustomTextFormField(
                      fieldName: 'Last Name',
                      controller: lastNameController,
                    ),
                    CustomTextFormField(
                      fieldName: 'Email',
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'please enter your email address';
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'invalid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      fieldName: 'Phone',
                      controller: phoneController,
                    ),
                    Center(
                      child: Container(
                        height: 35.h,
                        width: 135.w,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AdminCubit>().updateAdmin({
                              'id': widget.adminId,
                              'firstName': firstNameController.text,
                              'lastName': lastNameController.text,
                              'phone': phoneController.text,
                              'email': emailController.text,
                              'password': "AdminAdmin",
                              'canPost': state.adminData!.canPost.toString(),
                            }, _selectedImage);
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.r)))),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is AdminError) {
              return Center(child: Text(state.errorMessage ?? ""));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
