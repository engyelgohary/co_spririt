import 'package:co_spirit/data/dip.dart';
import 'package:co_spirit/ui/od/Message/Message_od.dart';
import 'package:co_spirit/ui/od/Notifactions/notifictions_od.dart';
import 'package:co_spirit/ui/od/Profile/profile_od.dart';
import 'package:co_spirit/ui/od/requests/request_collaborator.dart';
import 'package:co_spirit/ui/om/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';
import '../opportunities/opportunities_ow.dart';

class MenuScreenOW extends StatefulWidget {
  static const String routeName = 'Menu Screen Opportunity Manager';
  final String OWId;

  const MenuScreenOW({super.key, required this.OWId});

  @override
  State<MenuScreenOW> createState() => _MenuScreenOWState();
}

class _MenuScreenOWState extends State<MenuScreenOW> {
  late CollaboratorCubit adminCubit;

  @override
  void initState() {
    super.initState();
    adminCubit = CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository());
    adminCubit.fetchCollaboratorDetails(int.parse(widget.OWId));
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
          backArrowColor: OWColorScheme.buttonColor,
          textColor: OWColorScheme.mainColor,
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
                            style: const TextStyle(color: OWColorScheme.mainColor, fontSize: 18),
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
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    name: 'Profile',
                    onFunction: () {
                      AppUtil.mainNavigator(
                        context,
                        ProfileScreenOD(
                          collaboratorId: widget.OWId,
                        ),
                      );
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    name: 'Notifications',
                    onFunction: () {
                      Navigator.pushNamed(context, NotificationScreenOD.routName);
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    name: 'Message',
                    onFunction: () {
                      AppUtil.mainNavigator(context, const MessagesScreenOD());
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    name: 'Requests',
                    onFunction: () {
                      Navigator.pushNamed(context, RequestCollaborator.routeName);
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    enableDivider: false,
                    name: 'Opportunities',
                    onFunction: () => AppUtil.mainNavigator(context, const OpportunitiesPageOW()),
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
