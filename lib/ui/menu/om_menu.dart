import 'package:co_spirit/core/app_ui.dart';
import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/menu_item.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/ui/dashboard.dart';
import 'package:co_spirit/ui/messages/messages.dart';
import 'package:co_spirit/ui/notifications/notifications.dart';
import 'package:co_spirit/ui/opportunities/opportunities.dart';
import 'package:co_spirit/ui/oppy/oppy.dart';
import 'package:co_spirit/ui/profile/om_profile.dart';
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
              colorMap: omColorMap,
              name: 'Home',
              onFunction: () => Navigator.of(context).pop(),
            ),
            CustomMenuCard(
              colorMap: omColorMap,
              name: 'Dashboard',
              onFunction: () {
                AppUtil.mainNavigator(context, const Dashboard());
              },
            ),
            CustomMenuCard(
              colorMap: omColorMap,
              name: 'Opportunities',
              onFunction: () {
                AppUtil.mainNavigator(
                    context, const OpportunitiesPage(colorMap: omColorMap, userType: 0));
              },
            ),
            CustomMenuCard(
              colorMap: omColorMap,
              name: 'Notifications',
              onFunction: () {
                AppUtil.mainNavigator(context, const NotificationScreen(colorMap: oaColorMap));
              },
            ),
            CustomMenuCard(
              colorMap: omColorMap,
              name: 'Message',
              onFunction: () {
                AppUtil.mainNavigator(
                    context,
                    const MessagesScreen(
                      colorMap: omColorMap,
                    ));
              },
            ),
            CustomMenuCard(
              colorMap: omColorMap,
              name: 'Ask Oppy',
              onFunction: () {
                AppUtil.mainNavigator(
                  context,
                  const OppyScreen(
                    mainColor: OMColorScheme.mainColor,
                    buttonColor: OMColorScheme.buttonColor,
                    textColor: OMColorScheme.textColor,
                  ),
                );
              },
            ),
            CustomMenuCard(
              colorMap: omColorMap,
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
