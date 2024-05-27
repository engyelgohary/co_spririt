import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../Menu/menu_admin.dart';
import '../Message/Message_admin.dart';
import '../Notifactions/notifictionadmin.dart';
import '../Profile/profile_admin.dart';
import '../requests/request_admin.dart';

class HomeScreenAdmin extends StatelessWidget {
  static String routeName = 'home screen admin';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: Column(children: [
          // ClipOval(
          //  // clipBehavior: Clip.hardEdge,
          //   clipper: OvalTopBorderClipper(),
          //   child: Container(
          //     height: 120,
          //     color: AppUI.whiteColor,
          //     child: Column(
          //       children: [
          //         SizedBox(height: 20,),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Image.asset(
          //               '${AppUI.imgPath}logo.png',
          //               height: 23,
          //               width: 100,
          //               // fit: BoxFit.cover,
          //             ),
          //             Icon(Icons.notifications_outlined,color: AppUI.borderColor,),
          //           ],
          //         ),
          //         SizedBox(height: 12,),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Column(
          //               children: [
          //                 ImageIcon(
          //                   AssetImage("${AppUI.iconPath}Home.png",),size: 24,color: AppUI.borderColor,
          //                   semanticLabel: 'Home',),
          //                 SizedBox(height: 8,),
          //                 CustomText(text: 'Home',
          //                   fontSize: 12,
          //                   color: AppUI.borderColor,
          //                   fontWeight: FontWeight.w400,
          //                 )
          //               ],
          //             ),
          //             Column(
          //               children: [
          //                 ImageIcon(
          //                   AssetImage("${AppUI.iconPath}request.png",),size: 24,color: AppUI.borderColor,),
          //                 SizedBox(height: 8,),
          //                 CustomText(text: 'Requests',
          //                   fontSize: 12,
          //                   color: AppUI.borderColor,
          //                   fontWeight: FontWeight.w400,
          //                 )
          //               ],
          //             ),
          //             Column(
          //               children: [
          //                 ImageIcon(
          //                   AssetImage("${AppUI.iconPath}Caht.png",),size: 24,color: AppUI.borderColor,),
          //                 SizedBox(height: 8,),
          //                 CustomText(text: 'Messages',
          //                   fontSize: 12,
          //                   color: AppUI.borderColor,
          //                   fontWeight: FontWeight.w400,
          //                 )
          //               ],
          //             ),
          //             InkWell(
          //               onTap: () {
          //                 AppUtil.mainNavigator(context, ProfileScreen());
          //               },
          //               child: Column(
          //                 children: [
          //                   ImageIcon(
          //                     AssetImage("${AppUI.iconPath}profile.png",),size: 24,color: AppUI.borderColor,),
          //                   SizedBox(height: 8,),
          //                   CustomText(text: 'Profile',
          //                     fontSize: 12,
          //                     color: AppUI.borderColor,
          //                     fontWeight: FontWeight.w400,
          //                   )
          //                 ],
          //               ),
          //             ),
          //             Column(
          //               children: [
          //                 ImageIcon(
          //                     AssetImage(
          //                       "${AppUI.iconPath}menu.png",),size: 24,color: AppUI.borderColor),
          //                 SizedBox(height: 8,),
          //                 CustomText(text: 'Menu',
          //                   fontSize: 12,
          //                   color: AppUI.borderColor,
          //                   fontWeight: FontWeight.w400,
          //                 )
          //               ],
          //             )
          //           ],
          //         )
          //       ],),
          //   ),
          // ),
          // Container(
          //   height: 100,
          //   width:MediaQuery.of(context).size.width,
          //   color: AppUI.whiteColor,
          // ),
          Container(
            height: 180.h, //MediaQuery.of(context).padding.top + 191,
            width:MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100.r),
                  bottomRight: Radius.circular(100.r)),
              color: AppUI.whiteColor,
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 30, left: 16, right: 16),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25.h,horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        '${AppUI.imgPath}logo.png',
                        height: 23.h,
                        width: 100.w,
                        // fit: BoxFit.cover,
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, NotifactionScreenAdmin());
                        },
                        child: Icon(
                          Icons.notifications_outlined,
                          color: AppUI.borderColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ImageIcon(
                            AssetImage(
                              "${AppUI.iconPath}Home.png",
                            ),
                            size: 24,
                            color: AppUI.borderColor,
                            semanticLabel: 'Home',
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          CustomText(
                            text: 'Home',
                            fontSize: 12,
                            color: AppUI.borderColor,
                            fontWeight: FontWeight.w400,
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, RequestAdmin());
                        },
                        child: Column(
                          children: [
                            ImageIcon(
                              AssetImage(
                                "${AppUI.iconPath}request.png",
                              ),
                              size: 24,
                              color: AppUI.borderColor,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            CustomText(
                              text: 'Requests',
                              fontSize: 12,
                              color: AppUI.borderColor,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, MessagesScreenAdmin());
                        },
                        child: Column(
                          children: [
                            ImageIcon(
                              AssetImage(
                                "${AppUI.iconPath}Caht.png",
                              ),
                              size: 24,
                              color: AppUI.borderColor,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            CustomText(
                              text: 'Messages',
                              fontSize: 12,
                              color: AppUI.borderColor,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, ProfileScreenAdmin());
                        },
                        child: Column(
                          children: [
                            ImageIcon(
                              AssetImage(
                                "${AppUI.iconPath}profile.png",
                              ),
                              size: 24,
                              color: AppUI.borderColor,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            CustomText(
                              text: 'Profile',
                              fontSize: 12,
                              color: AppUI.borderColor,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, MenuScreenAdmin());
                        },
                        child: Column(
                          children: [
                            ImageIcon(
                                AssetImage(
                                  "${AppUI.iconPath}menu.png",
                                ),
                                size: 24,
                                color: AppUI.borderColor),
                            SizedBox(
                              height: 8,
                            ),
                            CustomText(
                              text: 'Menu',
                              fontSize: 12,
                              color: AppUI.borderColor,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          SizedBox(
            width: 600.w,
            height: 620.h,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          '${AppUI.imgPath}photo.png',
                          height: 31.h,
                          width: 30.w,
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 281.w,
                          height: 32.h,
                          child: CustomInput(
                            controller: TextEditingController(),
                            textInputType: TextInputType.visiblePassword,
                            hint: 'What’s on your mind?',
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: AppUI.buttonColor,
                              fontWeight: FontWeight.w400,
                            ),
                            fillColor: Colors.transparent,
                            borderColor: AppUI.whiteColor,
                            suffixIcon: SizedBox(
                              width: 90.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                      '${AppUI.iconPath}images.png',
                                    ),
                                    color: AppUI.buttonColor,
                                    size: 42,
                                  ),
                                  ImageIcon(
                                    AssetImage(
                                      '${AppUI.iconPath}point.png',
                                    ),
                                    color: AppUI.buttonColor,
                                    size: 42,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: 600.w,
                      height: 580.h,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 10,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Container(
                              width: 500.w,
                              height: 130.h,
                              decoration: BoxDecoration(
                                color: AppUI.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          '${AppUI.imgPath}photo.png',
                                          height: 31.h,
                                          width: 30.w,
                                          // fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: 'Olivier',
                                              fontSize: 12,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                  text: '16 Feb at 19:56',
                                                  fontSize: 12,
                                                  color: AppUI.basicColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Image.asset(
                                                  '${AppUI.imgPath}Group.png',
                                                  height: 10,
                                                  width: 10,
                                                  // fit: BoxFit.cover,
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    const CustomText(
                                      text:
                                      'Hello guys! Today, Hello guys! Today Hello guys! Today Hello guys! Today Hello guys! Today Hello guys! Today.Thank you!',
                                      fontSize: 10,
                                      color: AppUI.basicColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              '${AppUI.imgPath}eye 1.png',
                                              // height: 1,
                                              width: 12,
                                              // fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            CustomText(
                                              text: "23",
                                              fontSize: 10,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              '${AppUI.imgPath}arrow.png',
                                              height: 12,
                                              width: 12,
                                              // fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            CustomText(
                                              text: "7",
                                              fontSize: 10,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Image.asset(
                                              '${AppUI.imgPath}comment.png',
                                              height: 12,
                                              width: 12,
                                              // fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            CustomText(
                                              text: "5",
                                              fontSize: 10,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Image.asset(
                                              '${AppUI.imgPath}like.png',
                                              height: 12,
                                              width: 12,
                                              // fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            CustomText(
                                              text: "8",
                                              fontSize: 10,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Container(
                              width: 500.w,
                              height: 312.h,
                              decoration: BoxDecoration(
                                color: AppUI.whiteColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          '${AppUI.imgPath}photo.png',
                                          height: 31,
                                          width: 30,
                                          // fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: 'Olivier',
                                              fontSize: 12,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                  text: '16 Feb at 19:56',
                                                  fontSize: 12,
                                                  color: AppUI.basicColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Image.asset(
                                                  '${AppUI.imgPath}Group.png',
                                                  height: 10,
                                                  width: 10,
                                                  // fit: BoxFit.cover,
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    const CustomText(
                                      text:
                                      'Hello guys! Today, Hello guys! Today Hello guys! Today Hello guys! Today Hello guys! Today Hello guys! Today.Thank you!',
                                      fontSize: 10,
                                      color: AppUI.basicColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Image.asset(
                                      '${AppUI.imgPath}lab.png',
                                      height: 182,
                                      width: 370,
                                      fit: BoxFit.cover,
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              '${AppUI.imgPath}eye 1.png',
                                              height: 12,
                                              width: 12,
                                              // fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            CustomText(
                                              text: "23",
                                              fontSize: 10,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              '${AppUI.imgPath}arrow.png',
                                              height: 12,
                                              width: 12,
                                              // fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            CustomText(
                                              text: "7",
                                              fontSize: 10,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Image.asset(
                                              '${AppUI.imgPath}comment.png',
                                              height: 12,
                                              width: 12,
                                              // fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            CustomText(
                                              text: "5",
                                              fontSize: 10,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Image.asset(
                                              '${AppUI.imgPath}like.png',
                                              height: 12,
                                              width: 12,
                                              // fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            CustomText(
                                              text: "8",
                                              fontSize: 10,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]));
  }
}
