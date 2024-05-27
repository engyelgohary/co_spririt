import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import 'drop_down_client_item.dart';



class AssignToClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          height: 155,
          // width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(

                  height: 155,
                  width: 310,
                  //MediaQuery.of(context).size.width,
                  color: AppUI.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AssignToClient();
                                });
                          },
                          child: CustomText(
                            text: 'Select Client',
                            fontSize: 15,
                            color: AppUI.basicColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        DropDownClientItem(),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              text: 'Cancel',
                              color: AppUI.buttonColor,
                              textColor: AppUI.textButtonColor,
                              width: 110,
                              height: 35,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CustomButton(
                              text: 'Assign',
                              color: AppUI.secondColor,
                              textColor: AppUI.whiteColor,
                              width: 110,
                              height: 35,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        // Center(
        //   child: OutlinedButton(
        //     onPressed: () => _dialogBuilder(context),
        //     child: const Text('Open Dialog'),
        //   ),
        // ),
      ),
    );
  }}