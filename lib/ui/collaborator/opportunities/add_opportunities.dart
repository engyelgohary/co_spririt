import 'package:co_spririt/data/api/apimanager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/appbar.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';

class AddOpportunitiesV2 extends StatefulWidget {
  const AddOpportunitiesV2({super.key});

  @override
  State<AddOpportunitiesV2> createState() => _AddOpportunitiesV2State();
}

class _AddOpportunitiesV2State extends State<AddOpportunitiesV2> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final industryController = TextEditingController();
  final clientIdController = TextEditingController();
  final typeController = TextEditingController();
  final risksController = TextEditingController();
  String? type;
  String? industry;
  String? feasibility;
  String? descriptionFilePath;
  final apiManagerController = ApiManager.getInstance();
  final LoadingStateNotifier<dynamic> loadingNotifier = LoadingStateNotifier(loading: false);

  final feasibilityOptions = ["Low", "Medium", "High"];
  final industryOptions = [
    "Technology",
    "AI",
    "Data Science",
    "Manufacturing",
    "Food & Beverage",
    "Networks",
    "Marketing",
    "Others",
  ];
  final typeOptions = [
    "Web Application",
    "Mobile Application",
    "Dashboard",
    "Chatbot",
    "Product",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Opportunities",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: const AppBarCustom(),
      ),
      body: ListenableBuilder(
          listenable: loadingNotifier,
          builder: (context, child) {
            if (loadingNotifier.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextFormField(
                    fieldName: 'Title',
                    controller: titleController,
                  ),
                  CustomTextFormField(
                    fieldName: 'Description',
                    controller: descriptionController,
                  ),
                  CustomTextFormField(
                    fieldName: 'Client Id',
                    controller: clientIdController,
                  ),
                  CustomDropDownMenu(
                    fieldName: "Type",
                    controller: typeController,
                    dropDownOptions: typeOptions,
                    selection: (selected) => type = selected,
                  ),
                  CustomDropDownMenu(
                    fieldName: 'Industry',
                    controller: industryController,
                    dropDownOptions: industryOptions,
                    selection: (selected) => industry = selected,
                  ),
                  CustomDropDownMenu(
                    fieldName: 'Feasibility',
                    selection: (selected) => feasibility,
                    dropDownOptions: feasibilityOptions,
                  ),
                  CustomTextFormField(
                    fieldName: 'Risks',
                    controller: risksController,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Description File",
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              final path = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                // allowedExtensions: ["doc", "docm", "docx", "dot", "pdf"],
                                allowedExtensions: ["pdf"],
                              );
                              if (path != null) {
                                descriptionFilePath = path.paths[0];
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.buttonColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.r)))),
                            child: Center(
                              child: Text(
                                'Upload',
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
                      child: SizedBox(
                        height: 35.h,
                        width: 135.w,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (titleController.text.trim().isEmpty ||
                                descriptionController.text.trim().isEmpty ||
                                clientIdController.text.trim().isEmpty ||
                                typeController.text.trim().isEmpty ||
                                industryController.text.trim().isEmpty ||
                                risksController.text.trim().isEmpty ||
                                feasibility == null ||
                                (industry == null && industryController.text.isEmpty) ||
                                (type == null && typeController.text.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Please fill the missing data'),
                                duration: Duration(seconds: 2),
                              ));
                              return;
                            }
                            loadingNotifier.change();
                            try {
                              await apiManagerController.addOpportunity(
                                titleController.text,
                                descriptionController.text,
                                clientIdController.text,
                                typeController.text,
                                industryController.text,
                                feasibility.toString(),
                                risksController.text,
                                descriptionFilePath,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Opportunity has been added successfully'),
                                  duration: Duration(seconds: 2),
                                ));
                                titleController.clear();
                                descriptionController.clear();
                                clientIdController.clear();
                                typeController.clear();
                                industryController.clear();
                                feasibility = null;
                                risksController.clear();
                                descriptionFilePath = null;
                              }
                            } catch (e) {
                              print("problem with add opportunity");
                            }
                            loadingNotifier.change();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Add',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 16, color: AppColor.whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
