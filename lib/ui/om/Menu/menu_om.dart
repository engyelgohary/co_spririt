import 'package:co_spririt/test.dart';
import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/om/AllUsers.dart';
import 'package:co_spririt/ui/om/Dashboard.dart';
import 'package:co_spririt/ui/om/Message/Message_superadmin.dart';
import 'package:co_spririt/ui/om/Notifactions/notifictions_superadmin.dart';
import 'package:co_spririt/ui/om/opportunity/AllOpportunities.dart';
import 'package:co_spririt/ui/om/requests/request_Superadmin.dart';
import 'package:co_spririt/utils/components/appbar.dart';
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
              name: 'All Users',
              onFunction: () {
                AppUtil.mainNavigator(context, const AllUsersScreen());
              },
            ),
            CustomMenuCard(
              name: 'All Users',
              onFunction: () {
                AppUtil.mainNavigator(context, const AllUsersScreen());
              },
            ),
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
                AppUtil.mainNavigator(context, const AllOpportunities());
              },
            ),
            CustomMenuCard(
              iconColor: OMColorScheme.mainColor,
              textColor: OMColorScheme.textColor,
              name: 'Log out',
              enableDivider: false,
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
