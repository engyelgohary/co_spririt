import 'package:co_spirit/core/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class NewProjectSheetSC extends StatefulWidget {
  const NewProjectSheetSC({super.key});

  @override
  State<NewProjectSheetSC> createState() => _NewProjectSheetSCState();
}

class _NewProjectSheetSCState extends State<NewProjectSheetSC> {
  final projectName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OpportunityTextFormField(
            fieldName: 'Project Name',
            controller: projectName,
            // hintText: "Opportunity title",
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
    );
  }
}
