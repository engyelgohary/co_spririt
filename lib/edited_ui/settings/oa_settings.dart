import 'dart:io';

import 'package:co_spirit/core/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/Cubit/cubit_state.dart';
import '../../core/app_util.dart';
import '../../data/edited_model/user.dart';
import '../forms/edit_username_form.dart';
import 'cubit/settings_cubit.dart';

class OaSettings extends StatefulWidget {
  const OaSettings({Key? key}) : super(key: key);

  @override
  State<OaSettings> createState() => _OaSettingsState();
}

class _OaSettingsState extends State<OaSettings> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SettingsCubit>().fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<SettingsCubit>().fetchCurrentUser();
            },
            child: BlocBuilder<SettingsCubit, CubitState>(
              builder: (context, state) {
                if (state is CubitLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CubitFailureState) {
                  return Center(child: Text("Error here??: ${state.error}"));
                }

                if (state is CubitSuccessState<User>) {
                  final user = state.response;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Profile Management :",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 40),

                        // Profile Image with Upload Button
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                backgroundColor: Colors.grey[300],
                                child: _profileImage == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppUI.oaMainColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            '${user.firstName} ${user.lastName}' ?? 'Olivier Matteo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppUI.oaMainColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppUtil.responsiveHeight(context) * 0.04,
                        ),
                        // Full Name Field
                        const Text(
                          "Full Name",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: AppUtil.responsiveHeight(context) * 0.02,
                        ),
                        TextFormField(
                          initialValue: '${user.firstName} ${user.lastName}',
                          readOnly: true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return BlocProvider.value(
                                      value: context.read<SettingsCubit>(),
                                      child: EditUsernameForm(),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.mode_edit_outlined),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFDFE8F8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppUtil.responsiveHeight(context) * 0.02,
                        ),
                        // Email Address Field
                        const Text(
                          "Email Address",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        TextFormField(
                          initialValue: "email@email.com",
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFDFE8F8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppUtil.responsiveHeight(context) * 0.02,
                        ),

                        // Role Field
                        const Text(
                          "Role",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        TextFormField(
                          initialValue: user.role,
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFDFE8F8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppUtil.responsiveHeight(context) * 0.04,
                        ),

                        // Update Password Link
                        GestureDetector(
                          onTap: () {
                            // TODO: Handle password update navigation
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Update Password clicked!'),
                              ),
                            );
                          },
                          child: const Text(
                            "Update Password",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const Center(child: Text("Unexpected state."));
              },
            ),
          ),
        ),
      ),
    );
  }
}
