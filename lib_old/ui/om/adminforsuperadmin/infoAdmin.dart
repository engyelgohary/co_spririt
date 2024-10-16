import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/api/apimanager.dart';
import '../../../data/model/GetAdmin.dart';
import '../../../utils/theme/appColors.dart';

class InfoAdmin extends StatelessWidget {
  GetAdmin? admin;
  InfoAdmin(this.admin, {super.key});

  @override
  Widget build(BuildContext context) {
    if (admin == null) {
      return const CircularProgressIndicator();
    }
    return Container(
      height: 482,
      width: 369,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          CachedNetworkImage(
            imageUrl: 'http://${ApiConstants.baseUrl}${admin!.pictureLocation}',
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 75,
              backgroundImage: imageProvider,
            ),
          ),
          SizedBox(height: 20.h),
          CustomTextInfo(fieldName: 'First Name :', data: "${admin!.firstName}"),
          SizedBox(
            height: 16,
          ),
          CustomTextInfo(fieldName: 'Last Name : ', data: "${admin!.lastName}"),
          SizedBox(
            height: 16,
          ),
          CustomTextInfo(fieldName: 'Mobile : ', data: "${admin!.phone}"),
          SizedBox(
            height: 16,
          ),
          CustomTextInfo(fieldName: 'E-mail : ', data: "${admin!.email}"),
          SizedBox(
            height: 16,
          ),
          CustomTextInfo(fieldName: 'Can Post:', data: "${admin!.canPost}"),
        ],
      ),
    );
  }
}

class CustomTextInfo extends StatelessWidget {
  String fieldName;
  double? width;
  String data;
  CustomTextInfo({super.key, required this.fieldName, this.width = 6, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          fieldName,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: AppColor.basicColor),
        ),
        SizedBox(
          width: width!,
        ),
        Text(
          data,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 18, fontWeight: FontWeight.w400, color: AppColor.basicColor),
        ),
      ],
    );
  }
}
