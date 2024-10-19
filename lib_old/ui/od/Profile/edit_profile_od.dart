import 'dart:io';
import 'package:co_spirit/data/dip.dart';
import 'package:co_spirit/ui/om/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class EditProfileOD extends StatefulWidget {
  final String collaboratorId;
  const EditProfileOD({super.key, required this.collaboratorId});

  @override
  State<EditProfileOD> createState() => _EditProfileODState();
}

class _EditProfileODState extends State<EditProfileOD> {
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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<CollaboratorCubit, CollaboratorState>(
          builder: (context, state) {
            if (state is CollaboratorLoading) {
              return const Center(
                child: CircularProgressIndicator(color: ODColorScheme.buttonColor),
              );
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
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: ODColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Last Name',
                      controller: lastNameController,
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: ODColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Email',
                      controller: emailController,
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: ODColorScheme.mainColor,
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
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: ODColorScheme.mainColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 15, vertical: 32),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: ODColorScheme.disabledColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 16, color: AppColor.whiteColor),
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed: () async {
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
                                  content: Text("Profile Updated Successfully"),
                                ));
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
                                  'Update',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 16, color: AppColor.whiteColor),
                                ),
                              ),
                            ),
                          ),
                        ],
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
