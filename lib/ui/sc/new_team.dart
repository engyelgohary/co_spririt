import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class NewTeamSheetSC extends StatefulWidget {
  const NewTeamSheetSC({super.key});

  @override
  State<NewTeamSheetSC> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewTeamSheetSC> {
  ApiManager apiManager = ApiManager.getInstance();
  List fields = [TextEditingController()];
  int count = 1;

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    if (count == 1) {
                      return;
                    }
                    setState(() {
                      fields.removeLast();
                      count--;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    color: ODColorScheme.buttonColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      fields.add(TextEditingController());
                      count++;
                    });
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: ODColorScheme.buttonColor,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) => OpportunityTextFormField(
                fieldName: 'Team ${index + 1}',
                controller: fields[index],
              ),
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
                      List teams = [];
                      for (var team in fields) {
                        if (team.text.trim().isEmpty) {
                          return;
                        }
                        teams.add(team.text.trim());
                      }

                      loadingIndicatorDialog(context);
                      try {
                        await apiManager.AddMembers(teams);
                        snackBar(context, "Done");
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
    );
  }
}
