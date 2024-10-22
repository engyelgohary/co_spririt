import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/menu_item.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/ui/dashboard.dart';
import 'package:co_spirit/ui/messages/message_screen.dart';
import 'package:co_spirit/ui/notifications/om_notifications.dart';
import 'package:co_spirit/ui/opportunities/opportunities_om.dart';
import 'package:co_spirit/ui/oppy/oppy.dart';
import 'package:co_spirit/ui/profile/profile_om.dart';
import 'package:flutter/material.dart';
import '../../core/app_util.dart';

class MenuScreenOM extends StatelessWidget {
  static const String routeName = 'Menu Screen Opportunity Manager';
  const MenuScreenOM({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Menu",
        context: context,
        backArrowColor: OMColorScheme.mainColor,
        textColor: OMColorScheme.textColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Home',
              onFunction: () => Navigator.of(context).pop(),
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Dashboard',
              onFunction: () {
                AppUtil.mainNavigator(context, const Dashboard());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Opportunities',
              onFunction: () {
                AppUtil.mainNavigator(context, const OpportunitiesPageOM());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Notifications',
              onFunction: () {
                AppUtil.mainNavigator(
                  context,
                  const OMNotificationScreen(
                    buttonColor: OMColorScheme.buttonColor,
                    mainColor: OMColorScheme.mainColor,
                  ),
                );
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Message',
              onFunction: () {
                AppUtil.mainNavigator(
                    context,
                    const MessagesScreen(
                      mainColor: OMColorScheme.mainColor,
                      buttonColor: OMColorScheme.buttonColor,
                      textColor: OMColorScheme.textColor,
                    ));
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Ask Oppy',
              onFunction: () {
                AppUtil.mainNavigator(
                  context,
                  OppyScreen(
                    mainColor: OMColorScheme.mainColor,
                    buttonColor: OMColorScheme.buttonColor,
                    textColor: OMColorScheme.textColor,
                  ),
                );
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Profile & Settings',
              enableDivider: false,
              onFunction: () {
                AppUtil.mainNavigator(context, const ProfileScreenOM());
              },
            ),
          ],
        ),
      ),
    );
  }
}
