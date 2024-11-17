import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OdSettings extends StatelessWidget {
  const OdSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child :Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("Profile Settings: ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
              ],
            ),
          ],
        ),
      ),
    ),);
  }
}
