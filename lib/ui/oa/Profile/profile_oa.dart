import 'dart:io';
import 'package:co_spirit/data/repository/repository/repository_impl.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';
import '../../auth/login.dart';
import 'Cubit/oa_cubit.dart';
import 'edit_profile_oa.dart';

class ProfileScreenOA extends StatefulWidget {
  final String OAId;
  const ProfileScreenOA({super.key, required this.OAId});

  @override
  State<ProfileScreenOA> createState() => _ProfileScreenOAState();
}

class _ProfileScreenOAState extends State<ProfileScreenOA> {
  late OpportunityAnalyzerCubit viewModel;
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: customAppBar(
          title: "Profile",
          context: context,
          backArrowColor: OAColorScheme.buttonColor,
          textColor: OAColorScheme.mainColor,
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
                          child: EditProfileOA(
                        OAId: widget.OAId,
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
                    SizedBox(
                      height: 16.h,
                    ),
                    Center(
                      child: Text("${firstNameController.text} ${lastNameController.text}",
                          style: const TextStyle(color: OAColorScheme.mainColor, fontSize: 18)),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomTextFormField(
                      fieldName: 'First Name',
                      controller: firstNameController,
                      enabled: false,
                      textColor: OAColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Last Name',
                      controller: lastNameController,
                      enabled: false,
                      textColor: OAColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Email',
                      controller: emailController,
                      enabled: false,
                      textColor: OAColorScheme.mainColor,
                    ),
                    CustomTextFormField(
                      fieldName: 'Phone',
                      controller: phoneController,
                      enabled: false,
                      textColor: OAColorScheme.mainColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: width / 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Notification",
                            style: TextStyle(fontSize: 16, color: OAColorScheme.mainColor),
                          ),
                          Switch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: OAColorScheme.buttonColor,
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
                            style: TextStyle(fontSize: 16, color: OAColorScheme.mainColor),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Change",
                              style: TextStyle(
                                fontSize: 16,
                                color: OAColorScheme.buttonColor,
                                decoration: TextDecoration.underline,
                                decorationColor: OAColorScheme.buttonColor,
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
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            backgroundColor: OAColorScheme.buttonColor,
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
