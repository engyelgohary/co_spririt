import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/menu_item.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:co_spirit/core/Cubit/collaborator_cubit.dart';
import 'package:co_spirit/ui/messages/message_screen.dart';
import 'package:co_spirit/ui/notifications/od_notifications.dart';
import 'package:co_spirit/ui/opportunities/od_opportunities.dart';
import 'package:co_spirit/ui/opportunities/od_scores.dart';
import 'package:co_spirit/ui/oppy/oppy.dart';
import 'package:co_spirit/ui/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';

class ODMenu extends StatefulWidget {
  static const String routeName = 'Menu Screen Collaborator';
  final String ODId;

  const ODMenu({super.key, required this.ODId});

  @override
  State<ODMenu> createState() => _ODMenuState();
}

class _ODMenuState extends State<ODMenu> {
  late CollaboratorCubit adminCubit;

  @override
  void initState() {
    super.initState();
    adminCubit = CollaboratorCubit(
        collaboratorRepository: CollaboratorRepositoryRemote(apiManager: ApiManager.getInstance()));
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
                    name: 'Opportunities',
                    onFunction: () => AppUtil.mainNavigator(context, const ODOpportunitiesPage()),
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
                    onFunction: () => AppUtil.mainNavigator(context, const ODNotificationScreen()),
                  ),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    name: 'Message',
                    onFunction: () {
                      AppUtil.mainNavigator(
                          context,
                          const MessagesScreen(
                            mainColor: ODColorScheme.mainColor,
                            buttonColor: ODColorScheme.buttonColor,
                            textColor: ODColorScheme.textColor,
                          ));
                    },
                  ),
                  CustomMenuCard(
                    iconColor: ODColorScheme.buttonColor,
                    textColor: ODColorScheme.mainColor,
                    name: 'Ask Oppy',
                    onFunction: () {
                      AppUtil.mainNavigator(
                        context,
                        OppyScreen(
                          mainColor: ODColorScheme.mainColor,
                          buttonColor: ODColorScheme.buttonColor,
                          textColor: ODColorScheme.textColor,
                        ),
                      );
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
                        ProfileScreen(
                          buttonColor: ODColorScheme.buttonColor,
                          mainColor: ODColorScheme.mainColor,
                          id: widget.ODId,
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
