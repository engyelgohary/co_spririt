import 'package:co_spirit/edited_ui/forms/edit_username_form.dart';
import 'package:co_spirit/edited_ui/forms/update_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_initicon/flutter_initicon.dart';

import '../../core/Cubit/cubit_state.dart';
import '../../core/app_util.dart';
import '../../data/edited_model/user_profile.dart';
import 'cubit/settings_cubit.dart';

class OdSettings extends StatefulWidget {
  const OdSettings({Key? key}) : super(key: key);

  @override
  State<OdSettings> createState() => _OdSettingsState();
}

class _OdSettingsState extends State<OdSettings> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SettingsCubit>().fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
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

                if (state is CubitSuccessState<UserProfile>) {
                  final user = state.response;

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Profile Management :",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: AppUtil.responsiveHeight(context) * 0.04,
                        ),
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: user.pictureUrl != null
                                    ? NetworkImage(user.pictureUrl!)
                                    : null,
                                backgroundColor: Colors.grey[300],
                                child: user.pictureUrl == null
                                    ? Initicon(
                                        text:
                                            '${user.firstName} ${user.lastName}',
                                        size: AppUtil.responsiveWidth(context) *
                                            0.3,
                                        elevation: 4,
                                      )
                                    : const Icon(Icons.person),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: AppUtil.responsiveHeight(context) * 0.06,
                        ),

                        // Full Name Field
                        const Text(
                          "Full Name",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
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
                                  child: UpdatePasswordForm(),
                                );
                              },
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
