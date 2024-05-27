import 'package:co_spririt/ui/superadmin/adminforsuperadmin/update_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import 'add_admins.dart';
import 'admin_details.dart';

class AdminScreenForSuper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppUI.secondColor),
                        child: BackButton(
                          color: AppUI.whiteColor,
                        ),
                      ),
                      Center(
                        child: CustomText(
                          text: 'Admins',
                          fontSize: 20,
                          color: AppUI.basicColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0)),
                              ),
                              constraints: BoxConstraints(
                                  // maxHeight: double.infinity,
                                  ),
                              // scrollControlDisabledMaxHeightRatio: 1,
                              builder: (context) => Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(
                                    radius: 20,
                                    child: AddAdminsScreen(),
                                  )));
                        },
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppUI.secondColor),
                          child: ImageIcon(
                            AssetImage(
                              '${AppUI.iconPath}useradd.png',
                            ),
                            color: AppUI.whiteColor,
                            size: 42,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                  height: 680.h,
                  width: 600.w,
                  child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 18,
                  itemBuilder: (context, index) =>Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: InkWell(
                          onTap: () {
                            //AppUtil.mainNavigator(context, ChatScreen());
                          },
                          child: Container(
                            // width: ,
                            height: 40,
                            child: Row(
                              children: [
                                Image.asset(
                                  '${AppUI.imgPath}photo.png',
                                  height: 41,
                                  width: 42,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Matteo',
                                        fontSize: 15,
                                        color: AppUI.basicColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      CustomText(
                                        text: 'MR@email.com',
                                        fontSize: 12,
                                        color: AppUI.basicColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.vertical(
                                                  top: Radius.circular(
                                                      20.0)),
                                            ),
                                            constraints: BoxConstraints(
                                              //maxHeight: double.infinity,
                                            ),
                                            // scrollControlDisabledMaxHeightRatio:
                                            //     1,
                                            builder: (context) => Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: CustomCard(
                                                  child:
                                                  UpdateAdminScreen(),
                                                  // height:
                                                  //     MediaQuery.sizeOf(context)
                                                  //             .height *
                                                  //         .8,
                                                  radius: 20,
                                                )));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 29,
                                        width: 29,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          color: AppUI.opacityColor,
                                        ),
                                        child: ImageIcon(
                                          AssetImage(
                                            '${AppUI.iconPath}load.png',
                                          ),
                                          color: AppUI.secondColor,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.vertical(
                                                  top: Radius.circular(
                                                      20.0)),
                                            ),
                                            constraints: BoxConstraints(
                                              //maxHeight: double.infinity,
                                            ),
                                            // scrollControlDisabledMaxHeightRatio:
                                            //     1,
                                            builder: (context) => Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: CustomCard(
                                                  child:
                                                  AdminDetailsScreen(),
                                                  // height:
                                                  //     MediaQuery.sizeOf(context)
                                                  //             .height *
                                                  //         .8,
                                                  radius: 20,
                                                )));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 29,
                                        width: 29,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          color: AppUI.opacityColor,
                                        ),
                                        child: ImageIcon(
                                          AssetImage(
                                            '${AppUI.iconPath}details.png',
                                          ),
                                          color: AppUI.secondColor,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: AppUI.whiteColor,
                      )
                    ],
                  ),

                  ))
                ])));
  }
}
