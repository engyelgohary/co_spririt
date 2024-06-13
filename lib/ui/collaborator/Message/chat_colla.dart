import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';


class ChatScreenColla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
              height: 135,
              decoration: BoxDecoration(
                  color: AppUI.whiteColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                            text: 'Massages',
                            fontSize: 20,
                            color: AppUI.basicColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppUI.secondColor),
                          child: ImageIcon(
                            AssetImage(
                              '${AppUI.iconPath}chatmenu.png',
                            ),
                            color: AppUI.whiteColor,
                            size: 42,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          '${AppUI.imgPath}photo.png',
                          height: 41,
                          width: 42,
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Container(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Matteo',
                                fontSize: 16,
                                color: AppUI.basicColor,
                                fontWeight: FontWeight.w700,
                              ),
                              CustomText(
                                text: 'MR@gmail,com',
                                fontSize: 12,
                                color: AppUI.basicColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: CustomInput(
                      borderColor: Color.fromRGBO(241, 241, 241, 1),
                      fillColor: Color.fromRGBO(241, 241, 241, 1),
                      //counterColor: AppUI.borderColor,
                      //radius: 24,
                      controller: TextEditingController(),
                      hint: "Type a message ...",
                      textInputType: TextInputType.text,
                      suffixIcon: SizedBox(
                        width: 55,
                        child: Row(
                          children: [
                            ImageIcon(
                              AssetImage(
                                '${AppUI.iconPath}file.png',
                              ),
                              color: AppUI.twoBasicColor,
                              size: 20,
                            ),
                            SizedBox(width: 8,),
                            ImageIcon(
                              AssetImage(
                                '${AppUI.iconPath}chatcamera.png',
                              ),
                              color: AppUI.twoBasicColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppUI.secondColor),
                    child: ImageIcon(
                      AssetImage(
                        '${AppUI.iconPath}send.png',
                      ),
                      color: AppUI.whiteColor,
                      size: 42,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
