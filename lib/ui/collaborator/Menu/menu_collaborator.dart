import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/collaborator/Message/Message_colla.dart';
import 'package:co_spririt/ui/collaborator/Notifactions/notifictions_collaborator.dart';
import 'package:co_spririt/ui/collaborator/Profile/profile_collabrator.dart';
import 'package:co_spririt/ui/collaborator/requests/request_collaborator.dart';
import 'package:co_spririt/ui/superadmin/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:co_spririt/utils/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';
import '../opportunities/add_opportunities.dart';
import '../opportunities/opportunities.dart';

class MenuScreenCollaborators extends StatefulWidget {
  static const String routeName = 'Menu Screen Collaborator';
  final String CollaboratorId;

  MenuScreenCollaborators({required this.CollaboratorId});

  @override
  State<MenuScreenCollaborators> createState() => _MenuScreenCollaboratorsState();
}

class _MenuScreenCollaboratorsState extends State<MenuScreenCollaborators> {
  late CollaboratorCubit adminCubit;

  @override
  void initState() {
    super.initState();
    adminCubit = CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository());
    adminCubit.fetchCollaboratorDetails(int.parse(widget.CollaboratorId));
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
        body: BlocBuilder<CollaboratorCubit, CollaboratorState>(
          builder: (context, state) {
            if (state is CollaboratorLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CollaboratorSuccess) {
              final collaborator = state.collaboratorData;
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
                            image: _getImageProvider(collaborator!.pictureLocation),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      title: Text(
                        collaborator.firstName ?? "N/A",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 17),
                      ),
                      subtitle: Text(
                        "Collaborator",
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
                      AppUtil.mainNavigator(
                        context,
                        ProfileScreenColla(
                          collaboratorId: widget.CollaboratorId,
                        ),
                      );
                    },
                  ),
                  CustomMenuCard(
                    name: 'Notifications',
                    onFunction: () {
                      Navigator.pushNamed(context, NotificationScreenCollaborator.routName);
                    },
                  ),
                  CustomMenuCard(
                    name: 'Message',
                    onFunction: () {
                      AppUtil.mainNavigator(context, MessagesScreenColla());
                    },
                  ),
                  CustomMenuCard(
                    name: 'Opportunities',
                    onFunction: () {
                      AppUtil.mainNavigator(context, OpportunitiesScreenColla());
                    },
                  ),
                  CustomMenuCard(
                    name: 'Requests',
                    onFunction: () {
                      Navigator.pushNamed(context, RequestCollaborator.routeName);
                    },
                  ),
                  CustomMenuCard(
                    name: 'Opportunities V2',
                    onFunction: () {
                      AppUtil.mainNavigator(context, AddOpportunitiesV2());
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
              );
            } else if (state is CollaboratorError) {
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
