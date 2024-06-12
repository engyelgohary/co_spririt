import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';

class CreatePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
       Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             children: [
               CloseButtonIcon(
               ),
               SizedBox(width: 4,),
               CustomText(
                 text: 'Creat post',
                 fontSize: 14,
                 color: AppUI.blackColor,
                 fontWeight: FontWeight.w400,
               ),
             ],
           ),
           SizedBox(
             height: 15,
           ),
           Divider(
             thickness: 3,
           ),
           SizedBox(
             height: 15,
           ),
           Column(
             children: [
               CustomText(
                 text: 'Lorem ipsum dolor sit',
                 fontSize: 20,
                 color: AppUI.blackColor,
                 fontWeight: FontWeight.w600,
               ),
               CustomText(
                 text: 'amet, consectetur?',
                 fontSize: 20,
                 color: AppUI.blackColor,
                 fontWeight: FontWeight.w600,
               ),
             ],
           ),
           Spacer(),
           Row(
             children: [
               Expanded(
                   child: CustomInput(
                     borderColor: Color.fromRGBO(241, 241, 241, 1),
                     fillColor: Color.fromRGBO(241, 241, 241, 1),
                     //counterColor: AppUI.borderColor,
                     //radius: 24,
                     controller: TextEditingController(),
                     hint: "What’s on your mind?",
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
         ],
       );
  }
}
