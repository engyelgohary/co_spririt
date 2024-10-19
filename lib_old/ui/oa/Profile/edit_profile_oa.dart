import 'dart:io';
import 'package:co_spirit/data/repository/repository/repository_impl.dart';
import 'package:co_spirit/ui/oa/Profile/Cubit/oa_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class EditProfileOA extends StatefulWidget {
  final String OAId;
  const EditProfileOA({super.key, required this.OAId});

  @override
  State<EditProfileOA> createState() => _EditProfileOAState();
}

class _EditProfileOAState extends State<EditProfileOA> {
  late OpportunityAnalyzerCubit viewModel;
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
    viewModel = OpportunityAnalyzerCubit(
      opportunityAnalyzerRepository: OpportunityAnalyzerRepositoryImpl(
        apiManager: ApiManager.getInstance(),
      ),
    );
    viewModel.fetchOADetails(widget.OAId);
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
        child: BlocBuilder<OpportunityAnalyzerCubit, OpportunityAnalyzerState>(
          builder: (context, state) {
            if (state is OpportunityAnalyzerLoading) {
              return const Center(
                child: CircularProgressIndicator(color: OAColorScheme.buttonColor),
              );
            } else if (state is OpportunityAnalyzerDetailsSuccess) {
              final OA = state.opportunityAnalyzerData;
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
                          radius: 60,
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
                      height: 16,
                    ),
                    Center(
                      child: Text("${firstNameController.text} ${lastNameController.text}",
                          style: const TextStyle(color: OAColorScheme.mainColor, fontSize: 18)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextFormField(
                      fieldName: 'First Name',
                      controller: firstNameController,
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: OAColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Last Name',
                      controller: lastNameController,
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: OAColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Email',
                      controller: emailController,
                      borderColor: const Color.fromARGB(150, 0, 0, 0),
                      textColor: OAColorScheme.mainColor,
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
                      textColor: OAColorScheme.mainColor,
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
                                backgroundColor: OAColorScheme.disabledColor,
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
                                context.read<OpportunityAnalyzerCubit>().updateOA({
                                  'id': widget.OAId,
                                  'firstName': firstNameController.text,
                                  'lastName': lastNameController.text,
                                  'phone': phoneController.text,
                                  'email': emailController.text,
                                  'password': "AdminAdmin",
                                  'canPost': state.opportunityAnalyzerData.canPost.toString(),
                                }, _selectedImage);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Profile Updated Successfully"),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: OAColorScheme.buttonColor,
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
            } else if (state is OpportunityAnalyzerError) {
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
