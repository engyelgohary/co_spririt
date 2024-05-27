import 'package:co_spririt/utils/components/appbar.dart';
import 'package:co_spririt/utils/components/requestList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestSuperAdmin extends StatelessWidget {
  static const String routeName = 'Request Super admin';
  const RequestSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requests',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
        actions: [
          AppBarCustomIcon(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(top:25.h,left: 15.w ,bottom: 12.h),
            child: Text('Status',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          ListRequestsCustom(name: "Status"),
          Padding(
            padding:  EdgeInsets.only(left: 15.w ,bottom: 12.h),
            child: Text('Type',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          ListRequestsCustom(name: "Types"),
        ],
      ),
    );
  }
}
