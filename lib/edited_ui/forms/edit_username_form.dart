import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Cubit/cubit_state.dart';
import '../../data/edited_model/user_profile.dart';
import '../settings/cubit/settings_cubit.dart';

class EditUsernameForm extends StatefulWidget {
  const EditUsernameForm({super.key});

  @override
  State<EditUsernameForm> createState() => _EditUsernameFormState();
}

class _EditUsernameFormState extends State<EditUsernameForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // A flag to ensure the loading dialog is not shown multiple times
  bool _isLoadingDialogVisible = false;

  void _showLoadingDialog() {
    if (!_isLoadingDialogVisible) {
      _isLoadingDialogVisible = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }
  }

  void _hideLoadingDialog() {
    if (_isLoadingDialogVisible) {
      _isLoadingDialogVisible = false;
      Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
    }
  }

  Future<void> _closeModalSheet() async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close modal sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, CubitState>(
      listener: (context, state) async {
        if (state is CubitLoadingState) {
          _showLoadingDialog();
        } else {
          _hideLoadingDialog();

          if (state is CubitSuccessState<UserProfile>) {
            await _closeModalSheet(); // Close modal sheet after success
            context.read<SettingsCubit>().fetchCurrentUser(); // Refresh user data
            print("Update succeeded");
          } else if (state is CubitFailureState) {
            await _closeModalSheet(); // Close modal sheet even on failure

            print("Update failed");
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "First Name",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "First name is required.";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Last Name",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Last name is required.";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _closeModalSheet();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          context.read<SettingsCubit>().updateUserProfile(
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim(),
                          );
                          print("Submit button clicked");
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

