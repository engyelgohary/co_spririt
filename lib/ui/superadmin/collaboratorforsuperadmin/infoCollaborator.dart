import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/model/GetAdmin.dart';
import '../../../utils/theme/appColors.dart';
import '../adminforsuperadmin/infoAdmin.dart';
import 'package:intl/intl.dart';

class InfoCollaborator extends StatelessWidget {
  final Collaborator? collaborator;
  final List<GetAdmin> admin;

  InfoCollaborator({required this.collaborator,required this.admin});

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      print('Permission granted');
    } else {
      print('Permission denied');
    }
  }

  Future<void> _downloadAndOpenCV(BuildContext context) async {
    try {
      await _requestPermissions();

      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/cv.pdf';
      print('Saving to: $filePath');

      final dio = Dio();
      final cvUrl = 'http://10.10.99.13:3090${collaborator!.cvLocation}';
      print('Downloading from: $cvUrl');

      final response = await dio.download(cvUrl, filePath);

      if (response.statusCode == 200) {
        print('Download completed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download completed: $filePath')),
        );

        // Open the downloaded file
        final result = await OpenFile.open(filePath);
        print('OpenFile result: ${result.message}');
      } else {
        print('Download failed: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file: $e')),
      );
    }
  }

  int calculateMonthsDifference(DateTime startDate, DateTime endDate) {
    int yearsDifference = endDate.year - startDate.year;
    int monthsDifference = endDate.month - startDate.month;
    return yearsDifference * 12 + monthsDifference;
  }
  String getAdminName(int adminId) {
    final admins = admin.firstWhere((admin) => admin.id == adminId, orElse: () => GetAdmin());
    return admins.id != null ? '${admins.firstName} ${admins.lastName}' : 'No Admin Assigned';
  }

  @override
  Widget build(BuildContext context) {
    DateTime contractStartDate = DateTime.parse(collaborator!.contractStart ?? "");
    DateTime contractEndDate = DateTime.parse(collaborator!.contractEnd ?? "");
    int monthsDuration = calculateMonthsDifference(contractStartDate, contractEndDate);
    String formattedDuration = "$monthsDuration months";
    DateTime lastCommunicationDate = DateTime.parse(collaborator!.lastCommunication??"");
    String formattedDate = DateFormat('yyyy-MM-dd').format(lastCommunicationDate);
    final adminName = collaborator!.adminId != null ? getAdminName(collaborator!.adminId!) : 'No Admin Assigned';
    return SingleChildScrollView(
      child: Container(
        height: 600.h,
        width: 369.w,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            CachedNetworkImage(
              imageUrl: 'http://10.10.99.13:3090${collaborator!.pictureLocation}',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 75.r,
                backgroundImage: imageProvider,
              ),
            ),
            SizedBox(height: 20.h),
            CustomTextInfo(fieldName: 'First Name :', data: "${collaborator!.firstName}"),
            SizedBox(height: 16.h),
            CustomTextInfo(fieldName: 'Last Name :', data: "${collaborator!.lastName}"),
            SizedBox(height: 16.h),
            CustomTextInfo(fieldName: 'Mobile :', data: "${collaborator!.phone}"),
            SizedBox(height: 16.h),
            CustomTextInfo(fieldName: 'E-mail :', data: "${collaborator!.email}"),
            SizedBox(height: 16.h),
            CustomTextInfo(fieldName: 'Contract Duration :', data: formattedDuration),
            SizedBox(height: 16.h),
            CustomTextInfo(fieldName: 'Last Communications:', data: formattedDate),
            SizedBox(height: 16.h),
            CustomTextInfo(fieldName: 'Status :', data: collaborator != null
                ? _getStatusText(collaborator!.status)
                : 'Unknown'),
            SizedBox(height: 16.h),
            CustomTextInfo(fieldName: 'Assigned To Admin:', data: adminName),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text(
                  "CV:",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColor.basicColor),
                ),
                Spacer(),
                Container(
                  height: 35.h,
                  width: 135.w,
                  child: ElevatedButton(
                    onPressed: () {
                      _downloadAndOpenCV(context);
                    },
                    child: Center(
                      child: Text(
                        'Download',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 16,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.r)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  String _getStatusText(int? status) {
    switch (status) {
      case 1:
        return 'Red';
      case 2:
        return 'Green';
      case 3:
        return 'Orange';
      default:
        return 'Unknown';
    }
  }
}
