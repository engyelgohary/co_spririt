import 'package:co_spirit/ui/auth/login.dart';
import 'package:co_spirit/ui/om/dashboard.dart';
import 'package:co_spirit/ui/om/Message/message_om.dart';
import 'package:co_spirit/ui/om/Notifications/notifications_om.dart';
import 'package:co_spirit/ui/om/requests/request_Superadmin.dart';
import 'package:flutter/material.dart';
import '../../../core/app_util.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';
import '../../admin/opportunities/opportunities_v2.dart';
import '../OAForSuperAdmin/oa_screen.dart';
import '../OWForSuperAdmin/ow_page.dart';
import '../adminforsuperadmin/admin_page.dart';
import '../clientsForSuperAdmin/client_screen.dart';
import '../collaboratorforsuperadmin/collaborators_screen.dart';
import '../opportunity/opportunity_detector_settings.dart';

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
              name: 'Collaborators',
              onFunction: () {
                AppUtil.mainNavigator(context, const CollaboratorsScreenForSuper());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Admins',
              onFunction: () {
                AppUtil.mainNavigator(context, const AdminScreenForSuper());
              },
            ),
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
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Clients',
              onFunction: () {
                AppUtil.mainNavigator(context, const ClientScreenfoSuper());
              },
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
              name: 'Notifications',
              onFunction: () {
                Navigator.pushNamed(context, NotificationScreenOM.routName);
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Message',
              onFunction: () {
                AppUtil.mainNavigator(context, const MessagesScreenSuperAdmin());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Requests',
              onFunction: () {
                Navigator.pushNamed(context, RequestSuperAdmin.routeName);
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Opportunities Settings',
              onFunction: () {
                AppUtil.mainNavigator(context, const OpportunityDetectorSettings());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Opportunities',
              onFunction: () {
                AppUtil.mainNavigator(context, const OpportunitiesV2());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Log out',
              onFunction: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
