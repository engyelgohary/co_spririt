import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/utils/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';
import '../Notifactions/notifictionadmin.dart';

class MenuScreenAdmin extends StatelessWidget {
  static const String routeName = 'Menu Screen';
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
          CustomMenuCard(name:'Profile' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Collaborators' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Notifications' ,onFunction:(){ Navigator.pushNamed(context, NotifactionScreenAdmin.routName);},),
          CustomMenuCard(name:'Message' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Requests' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Log out',color: AppColor.secondColor, onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},)
        ],
      ),
    );
  }
}
