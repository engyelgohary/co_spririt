import 'package:co_spirit/ui/auth/login.dart';
import 'package:co_spirit/ui/om/AllUsers.dart';
import 'package:co_spirit/ui/om/Message/message_om.dart';
import 'package:co_spirit/ui/om/Message/oppy_om.dart';
import 'package:co_spirit/ui/om/dashboard.dart';
import 'package:co_spirit/ui/om/opportunity/AllOpportunities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/app_util.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';
import '../Notifications/notifications_om.dart';
import '../OAForSuperAdmin/oa_screen.dart';
import '../OWForSuperAdmin/ow_page.dart';
import '../collaboratorforsuperadmin/collaborators_screen.dart';

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
                AppUtil.mainNavigator(context, const AllOpportunities());
              },
            ),
            // CustomMenuCard(
            //   iconColor: OMColorScheme.mainColor,
            //   textColor: OMColorScheme.textColor,
            //   name: 'Opportunities Settings',
            //   onFunction: () {
            //     AppUtil.mainNavigator(context, const OpportunityDetectorSettings());
            //   },
            // ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Notifications',
              onFunction: () {
                AppUtil.mainNavigator(context, const NotificationScreenOM());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Message',
              onFunction: () {
                AppUtil.mainNavigator(context, const MessagesScreenOM());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Ask Oppy',
              onFunction: () {
                AppUtil.mainNavigator(context, const OppyOM());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'All Users',
              onFunction: () {
                AppUtil.mainNavigator(context, const AllUsersScreen());
              },
            ),

             CustomMenuCard(
               iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
               name: 'Opportunity Detectors',
               onFunction: () {
                AppUtil.mainNavigator(context, const CollaboratorsScreenForSuper());
              },
            ),

            // CustomMenuCard(
            //   iconColor: OMColorScheme.mainColor,
            //   textColor: OMColorScheme.textColor,
            //   name: 'Admins',
            //   onFunction: () {
            //     AppUtil.mainNavigator(context, const AdminScreenForSuper());
            //   },
            // ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Opportunity Analyzers',
        onFunction: () {
                AppUtil.mainNavigator(context, const OpportunityAnalyzersScreen());
               },
             ),
             CustomMenuCard(
               iconColor: OMColorScheme.mainColor,
               textColor: OMColorScheme.textColor,
               name: 'Opportunity Owners',
              onFunction: () {
                AppUtil.mainNavigator(context, const OpportunityOwnersScreen());
               },
             ),
            // CustomMenuCard(
            //   iconColor: OMColorScheme.mainColor,
            //   textColor: OMColorScheme.textColor,
            //   name: 'Clients',
            //   onFunction: () {
            //     AppUtil.mainNavigator(context, const ClientScreenfoSuper());
            //   },
            // ),

            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Log Out',
              enableDivider: false,
              onFunction: () {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
