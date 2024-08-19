import 'dart:io';
import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/ui/collaborator/opportunities/cubit/opportunities_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

import '../../../data/model/Client.dart';
import '../../../utils/theme/appColors.dart';

class AddOpportunities extends StatefulWidget {
  final VoidCallback onOpportunityAdded;

  const AddOpportunities({Key? key, required this.onOpportunityAdded}) : super(key: key);

  @override
  State<AddOpportunities> createState() => _AddOpportunitiesState();
}

class _AddOpportunitiesState extends State<AddOpportunities> {
  late OpportunitiesCubit opportunitiesCubit;
  String? _filePath;
  Client? selectedClient;
  bool isSubmitting = false; // Track submission state
  bool isClientLoading = true; // Track client loading state

  @override
  void initState() {
    super.initState();
    opportunitiesCubit = OpportunitiesCubit(opportunitiesRepository: injectOpportunitiesRepository());
    opportunitiesCubit.fetchClients().then((_) {
      setState(() {
        isClientLoading = false;
      });
    });
    _initializeFilePicker();
  }

  Future<void> _initializeFilePicker() async {
    final status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      throw FileSystemException('Storage permission not granted');
    }
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
        opportunitiesCubit.descriptionFile = File(_filePath!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => opportunitiesCubit,
      child: AlertDialog(
        title: Text('Add Opportunity', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20)),
        content: SingleChildScrollView(
          child: Form(
            key: opportunitiesCubit.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: opportunitiesCubit.titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: opportunitiesCubit.descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    BlocBuilder<OpportunitiesCubit, OpportunitiesState>(
                      builder: (context, state) {
                        if (state is OpportunitiesClientsFetched) {
                          return DropdownButton<Client>(
                            hint: Text(
                              "Select Client",
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),
                            ),
                            value: selectedClient,
                            onChanged: (Client? newValue) {
                              setState(() {
                                selectedClient = newValue;
                                opportunitiesCubit.setSelectedClientId(selectedClient?.id);
                              });
                            },
                            items: state.clients.map((Client client) {
                              return DropdownMenuItem<Client>(
                                value: client,
                                child: Text('${client.firstName} ${client.lastName}'),
                              );
                            }).toList(),
                          );
                        } else {
                          return Container(); // Placeholder when no clients are loaded
                        }
                      },
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 30.h,
                      width: 130.w,
                      child: ElevatedButton(
                        onPressed: _selectFile,
                        child: Text(
                          _filePath == null ? 'Select File' : 'File Selected',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 16,
                            color: AppColor.whiteColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.r)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      height: 35.h,
                      width: 115.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 16,
                              color: AppColor.thirdColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.r)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    BlocConsumer<OpportunitiesCubit, OpportunitiesState>(
                      listener: (context, state) {
                        if (state is OpportunityFailure) {
                          setState(() {
                            isSubmitting = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
                          print(state.error);
                        } else if (state is OpportunitySuccess) {
                          setState(() {
                            isSubmitting = false;
                          });
                          widget.onOpportunityAdded(); // Call the callback
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opportunity submitted successfully')));
                        }
                      },
                      builder: (context, state) {
                        return Container(
                          height: 35.h,
                          width: 115.w,
                          child: ElevatedButton(
                            onPressed: () {
                              if (opportunitiesCubit.formKey.currentState!.validate()) {
                                setState(() {
                                  isSubmitting = true;
                                });
                                opportunitiesCubit.submit();
                              }
                            },
                            child: Text(
                              isSubmitting ? 'Submitting...' : 'Submit',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontSize: 16,
                                color: AppColor.whiteColor,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
