import 'dart:io';
import 'package:co_spirit/data/repository/repository/repository_impl.dart';
import 'package:co_spirit/ui/ow/Profile/Cubit/ow_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class EditProfileOW extends StatefulWidget {
  final String OWId;
  const EditProfileOW({super.key, required this.OWId});

  @override
  State<EditProfileOW> createState() => _EditProfileOWState();
}

class _EditProfileOWState extends State<EditProfileOW> {
  late OpportunityOwnerCubit viewModel;
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
    viewModel = OpportunityOwnerCubit(
        opportunityOwnerRepository: OpportunityOwnerRepositoryImpl(
      apiManager: ApiManager.getInstance(),
    ));
    viewModel.fetchOWDetails(widget.OWId);
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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<OpportunityOwnerCubit, OpportunityOwnerState>(
          builder: (context, state) {
            if (state is OpportunityOwnerLoading) {
              return const Center(
                child: CircularProgressIndicator(color: OWColorScheme.buttonColor),
              );
            } else if (state is OpportunityOwnerDetailsSuccess) {
              final OA = state.opportunityOwnerData;
              firstNameController.text = "${OA.firstName}";
              lastNameController.text = OA.lastName ?? "";
              phoneController.text = OA.phone ?? "";
              emailController.text = OA.email ?? "";
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
                                  'http://${ApiConstants.baseUrl}${OA.pictureLocation}',
                                ) as ImageProvider,
                          child: _selectedImage == null && OA.pictureLocation == null
                              ? const Icon(Icons.camera_alt, size: 50)
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Center(
                      child: Text("${firstNameController.text} ${lastNameController.text}",
                          style: const TextStyle(color: OWColorScheme.mainColor, fontSize: 18)),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomTextFormField(
                      fieldName: 'First Name',
                      controller: firstNameController,
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: OWColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Last Name',
                      controller: lastNameController,
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: OWColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Email',
                      controller: emailController,
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: OWColorScheme.mainColor,
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
                      textColor: OWColorScheme.mainColor,
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
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                backgroundColor: OWColorScheme.disabledColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.r),
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
                                context.read<OpportunityOwnerCubit>().updateOW({
                                  'id': widget.OWId,
                                  'firstName': firstNameController.text,
                                  'lastName': lastNameController.text,
                                  'phone': phoneController.text,
                                  'email': emailController.text,
                                  'password': "AdminAdmin",
                                  'canPost': state.opportunityOwnerData.canPost.toString(),
                                }, _selectedImage);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Profile Updated Successfully"),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                backgroundColor: OWColorScheme.buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.r),
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
            } else if (state is OpportunityOwnerError) {
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
