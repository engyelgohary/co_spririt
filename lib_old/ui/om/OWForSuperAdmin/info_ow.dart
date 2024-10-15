import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/api/apimanager.dart';
import '../../../data/model/OW.dart';
import '../../../utils/theme/appColors.dart';

class InfoOW extends StatelessWidget {
  final OW? opportunityOwner; // Updated type to OW
  const InfoOW(this.opportunityOwner, {super.key});

  @override
  Widget build(BuildContext context) {
    if (opportunityOwner == null) {
      return const CircularProgressIndicator();
    }
    return Container(
      height: 482.h,
      width: 369.w,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          CachedNetworkImage(
            imageUrl: 'http://${ApiConstants.baseUrl}${opportunityOwner!.pictureLocation}',
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 75.r,
              backgroundImage: imageProvider,
            ),
          ),
          SizedBox(height: 20.h),
          CustomTextInfo(fieldName: 'First Name:', data: "${opportunityOwner!.firstName}"),
          SizedBox(height: 16.h),
          CustomTextInfo(fieldName: 'Last Name:', data: "${opportunityOwner!.lastName}"),
          SizedBox(height: 16.h),
          CustomTextInfo(fieldName: 'Mobile:', data: "${opportunityOwner!.phone}"),
          SizedBox(height: 16.h),
          CustomTextInfo(fieldName: 'E-mail:', data: "${opportunityOwner!.email}"),
          SizedBox(height: 16.h),
          CustomTextInfo(fieldName: 'Can Post:', data: "${opportunityOwner!.canPost}"),
        ],
      ),
    );
  }
}

class CustomTextInfo extends StatelessWidget {
  final String fieldName;
  final double? width;
  final String data;

  const CustomTextInfo({super.key, required this.fieldName, this.width = 6, required this.data});

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
        SizedBox(width: width!.w),
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
