import 'package:co_spririt/ui/admin/requests/request_admin.dart';
import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/utils/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../core/app_util.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';
import '../Message/Message_admin.dart';
import '../Notifactions/notifictionadmin.dart';
import '../Profile/profile_admin.dart';
import '../collaboratorsforadmin/collaborators_screen.dart';

class MenuScreenAdmin extends StatelessWidget {
  static const String routeName = 'Menu Screen Admin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),),
        leading: AppBarCustom(),
        ),
      body: Column(
        children: [
          CustomProfileUser(name: "Ray" ,role: "Admin"),
          CustomMenuCard(name:'Profile' ,onFunction:(){ AppUtil.mainNavigator(context,ProfileScreenAdmin());},),
          CustomMenuCard(name:'Collaborators' ,onFunction:(){ AppUtil.mainNavigator(context,CollaboratorsAdminScreen());},),
          CustomMenuCard(name:'Notifications' ,onFunction:(){ Navigator.pushNamed(context, NotifactionScreenAdmin.routName);},),
          CustomMenuCard(name:'Message' ,onFunction:(){ AppUtil.mainNavigator(context,MessagesScreenAdmin());},),
          CustomMenuCard(name:'Requests' ,onFunction:(){ Navigator.pushNamed(context, RequestAdmin.routeName);},),
          CustomMenuCard(name:'Log out',color: AppColor.secondColor, onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},)
        ],
      ),
    );
  }
}
