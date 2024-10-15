import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/text_form_field.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:flutter/material.dart';


class NewTargetService extends StatefulWidget {
  const NewTargetService({super.key});

  @override
  State<NewTargetService> createState() => _NewTargetServiceState();
}

class _NewTargetServiceState extends State<NewTargetService> {
  final targetService = TextEditingController();
  final apiManager = ApiManager.getInstance();

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OpportunityTextFormField(
            fieldName: 'Target Service',
            controller: targetService,
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
                      if (targetService.text.isEmpty) {
                        return;
                      }

                      loadingIndicatorDialog(context);
                      try {
                        await apiManager.addTargetService(targetService.text);
                        snackBar(context, "Done");
                        Navigator.of(context).pop();
                      } catch (e) {
                        snackBar(context, "Error $e");
                      }
                      Navigator.of(context).pop();
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
