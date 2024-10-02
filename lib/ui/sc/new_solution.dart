import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class NewSolutionSC extends StatefulWidget {
  const NewSolutionSC({super.key});

  @override
  State<NewSolutionSC> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewSolutionSC> {
  ApiManager apiManager = ApiManager.getInstance();
  List fields = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OpportunityTextFormField(
            fieldName: 'Solution',
            controller: TextEditingController(),
          ),
          OpportunityTextFormField(
            fieldName: 'Customer value',
            controller: TextEditingController(),
            maxLines: null,
            minLines: 3,
          ),
          OpportunityDropDownMenu(
            fieldName: "Target Customer/Users:",
            selection: TextEditingController(),
            dropDownOptions: [],
            textColor: ODColorScheme.mainColor,
          ),
          OpportunityDropDownMenu(
            fieldName: "Co-working Customer:",
            selection: TextEditingController(),
            dropDownOptions: [],
            textColor: ODColorScheme.mainColor,
          ),
          OpportunityDropDownMenu(
            fieldName: "Phase:",
            selection: TextEditingController(),
            dropDownOptions: ["Proposal", "PoC", "on Service"],
            textColor: ODColorScheme.mainColor,
          ),
          OpportunityDropDownMenu(
            fieldName: "Co-working Stakeholder",
            selection: TextEditingController(),
            dropDownOptions: [],
            textColor: ODColorScheme.mainColor,
          ),
          OpportunityDropDownMenu(
            fieldName: "Target Co-R&D",
            selection: TextEditingController(),
            dropDownOptions: [],
            textColor: ODColorScheme.mainColor,
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
                      loadingIndicatorDialog(context);
                      try {} catch (e) {}
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
    );
  }
}
