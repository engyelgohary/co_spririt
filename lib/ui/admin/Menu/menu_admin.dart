import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/dip.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';
import '../../auth/login.dart';
import '../../superadmin/adminforsuperadmin/Cubit/admin_cubit.dart';
import '../Message/Message_admin.dart';
import '../Notifactions/notifictionadmin.dart';
import '../Profile/profile_admin.dart';
import '../collaboratorsforadmin/collaborators_screen.dart';
import '../opportunities/opportunities.dart';
import '../opportunities/opportunities_v2.dart';
import '../requests/request_admin.dart';

class MenuScreenAdmin extends StatefulWidget {
  static const String routeName = 'Menu Screen Admin';
  final String adminId;

  MenuScreenAdmin({required this.adminId});

  @override
  State<MenuScreenAdmin> createState() => _MenuScreenAdminState();
}

class _MenuScreenAdminState extends State<MenuScreenAdmin> {
  late AdminCubit adminCubit;

  @override
  void initState() {
    super.initState();
    adminCubit = AdminCubit(adminRepository: injectAdminRepository());
    adminCubit.fetchAdminDetails(int.parse(widget.adminId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => adminCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Menu',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
          ),
          leading: AppBarCustom(),
        ),
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AdminSuccess) {
              final admin = state.adminData;
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20.h),
                    child: ListTile(
                      leading: Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _getImageProvider(admin!.pictureLocation),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      title: Text(
                        admin.firstName ?? "N/A",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 17),
                      ),
                      subtitle: Text(
                        "Admin",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColor.borderColor,
                            ),
                      ),
                    ),
                  ),
                  CustomMenuCard(
                    name: 'Profile',
                    onFunction: () {
                      AppUtil.mainNavigator(context, ProfileScreenAdmin(adminId: widget.adminId));
                    },
                  ),
                  CustomMenuCard(
                    name: 'Collaborators',
                    onFunction: () {
                      AppUtil.mainNavigator(context, CollaboratorsAdminScreen());
                    },
                  ),
                  CustomMenuCard(
                    name: 'Notifications',
                    onFunction: () {
                      Navigator.pushNamed(context, NotificationScreenAdmin.routName);
                    },
                  ),
                  CustomMenuCard(
                    name: 'Message',
                    onFunction: () {
                      AppUtil.mainNavigator(context, MessagesScreenAdmin());
                    },
                  ),
                  CustomMenuCard(
                    name: 'Opportunities',
                    onFunction: () {
                      AppUtil.mainNavigator(context, OpportunitiesScreenAdmin());
                    },
                  ),
                  CustomMenuCard(
                    name: 'Requests',
                    onFunction: () {
                      Navigator.pushNamed(context, RequestAdmin.routeName);
                    },
                  ),
                  CustomMenuCard(
                    name: 'Opportunities  v2',
                    onFunction: () {
                      AppUtil.mainNavigator(context, OpportunitiesV2());
                    },
                  ),
                  CustomMenuCard(
                    name: 'Log out',
                    color: AppColor.secondColor,
                    onFunction: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                  ),
                ],
              );
            } else if (state is AdminError) {
              return Center(child: Text(state.errorMessage ?? ''));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  ImageProvider<Object> _getImageProvider(String? pictureLocation) {
    if (pictureLocation != null && pictureLocation.isNotEmpty) {
      return NetworkImage('http://${ApiConstants.baseUrl}$pictureLocation');
    } else {
      return AssetImage('assets/images/Rectangle 5.png');
    }
  }
}
