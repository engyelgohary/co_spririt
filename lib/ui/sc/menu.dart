import 'package:co_spirit/data/dip.dart';
import 'package:co_spirit/ui/od/Message/Message_od.dart';
import 'package:co_spirit/ui/od/Message/oppy_od.dart';
import 'package:co_spirit/ui/od/Notifications/notifications_od.dart';
import 'package:co_spirit/ui/od/Profile/profile_od.dart';
import 'package:co_spirit/ui/od/opportunities/scores_od.dart';
import 'package:co_spirit/ui/om/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:co_spirit/ui/sc/raci_view.dart';
import 'package:co_spirit/ui/sc/raci_view_old.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';

class MenuScreenSC extends StatefulWidget {
  static const String routeName = 'Menu Screen Collaborator';
  final String ODId;

  const MenuScreenSC({super.key, required this.ODId});

  @override
  State<MenuScreenSC> createState() => _MenuScreenSCState();
}

class _MenuScreenSCState extends State<MenuScreenSC> {
  late CollaboratorCubit adminCubit;

  @override
  void initState() {
    super.initState();
    adminCubit = CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository());
    adminCubit.fetchCollaboratorDetails(int.parse(widget.ODId));
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
          backArrowColor: ODColorScheme.buttonColor,
          textColor: ODColorScheme.mainColor,
        ),
        body: BlocBuilder<CollaboratorCubit, CollaboratorState>(
          builder: (context, state) {
            if (state is CollaboratorLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: ODColorScheme.buttonColor));
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
                            style: const TextStyle(color: ODColorScheme.mainColor, fontSize: 18),
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
                  const SizedBox(height: 16),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    name: 'Home',
                    onFunction: () => Navigator.of(context).pop(),
                  ),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    name: 'RACI',
                    onFunction: () => AppUtil.mainNavigator(context, RACIViewPageSC()),
                  ),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    name: 'RACI_old',
                    onFunction: () => AppUtil.mainNavigator(context, RACIPageSCold()),
                  ),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    name: 'Scores',
                    onFunction: () => AppUtil.mainNavigator(context, const ScoresPageOD()),
                  ),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    name: 'Notifications',
                    onFunction: () => AppUtil.mainNavigator(context, const NotificationScreenOD()),
                  ),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    name: 'Message',
                    onFunction: () {
                      AppUtil.mainNavigator(context, const MessagesScreenOD());
                    },
                  ),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    name: 'Ask Oppy',
                    onFunction: () {
                      AppUtil.mainNavigator(context, OppyOD());
                    },
                  ),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    enableDivider: false,
                    name: 'Profile & Settings',
                    onFunction: () {
                      AppUtil.mainNavigator(
                        context,
                        ProfileScreenOD(
                          collaboratorId: widget.ODId,
                        ),
                      );
                    },
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
