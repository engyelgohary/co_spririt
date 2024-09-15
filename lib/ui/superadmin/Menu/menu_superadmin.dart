import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/superadmin/Message/Message_superadmin.dart';
import 'package:co_spririt/ui/superadmin/Notifactions/notifictions_superadmin.dart';
import 'package:co_spririt/ui/superadmin/requests/request_Superadmin.dart';
import 'package:co_spririt/utils/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../core/app_util.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';
import '../../admin/opportunities/opportunities_v2.dart';
import '../adminforsuperadmin/admin_page.dart';
import '../clientsForSuperAdmin/client_screen.dart';
import '../collaboratorforsuperadmin/collaborators_screen.dart';

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
      body: Column(
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
            name: 'Clients',
            onFunction: () {
              AppUtil.mainNavigator(context, const ClientScreenfoSuper());
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
            name: 'Opportunity',
            onFunction: () {
              AppUtil.mainNavigator(context, const OpportunitiesV2());
            },
          ),
          CustomMenuCard(
            name: 'Log out',
            color: AppColor.secondColor,
            onFunction: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
