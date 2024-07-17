import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';

class OpportunitiesScreenColla extends StatelessWidget {
  const OpportunitiesScreenColla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opportunities",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),),
        leading: AppBarCustom(),
        actions: [
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: CircleAvatar(
                radius: 18.r, // Adjust the radius as needed
                backgroundColor: AppColor.secondColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
