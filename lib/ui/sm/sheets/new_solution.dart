import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../utils/components/textFormField.dart';
import '../../../../utils/theme/appColors.dart';

class NewSolutionSM extends StatefulWidget {
  const NewSolutionSM({super.key});

  @override
  State<NewSolutionSM> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewSolutionSM> {
  ApiManager apiManager = ApiManager.getInstance();
  final TextEditingController solution = TextEditingController();
  final TextEditingController customerValue = TextEditingController();
  final TextEditingController targetCustomer = TextEditingController();
  final TextEditingController customer = TextEditingController();
  final TextEditingController phase = TextEditingController();
  final TextEditingController stakeholder = TextEditingController();
  final TextEditingController rd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OpportunityTextFormField(
              fieldName: 'Solution',
              controller: solution,
            ),
            OpportunityTextFormField(
              fieldName: 'Customer value',
              controller: customerValue,
              maxLines: null,
              minLines: 3,
            ),
            OpportunityTextFormField(
              fieldName: "Target Customer/Users:",
              controller: targetCustomer,
            ),
            OpportunityTextFormField(
              fieldName: "Co-working Customer:",
              controller: customer,
            ),
            OpportunityTextFormField(
              fieldName: "Phase:",
              controller: phase,
            ),
            OpportunityTextFormField(
              fieldName: "Co-working Stakeholder",
              controller: stakeholder,
            ),
            OpportunityTextFormField(
              fieldName: "Target Co-R&D",
              controller: rd,
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
                        backgroundColor: ODColorScheme.disabledColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.r),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontSize: 16,
                                color: AppColor.whiteColor,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (solution.text.isEmpty ||
                            customerValue.text.isEmpty ||
                            targetCustomer.text.isEmpty ||
                            customer.text.isEmpty ||
                            phase.text.isEmpty ||
                            stakeholder.text.isEmpty ||
                            rd.text.isEmpty) {
                          return;
                        }
                        loadingIndicatorDialog(context);
                        try {
                          await apiManager.AddSolution(
                            solution: solution.text,
                            customerValue: customerValue.text,
                            targetCustomerUser: targetCustomer.text,
                            coWorkingCustomer: customer.text,
                            phase: phase.text,
                            coWorkingStakeHolder: stakeholder.text,
                            targetCoRD: rd.text,
                          );
                          snackBar(context, "Done");
                          Navigator.of(context).pop();
                        } catch (e) {
                          snackBar(context, "Error $e");
                        }
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        backgroundColor: ODColorScheme.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.r),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontSize: 16,
                                color: AppColor.whiteColor,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
