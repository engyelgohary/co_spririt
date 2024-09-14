import 'dart:io';
import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/ui/superadmin/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class ProfileScreenColla extends StatefulWidget {
  final String collaboratorId;
  const ProfileScreenColla({super.key, required this.collaboratorId});

  @override
  State<ProfileScreenColla> createState() => _ProfileScreenCollaState();
}

class _ProfileScreenCollaState extends State<ProfileScreenColla> {
  late CollaboratorCubit viewModel;
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
    viewModel = CollaboratorCubit(
      collaboratorRepository: injectCollaboratorRepository(),
    );
    viewModel.fetchCollaboratorDetails(int.parse(widget.collaboratorId));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: const AppBarCustom(),
      ),
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<CollaboratorCubit, CollaboratorState>(
          builder: (context, state) {
            if (state is CollaboratorLoading) {
              return const Center(child: const CircularProgressIndicator());
            } else if (state is CollaboratorSuccess) {
              final collaborator = state.collaboratorData;
              firstNameController.text = "${collaborator!.firstName}";
              lastNameController.text = collaborator.lastName ?? "";
              phoneController.text = collaborator.phone ?? "";
              emailController.text = collaborator.email ?? "";
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
                                      'http://${ApiConstants.baseUrl}${collaborator.pictureLocation}')
                                  as ImageProvider,
                          child: _selectedImage == null && collaborator.pictureLocation == null
                              ? const Icon(Icons.camera_alt, size: 50)
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Center(
                      child: Text(
                        "${firstNameController.text} ${lastNameController.text}",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Collaborator',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),
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
                            context.read<CollaboratorCubit>().updateCollaborator({
                              'id': widget.collaboratorId,
                              'firstName': firstNameController.text,
                              'lastName': lastNameController.text,
                              'phone': phoneController.text,
                              'email': emailController.text,
                              "ContractStart": state.collaboratorData!.contractStart,
                              "ContractEnd": state.collaboratorData!.contractEnd,
                            }, _selectedImage, cv);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Profile Update Successfully"),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.buttonColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.r)))),
                          child: Center(
                              child: Text('Update',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 16, color: AppColor.whiteColor))),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is CollaboratorError) {
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
