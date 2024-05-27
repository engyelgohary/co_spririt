import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';



class AddCollaboratorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUI.whiteColor,
      body: Column(
        children: [
          Center(
            child: Image.asset(
              '${AppUI.imgPath}addphoto.png',
              height: 117,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              CustomText(
                text: 'Frist Name :',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              Container(
                width: 230,
                height: 32,
                child: CustomInput(
                    controller: TextEditingController(),
                    textInputType: TextInputType.text),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              CustomText(
                text: 'Mobile : ',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              Container(
                width: 230,
                height: 32,
                child: CustomInput(
                    controller: TextEditingController(),
                    textInputType: TextInputType.number),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              CustomText(
                text: 'E-mail :',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              Container(
                width: 230,
                height: 32,
                child: CustomInput(
                    controller: TextEditingController(),
                    textInputType: TextInputType.emailAddress),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              CustomText(
                text: 'Assigned To ',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              Container(
                width: 230,
                height: 32,
                child: CustomInput(
                    controller: TextEditingController(),
                    textInputType: TextInputType.text),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              CustomText(
                text: 'Client :',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              Container(
                width: 230,
                height: 32,
                child: CustomInput(
                    controller: TextEditingController(),
                    textInputType: TextInputType.text),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              CustomText(
                text: 'Admin :',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              Container(
                width: 230,
                height: 32,
                child: CustomInput(
                    controller: TextEditingController(),
                    textInputType: TextInputType.text),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              CustomText(
                text: 'Status :',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              Container(
                width: 230,
                height: 32,
                child: CustomInput(
                    controller: TextEditingController(),
                    textInputType: TextInputType.text),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Contract info :',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 160,
                    height: 32,
                    child: CustomInput(
                        controller: TextEditingController(),
                        textInputType: TextInputType.text),
                  ),
                  CustomText(
                    text: 'To',
                    fontSize: 18,
                    color: AppUI.basicColor,
                    fontWeight: FontWeight.w700,
                  ),
                  Container(
                    width: 160,
                    height: 32,
                    child: CustomInput(
                        controller: TextEditingController(),
                        textInputType: TextInputType.text),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Last communication :',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Container(
                // width: 230,
                height: 32,
                child: CustomInput(
                    controller: TextEditingController(),
                    textInputType: TextInputType.text),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Client Company Categories',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Container(
                // width: 230,
                height: 32,
                child: CustomInput(
                    controller: TextEditingController(),
                    textInputType: TextInputType.text),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              CustomText(
                text: 'CV',
                fontSize: 18,
                color: AppUI.basicColor,
                fontWeight: FontWeight.w700,
              ),
              Spacer(),
              CustomButton(
                text: 'Upload',
                color: AppUI.secondColor,
                textColor: AppUI.whiteColor,
                width: 135,
                height: 35,
              )
            ],
          ),
          Spacer(),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: 'Cancel',
                  color: AppUI.buttonColor,
                  textColor: AppUI.textButtonColor,
                  width: 135,
                  height: 35,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CustomButton(
                  text: 'Create',
                  color: AppUI.secondColor,
                  textColor: AppUI.whiteColor,
                  width: 135,
                  height: 35,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
