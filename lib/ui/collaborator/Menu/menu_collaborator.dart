import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/collaborator/Message/Message_colla.dart';
import 'package:co_spririt/ui/collaborator/Notifactions/notifictions_collaborator.dart';
import 'package:co_spririt/ui/collaborator/Profile/profile_collabrator.dart';
import 'package:co_spririt/ui/collaborator/requests/request_collaborator.dart';
import 'package:co_spririt/utils/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../core/app_util.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';

class MenuScreenCollaborators extends StatelessWidget {
  static const String routeName = 'Menu Screen Collaborator';

  const MenuScreenCollaborators({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),),
        leading: AppBarCustom(),
        ),
      body: Column(
        children: [
          CustomProfileUser(name: "Steven" ,role: "Collaborators"),
          CustomMenuCard(name:'Profile' ,onFunction:(){ AppUtil.mainNavigator(context,ProfileScreenColla());},),
          CustomMenuCard(name:'Notifications' ,onFunction:(){ Navigator.pushNamed(context, NotifactionScreenCollaborator.routName);},),
          CustomMenuCard(name:'Message' ,onFunction:(){ AppUtil.mainNavigator(context,MessagesScreenColla());},),
          CustomMenuCard(name:'Requests' ,onFunction:(){ Navigator.pushNamed(context, RequestCollaborator.routeName);},),
          CustomMenuCard(name:'Log out',color: AppColor.secondColor, onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},)
        ],
      ),
    );
  }
}
