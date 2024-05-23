import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/collaborator/Notifactions/notifictionsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';

class MenuScreenCollaborators extends StatelessWidget {
  static const String routeName = 'Menu Screen';

  const MenuScreenCollaborators({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),),
        leading: Padding(
          padding:  EdgeInsets.only(left: 1.w),
          child: IconButton(
            icon: CircleAvatar(
              radius: 25.r, // Adjust the radius as needed
              backgroundColor: AppColor.secondColor,
              child:  Padding(
                padding:  EdgeInsets.only(left: 4.w),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        ),
      body: Column(
        children: [
          CustomProfileUser(name: "Steven" ,role: "Collaborators"),
          CustomMenuCard(name:'Profile' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Notifications' ,onFunction:(){ Navigator.pushNamed(context, NotifactionScreenCollaborator.routName);},),
          CustomMenuCard(name:'Message' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Requests' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Log out',color: AppColor.secondColor, onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},)
        ],
      ),
    );
  }
}
