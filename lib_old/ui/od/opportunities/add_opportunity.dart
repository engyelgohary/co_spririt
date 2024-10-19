import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
  final risk = TextEditingController();
  final client = TextEditingController();
  final solution = TextEditingController();
  final industry = TextEditingController();
  final feasibility = TextEditingController();
  String? descriptionFilePath;
  final apiManager = ApiManager.getInstance();
  final LoadingStateNotifier<dynamic> loadingNotifier = LoadingStateNotifier();
  Map<dynamic, dynamic> risks = {};
  Map<dynamic, dynamic> solutions = {};
  Map<dynamic, dynamic> feasibilityOptions = {};
  Map<dynamic, dynamic> clients = {};

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListenableBuilder(
        listenable: loadingNotifier,
        builder: (context, child) {
          if (loadingNotifier.loading) {
            addOpportunityBackend(apiManager, loadingNotifier);
            return const Center(child: CircularProgressIndicator(color: ODColorScheme.buttonColor));
          } else if (loadingNotifier.response == null) {
            return Center(
              child: buildErrorIndicator(
                "Some error occurred, Please try again.",
                () => loadingNotifier.change(),
              ),
            );
          }

          risks = loadingNotifier.response![0];
          solutions = loadingNotifier.response![1];
          clients = loadingNotifier.response![2];
          feasibilityOptions = loadingNotifier.response![3];
          return SingleChildScrollView(
            child: Column(
              children: [
                OpportunityDropDownMenu(
                  fieldName: 'Customer Name',
                  dropDownOptions: clients.keys.toList(),
                  selection: client,
                  textColor: ODColorScheme.mainColor,
                ),
                OpportunityTextFormField(
                  fieldName: 'Opportunity title',
                  controller: title,
                  hintText: "Opportunity title",
                ),
                OpportunityTextFormField(
                  fieldName: 'Opportunity Description',
                  controller: description,
                  hintText: "Describe the opportunity. Slow system, old system, etc...",
                  maxLines: null,
                  minLines: 5,
                ),
                OpportunityDropDownMenu(
                  fieldName: "Corelia's Solution",
                  dropDownOptions: solutions.keys.toList(),
                  selection: solution,
                  hintText: "Cyber security",
                  textColor: ODColorScheme.mainColor,
                ),
                OpportunityDropDownMenu(
                  fieldName: 'Feasibility',
                  selection: feasibility,
                  dropDownOptions: feasibilityOptions.keys.toList(),
                  hintText: "Low, Medium, High",
                  textColor: ODColorScheme.mainColor,
                ),
                OpportunityDropDownMenu(
                  fieldName: 'Risk Factors',
                  dropDownOptions: risks.keys.toList(),
                  selection: risk,
                  hintText: "No budget, Delay, Competitors",
                  textColor: ODColorScheme.mainColor,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Attachmentss",
                        style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final path = await FilePicker.platform.pickFiles(
                                // type: FileType.custom,
                                // allowedExtensions: ["doc", "docm", "docx", "dot", "pdf"],
                                );
                            if (path != null) {
                              descriptionFilePath = path.paths[0];
                            }
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
                              'Upload',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 16, color: AppColor.whiteColor),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "Upload supporting documents (text, PDF, images) ",
                        style: TextStyle(fontSize: 14, color: ODColorScheme.mainColor),
                      ),
                    ],
                  ),
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
                            if (title.text.trim().isEmpty || client.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Please fill the missing data'),
                                duration: Duration(seconds: 2),
                              ));
                              return;
                            }
                            final case1 = description.text.isNotEmpty &&
                                solution.text.isNotEmpty &&
                                feasibility.text.isNotEmpty &&
                                risk.text.isNotEmpty;
                            if (descriptionFilePath == null && case1) {
                              print("case1");
                            } else if (descriptionFilePath != null && !case1) {
                              print("case2");
                            } else if (descriptionFilePath != null && case1) {
                              print("case3");
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill the missing data'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                            loadingIndicatorDialog(context);
                            try {
                              await apiManager.addOpportunity(
                                title.text,
                                description.text,
                                clients[client.text].toString(),
                                "Type",
                                feasibilityOptions[feasibility.text].toString(),
                                risks[risk.text].toString(),
                                solutions[solution.text].toString(),
                                descriptionFilePath,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Opportunity has been added successfully'),
                                  duration: Duration(seconds: 2),
                                ));
                                title.clear();
                                description.clear();
                                solution.clear();
                                client.clear();
                                feasibility.clear();
                                risk.clear();
                                descriptionFilePath = null;
                              }
                            } catch (e) {
                              print("problem with add opportunity: $e");
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('A error occurred'),
                                duration: Duration(seconds: 2),
                              ));
                            }
                            Navigator.of(context).pop();
                            loadingNotifier.change();
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
                              'Submit',
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
        },
      ),
    );
  }
}
