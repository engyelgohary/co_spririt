import 'dart:io';
import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/text_form_field.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:co_spirit/ui/auth/login.dart';
import 'package:co_spirit/core/Cubit/collaborator_cubit.dart';
import 'package:co_spirit/ui/profile/od_edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/api/apimanager.dart';

class ODProfileScreen extends StatefulWidget {
  final String ODId;
  const ODProfileScreen({super.key, required this.ODId});

  @override
  State<ODProfileScreen> createState() => _ODProfileScreenState();
}

class _ODProfileScreenState extends State<ODProfileScreen> {
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
      collaboratorRepository: CollaboratorRepositoryRemote(apiManager: ApiManager.getInstance()),
    );
    viewModel.fetchCollaboratorDetails(int.parse(widget.ODId));
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
          backArrowColor: ODColorScheme.buttonColor,
          textColor: ODColorScheme.mainColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                onPressed: () => showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  constraints: BoxConstraints(maxHeight: height * 0.9),
                  context: context,
                  builder: (context) => Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Icon(Icons.horizontal_rule_rounded),
                      ),
                      Flexible(
                          child: EditProfileOD(
                        collaboratorId: widget.ODId,
                      )),
                    ],
                  ),
                ),
                icon: const Icon(Icons.mode_edit_outline_outlined),
              ),
            ),
          ]),
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<CollaboratorCubit, CollaboratorState>(
          builder: (context, state) {
            if (state is CollaboratorLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: ODColorScheme.buttonColor));
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
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _selectedImage != null
                            ? FileImage(File(_selectedImage!.path))
                            : NetworkImage(
                                'http://${ApiConstants.baseUrl}${collaborator.pictureLocation}',
                              ) as ImageProvider,
                        child: _selectedImage == null && collaborator.pictureLocation == null
                            ? const Icon(Icons.camera_alt, size: 50)
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Text("${firstNameController.text} ${lastNameController.text}",
                          style: const TextStyle(color: ODColorScheme.mainColor, fontSize: 18)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextFormField(
                      fieldName: 'First Name',
                      controller: firstNameController,
                      enabled: false,
                      textColor: ODColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Last Name',
                      controller: lastNameController,
                      enabled: false,
                      textColor: ODColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Email',
                      controller: emailController,
                      enabled: false,
                      textColor: ODColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Phone',
                      controller: phoneController,
                      enabled: false,
                      textColor: ODColorScheme.mainColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: width / 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Notification",
                            style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                          ),
                          Switch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: ODColorScheme.buttonColor,
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
                            style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Change",
                              style: TextStyle(
                                fontSize: 16,
                                color: ODColorScheme.buttonColor,
                                decoration: TextDecoration.underline,
                                decorationColor: ODColorScheme.buttonColor,
                              ),
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
                              CupertinoPageRoute(builder: (context) => LoginScreen()),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: ODColorScheme.buttonColor,
                            shape: RoundedRectangleBorder(
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
