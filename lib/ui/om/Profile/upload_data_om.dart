import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/theme/appColors.dart';
import '../../auth/login.dart';

class UploadDataOM extends StatefulWidget {
  const UploadDataOM({super.key});

  @override
  State<UploadDataOM> createState() => _UploadDataOMState();
}

class _UploadDataOMState extends State<UploadDataOM> {
  String? dataFileLocation;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Download Template",
              style: TextStyle(color: OMColorScheme.mainColor, fontSize: 18),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(
                        "https://drive.google.com/file/d/1-RJV8SqMhKE-TaTQTyBbtfgQlNF9ZMZ5/view?usp=sharing",
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: OMColorScheme.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.r),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Download',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 18, color: AppColor.whiteColor),
                    ),
                  ),
                ),
              ),
            ),
            const Text(
              "Download CSV template",
              style: TextStyle(color: Color.fromARGB(150, 0, 0, 0), fontSize: 14),
            ),
            SizedBox(height: 16),
            const Text(
              "Upload Template",
              style: TextStyle(color: OMColorScheme.mainColor, fontSize: 18),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final path = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ["csv"],
                    );
                    if (path != null) {
                      dataFileLocation = path.paths[0];
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: OMColorScheme.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.r),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Upload',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 18, color: AppColor.whiteColor),
                    ),
                  ),
                ),
              ),
            ),
            const Text(
              "Upload CSV template",
              style: TextStyle(color: Color.fromARGB(150, 0, 0, 0), fontSize: 14),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
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
                        if (dataFileLocation != null && dataFileLocation!.isNotEmpty) {
                          // loadingIndicatorDialog(context);
                          try {
                            await uploadCsvFile(
                              context,
                              ApiManager.getInstance(),
                              "/home/yusuf/Desktop/test.csv",
                            );
                            // Navigator.of(context).pop();
                          } catch (e) {
                            if (context.mounted) {
                              snackBar(context, e.toString());
                            }
                            print("- uploadCsvFile error: $e");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        backgroundColor: OMColorScheme.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.r),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
