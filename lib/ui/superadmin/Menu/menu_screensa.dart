import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/superadmin/Notifactions/notifictionsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';

class MenuScreenSuperAdmin extends StatelessWidget {
  static const String routeName = 'Menu Screen';
  const MenuScreenSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),),
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: IconButton(
            icon: CircleAvatar(
             radius: 20, // Adjust the radius as needed
             backgroundColor: AppColor.secondColor,
             child:  Icon(
                 Icons.arrow_back_ios,
                 color: Colors.white,
                 size: 13,
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
          Container(
            padding: EdgeInsets.only(top: 25.h),
            child: ListTile(
              leading:  CircleAvatar(
                backgroundColor: AppColor.secondColor,
                radius:35.r,
              ),
              title: Text('Matteo',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 17)),
              subtitle:  Padding(
                padding:  EdgeInsets.only(top: 8.h),
                child: Text('Super Admin',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 12,color: AppColor.borderColor)),
              ),
            )
            ),
          CustomMenuCard(name:'Profile' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Collaborators' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Admins' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Clients' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Notifications' ,onFunction:(){ Navigator.pushNamed(context, NotifactionScreenSuperAdmin.routName);},),
          CustomMenuCard(name:'Message' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Requests' ,onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},),
          CustomMenuCard(name:'Log out',color: AppColor.secondColor, onFunction:(){ Navigator.pushNamed(context, LoginScreen.routeName);},)
        ],
      ),
    );
  }
}
