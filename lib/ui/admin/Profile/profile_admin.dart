import 'package:flutter/material.dart';
import '../../../core/app_ui.dart';
import '../../../core/components.dart';

class ProfileScreenAdmin extends StatelessWidget {
  const ProfileScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppUI.secondColor),
                  child: const BackButton(
                    color: AppUI.whiteColor,
                  ),
                ),
                const Center(
                  child: CustomText(
                    text: 'Profile',
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
                  child: const ImageIcon(
                    AssetImage(
                      '${AppUI.iconPath}edit.png',
                    ),
                    color: AppUI.whiteColor,
                    size: 42,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: Image.asset(
                    '${AppUI.imgPath}profilephoto.png',
                    height: 98,
                    width: 98,
                    // fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppUI.secondColor),
                  child: const ImageIcon(
                    AssetImage(
                      '${AppUI.iconPath}camera.png',
                    ),
                    color: AppUI.whiteColor,
                    size: 42,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Column(
              children: [
                CustomText(
                  text: 'Olivier Matteo',
                  fontSize: 17,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
                CustomText(
                  text: 'Super Admin',
                  fontSize: 17,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            // SizedBox(height: 40,),

            SizedBox(
              height: 400,
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const CustomText(
                      text: 'Full Name',
                      fontSize: 16,
                      color: AppUI.basicColor,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomInput(
                      controller: TextEditingController(),
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const CustomText(
                      text: 'Email Address',
                      fontSize: 16,
                      color: AppUI.basicColor,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomInput(
                      controller: TextEditingController(),
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const CustomText(
                      text: 'Password',
                      fontSize: 16,
                      color: AppUI.basicColor,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomInput(
                      controller: TextEditingController(),
                      textInputType: TextInputType.visiblePassword,
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
