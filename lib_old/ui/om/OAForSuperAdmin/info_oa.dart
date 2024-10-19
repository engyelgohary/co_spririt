import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/api/apimanager.dart';
import '../../../data/model/OA.dart'; // Ensure you import your OA model
import '../../../utils/theme/appColors.dart';

class InfoOA extends StatelessWidget {
  final OA? opportunityAnalyzer; // Updated type to OA
  const InfoOA(this.opportunityAnalyzer, {super.key});

  @override
  Widget build(BuildContext context) {
    if (opportunityAnalyzer == null) {
      return const CircularProgressIndicator(); // Show loading indicator if data is null
    }
    return Container(
      height: 482,
      width: 369,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          CachedNetworkImage(
            imageUrl: 'http://${ApiConstants.baseUrl}${opportunityAnalyzer!.pictureLocation}',
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 75,
              backgroundImage: imageProvider,
            ),
          ),
          SizedBox(height: 20),
          CustomTextInfo(fieldName: 'First Name:', data: "${opportunityAnalyzer!.firstName}"),
          SizedBox(height: 16),
          CustomTextInfo(fieldName: 'Last Name:', data: "${opportunityAnalyzer!.lastName}"),
          SizedBox(height: 16),
          CustomTextInfo(fieldName: 'Mobile:', data: "${opportunityAnalyzer!.phone}"),
          SizedBox(height: 16),
          CustomTextInfo(fieldName: 'E-mail:', data: "${opportunityAnalyzer!.email}"),
          SizedBox(height: 16),
          CustomTextInfo(fieldName: 'Can Post:', data: "${opportunityAnalyzer!.canPost}"),
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
        SizedBox(width: width!),
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
