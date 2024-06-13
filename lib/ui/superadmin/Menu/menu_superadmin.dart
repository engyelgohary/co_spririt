import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/superadmin/Message/Message_superadmin.dart';
import 'package:co_spririt/ui/superadmin/Notifactions/notifictions_superadmin.dart';
import 'package:co_spririt/ui/superadmin/Profile/profile_superadmin.dart';
import 'package:co_spririt/ui/superadmin/requests/request_Superadmin.dart';
import 'package:co_spririt/utils/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../core/app_util.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';
import '../adminforsuperadmin/admin_screen.dart';
import '../clientsForSuperAdmin/client_screen.dart';
import '../collaboratorforsuperadmin/collaborators_screen.dart';

class MenuScreenSuperAdmin extends StatelessWidget {
  static const String routeName = 'Menu Screen SuperAdmin';
  const MenuScreenSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),),
        leading: AppBarCustom(),
        ),
      body: Column(
        children: [
          CustomProfileUser(name: "Mat" ,role: "Super admin"),
          CustomMenuCard(name:'Profile' ,onFunction:(){AppUtil.mainNavigator(context,ProfileScreenSuperAdmin());},),
          CustomMenuCard(name:'Collaborators' ,onFunction:(){ AppUtil.mainNavigator(context,CollaboratorsScreenForSuper());},),
          CustomMenuCard(name:'Admins' ,onFunction:(){ AppUtil.mainNavigator(context,AdminScreenForSuper());},),
          CustomMenuCard(name:'Clients' ,onFunction:(){ AppUtil.mainNavigator(context,ClientScreenfoSuper());},),
          CustomMenuCard(name:'Notifications' ,onFunction:(){ Navigator.pushNamed(context, NotifactionScreenSuperAdmin.routName);},),
          CustomMenuCard(name:'Message' ,onFunction:(){ AppUtil.mainNavigator(context,MessagesScreenSuperAdmin());},),
          CustomMenuCard(name:'Requests' ,onFunction:(){ Navigator.pushNamed(context, RequestSuperAdmin.routeName);},),
          CustomMenuCard(name:'Log out',color: AppColor.secondColor, onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},)
        ],
      ),
    );
  }
}
