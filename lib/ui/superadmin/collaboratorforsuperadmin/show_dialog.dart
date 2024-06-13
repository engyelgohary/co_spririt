
import 'package:flutter/material.dart';
import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import 'assign_to_admin.dart';
import 'assign_to_client.dart';

class DialogPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          height: 80,
          // width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: 80,
                  width: 140,
                  //MediaQuery.of(context).size.width,
                  color: AppUI.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AssignToAdmin();
                                });
                          },
                          child: CustomText(
                            text: 'Assign to admin',
                            fontSize: 12,
                            color: AppUI.borderColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AssignToClient();
                                });
                          },
                          child: CustomText(
                            text: 'Assign to Client',
                            fontSize: 12,
                            color: AppUI.borderColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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
  }
 }
