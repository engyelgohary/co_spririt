import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import 'colllaborator_details.dart';


class CollaboratorsAdminScreen extends StatelessWidget {

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
                  width: 100.w,
                ),
                Center(
                  child: CustomText(
                    text: 'Collaborators',
                    fontSize: 20,
                    color: AppUI.basicColor,
                    fontWeight: FontWeight.w400,
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
                  itemBuilder: (context, index) => Column(
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
                                const SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  width: 100.w,
                                  child: const Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Matteo',
                                        fontSize: 15,
                                        color: AppUI.basicColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      Row(
                                        children: [
                                          CustomText(
                                            text: 'Client1 / ',
                                            fontSize: 12,
                                            color: AppUI.basicColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          CustomText(
                                            text: 'Status 2',
                                            fontSize: 12,
                                            color: AppUI.errorColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Container(
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
                                          '${AppUI.iconPath}Caht.png',
                                        ),
                                        color: AppUI.secondColor,
                                        size: 14,
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
                                             // maxHeight: double.infinity,
                                            ),
                                            // scrollControlDisabledMaxHeightRatio:
                                            // 1,
                                            builder: (context) => Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: CustomCard(
                                                  child:
                                                  CollaboratorAdminDetails(),
                                                  // height:
                                                  // MediaQuery.sizeOf(context)
                                                  //     .height *
                                                  //     .8,
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
                )),
          ],
        ),
      ),
    );
  }
}
