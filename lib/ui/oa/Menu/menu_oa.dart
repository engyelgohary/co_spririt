import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/ui/od/Message/Message_od.dart';
import 'package:co_spririt/ui/od/Notifactions/notifictions_od.dart';
import 'package:co_spririt/ui/od/Profile/profile_od.dart';
import 'package:co_spririt/ui/od/requests/request_collaborator.dart';
import 'package:co_spririt/ui/om/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:co_spririt/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';
import '../opportunities/opportunities_oa.dart';

class MenuScreenOA extends StatefulWidget {
  static const String routeName = 'Menu Screen Opportunity Analyzer';
  final String OAId;

  MenuScreenOA({required this.OAId});

  @override
  State<MenuScreenOA> createState() => _MenuScreenOAState();
}

class _MenuScreenOAState extends State<MenuScreenOA> {
  late CollaboratorCubit adminCubit;

  @override
  void initState() {
    super.initState();
    adminCubit = CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository());
    adminCubit.fetchCollaboratorDetails(int.parse(widget.OAId));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => adminCubit,
      child: Scaffold(
        appBar: customAppBar(
          title: "Menu",
          context: context,
          backArrowColor: OAColorScheme.buttonColor,
          textColor: OAColorScheme.mainColor,
        ),
        body: BlocBuilder<CollaboratorCubit, CollaboratorState>(
          builder: (context, state) {
            if (state is CollaboratorLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CollaboratorSuccess) {
              final collaborator = state.collaboratorData;
              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: width / 20,
                          right: 20,
                        ),
                        child: ODPhoto(collaborator!.pictureLocation, 75, 75),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            collaborator.firstName ?? "N/A",
                            style: const TextStyle(color: OAColorScheme.mainColor, fontSize: 18),
                          ),
                          Text(
                            "Opportunity Detector",
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: AppColor.borderColor,
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Profile',
                    onFunction: () {
                      AppUtil.mainNavigator(
                        context,
                        ProfileScreenOD(
                          collaboratorId: widget.OAId,
                        ),
                      );
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Notifications',
                    onFunction: () {
                      Navigator.pushNamed(context, NotificationScreenOD.routName);
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Message',
                    onFunction: () {
                      AppUtil.mainNavigator(context, const MessagesScreenOD());
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Requests',
                    onFunction: () {
                      Navigator.pushNamed(context, RequestCollaborator.routeName);
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Opportunities',
                    onFunction: () => AppUtil.mainNavigator(context, const OpportunitiesPageOA()),
                  ),
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
      return const AssetImage('assets/images/Rectangle 5.png');
    }
  }
}
