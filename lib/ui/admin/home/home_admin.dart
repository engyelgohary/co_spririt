import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../superadmin/home/creat_post.dart';
import '../Menu/menu_admin.dart';
import '../Message/Message_admin.dart';
import '../Notifactions/notifictionadmin.dart';
import '../Profile/profile_admin.dart';
import '../requests/request_admin.dart';

class HomeScreenAdmin extends StatelessWidget {
  static String routeName = 'home screen admin';
  String adminId;
  HomeScreenAdmin({required this.adminId});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Column(children: [
          Stack(
            children:[
              Image.asset(
                '${AppUI.imgPath}Rectangle 15.png',
                height: 191.h,
                width: 375.w,
                fit: BoxFit.fill,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          '${AppUI.imgPath}logo.png',
                          height: 28.h,
                          width: 100.w,
                          // fit: BoxFit.cover,
                        ),
                        InkWell(
                          onTap: () {
                            AppUtil.mainNavigator(context, NotifactionScreenAdmin());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 13.w),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: AppUI.borderColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ImageIcon(
                            AssetImage(
                              "${AppUI.iconPath}Home.png",
                            ),
                            size: 24,
                            color: AppUI.secondColor,
                            semanticLabel: 'Home',
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          CustomText(
                            text: 'Home',
                            fontSize: 12,
                            color: AppUI.secondColor,
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
                          AppUtil.mainNavigator(context, ProfileScreenAdmin(adminId: adminId,));
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
                          AppUtil.mainNavigator(context, MenuScreenAdmin(adminId:adminId,));
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
            ],
          ),
          // ),
          // ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 15.w),
                  child: Row(
                    children: [
                      Image.asset(
                        '${AppUI.imgPath}photo.png',
                        height: 31.h,
                        width: 30.w,
                        // fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      InkWell(
                        onTap: (){
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.vertical(
                                    top: Radius.circular(
                                        20.0)),
                              ),
                              constraints: BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomCard(
                                    child:
                                    CreatePost(),
                                    height:
                                    MediaQuery.sizeOf(context)
                                        .height *
                                        .8,
                                    radius: 20,
                                  )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppUI.whiteColor
                          ),
                          width: 281.w,
                          height: 32.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width:10.w),
                              Text("What's in your mind",style: TextStyle(
                                fontSize: 12,
                                color: AppUI.buttonColor,
                                fontWeight: FontWeight.w400,
                              ),),
                              SizedBox(width: 140.w,),
                              Image.asset(
                                '${AppUI.iconPath}images.png',
                                width: 12.w,
                                height: 12.h,
                              ),
                              SizedBox(width:10.w),
                              Image.asset(
                                '${AppUI.iconPath}point.png',
                                width: 12.w,
                                height: 12.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10,top: 7),
                  child: Container(
                    width: 600.w,
                    height: 570.h,
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
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
