import 'package:co_spririt/test.dart';
import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/om/Dashboard.dart';
import 'package:co_spririt/ui/om/Message/Message_superadmin.dart';
import 'package:co_spririt/ui/om/Notifactions/notifictions_superadmin.dart';
import 'package:co_spririt/ui/om/requests/request_Superadmin.dart';
import 'package:co_spririt/utils/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../core/app_util.dart';
import '../../../utils/components/MenuItem.dart';
import '../../admin/opportunities/opportunities_v2.dart';
import '../OAForSuperAdmin/OA_screen.dart';
import '../OWForSuperAdmin/OW_page.dart';
import '../adminforsuperadmin/admin_page.dart';
import '../clientsForSuperAdmin/client_screen.dart';
import '../collaboratorforsuperadmin/collaborators_screen.dart';
import '../opportunity/opportunity_detector_settings.dart';

class MenuScreenSuperAdmin extends StatelessWidget {
  static const String routeName = 'Menu Screen SuperAdmin';
  const MenuScreenSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: const AppBarCustom(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomMenuCard(
              name: 'Collaborators',
              onFunction: () {
                AppUtil.mainNavigator(context, const CollaboratorsScreenForSuper());
              },
            ),
            CustomMenuCard(
              name: 'Admins',
              onFunction: () {
                AppUtil.mainNavigator(context, AdminScreenForSuper());
              },
            ),
            CustomMenuCard(
              name: 'Opportunity Analyzers',
              onFunction: () {
                AppUtil.mainNavigator(context, OpportunityAnalyzersScreen());
              },
            ),
            CustomMenuCard(
              name: 'Opportunity Owners',
              onFunction: () {
                AppUtil.mainNavigator(context, OpportunityOwnersScreen());
              },
            ),
            CustomMenuCard(
              name: 'Clients',
              onFunction: () {
                AppUtil.mainNavigator(context, const ClientScreenfoSuper());
              },
            ),
            CustomMenuCard(
              name: 'Dashboard',
              onFunction: () {
                AppUtil.mainNavigator(context, Dashboard());
              },
            ),
            CustomMenuCard(
              name: 'Notifications',
              onFunction: () {
                Navigator.pushNamed(context, NotificationScreenSuperAdmin.routName);
              },
            ),
            CustomMenuCard(
              name: 'Message',
              onFunction: () {
                AppUtil.mainNavigator(context, const MessagesScreenSuperAdmin());
              },
            ),
            CustomMenuCard(
              name: 'Requests',
              onFunction: () {
                Navigator.pushNamed(context, RequestSuperAdmin.routeName);
              },
            ),
            CustomMenuCard(
              name: 'Opportunities Settings',
              onFunction: () {
                AppUtil.mainNavigator(context, const OpportunityDetectorSettings());
              },
            ),
            CustomMenuCard(
              name: 'Opportunities',
              onFunction: () {
                AppUtil.mainNavigator(context, const OpportunitiesV2());
              },
            ),
            CustomMenuCard(
              name: 'Test',
              onFunction: () {
                AppUtil.mainNavigator(context, TestPage());
              },
            ),
            CustomMenuCard(
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
