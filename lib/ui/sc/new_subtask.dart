import 'package:co_spirit/core/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

// TODO do add team

class NewSubTaskSheet extends StatefulWidget {
  const NewSubTaskSheet({super.key});

  @override
  State<NewSubTaskSheet> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewSubTaskSheet> {
  final projectName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OpportunityDropDownMenu(
              fieldName: 'Project',
              controller: projectName,
              selection: null,
              dropDownOptions: [],
              textColor: OMColorScheme.mainColor,
            ),
            OpportunityDropDownMenu(
              fieldName: 'Task Category',
              controller: projectName,
              selection: null,
              dropDownOptions: [],
              textColor: OMColorScheme.mainColor,
            ),
            OpportunityDropDownMenu(
              fieldName: 'Task',
              controller: projectName,
              selection: null,
              dropDownOptions: [],
              textColor: OMColorScheme.mainColor,
            ),
            OpportunityTextFormField(
              fieldName: 'Subtask',
              controller: projectName,
            ),
            const Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OpportunityDropDownMenu(
                          fieldName: "Assigned Team",
                          selection: null,
                          dropDownOptions: [],
                          textColor: OMColorScheme.mainColor,
                        ),
                        OpportunityDropDownMenu(
                          fieldName: "",
                          selection: null,
                          dropDownOptions: [],
                          textColor: OMColorScheme.mainColor,
                        ),
                        OpportunityDropDownMenu(
                          fieldName: "",
                          selection: null,
                          dropDownOptions: [],
                          textColor: OMColorScheme.mainColor,
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OpportunityDropDownMenu(
                          fieldName: "RACI",
                          selection: null,
                          dropDownOptions: [],
                          textColor: OMColorScheme.mainColor,
                        ),
                        OpportunityDropDownMenu(
                          fieldName: "",
                          selection: null,
                          dropDownOptions: [],
                          textColor: OMColorScheme.mainColor,
                        ),
                        OpportunityDropDownMenu(
                          fieldName: "",
                          selection: null,
                          dropDownOptions: [],
                          textColor: OMColorScheme.mainColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            OpportunityTextFormField(
              fieldName: 'Milestone',
              controller: projectName,
            ),
            OpportunityTextFormField(
              fieldName: 'Priority',
              controller: projectName,
            ),
            OpportunityTextFormField(
              fieldName: 'Progress',
              controller: projectName,
            ),
            OpportunityTextFormField(
              fieldName: 'Status',
              controller: projectName,
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
                      onPressed: () async {},
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
