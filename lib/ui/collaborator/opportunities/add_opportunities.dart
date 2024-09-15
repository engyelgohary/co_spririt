import 'package:co_spririt/data/api/apimanager.dart';
import 'package:co_spririt/data/model/opportunity.dart';
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
  final title = TextEditingController();
  final description = TextEditingController();
  final industry = TextEditingController();
  final clientId = TextEditingController();
  final opportunityType = TextEditingController();
  final feasibility = TextEditingController();
  final risks = TextEditingController();
  String? descriptionFilePath;
  final apiManager = ApiManager.getInstance();
  final LoadingStateNotifier<dynamic> loadingNotifier = LoadingStateNotifier(loading: false);

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
                    controller: title,
                  ),
                  CustomTextFormField(
                    fieldName: 'Description',
                    controller: description,
                  ),
                  CustomTextFormField(
                    fieldName: 'Client Id',
                    controller: clientId,
                  ),
                  CustomTextFormField(
                    fieldName: 'Type',
                    controller: opportunityType,
                  ),
                  CustomTextFormField(
                    fieldName: 'Industry',
                    controller: industry,
                  ),
                  CustomTextFormField(
                    fieldName: 'Feasibility',
                    controller: feasibility,
                  ),
                  CustomTextFormField(
                    fieldName: 'Risks',
                    controller: risks,
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
                              final path = await FilePicker.platform.pickFiles();
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
                            if (title.text.trim().isEmpty ||
                                description.text.trim().isEmpty ||
                                clientId.text.trim().isEmpty ||
                                opportunityType.text.trim().isEmpty ||
                                industry.text.trim().isEmpty ||
                                feasibility.text.trim().isEmpty ||
                                risks.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Please fill the missing data'),
                                duration: Duration(seconds: 2),
                              ));
                              return;
                            }
                            loadingNotifier.change();
                            try {
                              await apiManager.addOpportunity(
                                title.text,
                                description.text,
                                clientId.text,
                                opportunityType.text,
                                industry.text,
                                feasibility.text,
                                risks.text,
                                descriptionFilePath,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Opportunity has been added successfully'),
                                  duration: Duration(seconds: 2),
                                ));
                                title.clear();
                                description.clear();
                                clientId.clear();
                                opportunityType.clear();
                                industry.clear();
                                feasibility.clear();
                                risks.clear();
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
                              'Update',
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
