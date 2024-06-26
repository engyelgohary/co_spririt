
import 'package:co_spririt/ui/superadmin/Message/chat_superadmin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';



class MessagesScreenSuperAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
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
                SizedBox(
                  width: 100,
                ),
                Center(
                  child: CustomText(
                    text: 'Massages',
                    fontSize: 20,
                    color: AppUI.basicColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 680.h,
              width: 600.w,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 18,
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, ChatScreenSuperAdmin());
                        },
                        child: Container(
                          height: 60,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    '${AppUI.imgPath}photo.png',
                                    height: 41,
                                    width: 42,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Container(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: 'Matteo',
                                          fontSize: 15,
                                          color: AppUI.basicColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        CustomText(
                                          text: 'Lorem ipsum dolor sit amet .....',
                                          fontSize: 12,
                                          color: AppUI.basicColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 29,
                                    width: 29,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: AppUI.secondColor),
                                    child: CustomText(
                                      text: '3',
                                      fontSize: 15,
                                      color: AppUI.whiteColor,
                                      fontWeight: FontWeight.w400,
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
