import 'package:co_spirit/core/app_ui.dart';
import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/menu_item.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:co_spirit/ui/messages/messages.dart';
import 'package:co_spirit/ui/notifications/notifications.dart';
import 'package:co_spirit/ui/opportunities/opportunities.dart';
import 'package:co_spirit/ui/oppy/oppy.dart';
import 'package:co_spirit/ui/profile/Cubit/ow_cubit.dart';
import 'package:co_spirit/ui/profile/ow_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';

class MenuScreenOW extends StatefulWidget {
  static const String routeName = 'Menu Screen Opportunity Manager';
  final String OWId;

  const MenuScreenOW({super.key, required this.OWId});

  @override
  State<MenuScreenOW> createState() => _MenuScreenOWState();
}

class _MenuScreenOWState extends State<MenuScreenOW> {
  late OpportunityOwnerCubit OWCubit;

  @override
  void initState() {
    super.initState();
    OWCubit = OpportunityOwnerCubit(
        opportunityOwnerRepository: OpportunityOwnerRepositoryRemote(
      apiManager: ApiManager.getInstance(),
    ));
    OWCubit.fetchOWDetails(widget.OWId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => OWCubit,
      child: Scaffold(
        appBar: customAppBar(
          title: "Menu",
          context: context,
          backArrowColor: OWColorScheme.buttonColor,
          textColor: OWColorScheme.mainColor,
        ),
        body: BlocBuilder<OpportunityOwnerCubit, OpportunityOwnerState>(
          builder: (context, state) {
            if (state is OpportunityOwnerLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: OWColorScheme.buttonColor));
            } else if (state is OpportunityOwnerDetailsSuccess) {
              final collaborator = state.opportunityOwnerData;
              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: width / 20,
                          right: 20,
                        ),
                        child: ODPhoto(collaborator.pictureLocation, 75, 75),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            collaborator.firstName ?? "N/A",
                            style: const TextStyle(color: OWColorScheme.mainColor, fontSize: 18),
                          ),
                          Text(
                            "Opportunity Owner",
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
                    colorMap: owColorMap,
                    name: 'Home',
                    onFunction: () => Navigator.of(context).pop(),
                  ),
                  CustomMenuCard(
                    colorMap: owColorMap,
                    name: 'Opportunities',
                    onFunction: () => AppUtil.mainNavigator(
                        context, const OpportunitiesPage(colorMap: owColorMap, userType: 4)),
                  ),
                  CustomMenuCard(
                    colorMap: owColorMap,
                    name: 'Notifications',
                    onFunction: () => AppUtil.mainNavigator(
                        context, const NotificationScreen(colorMap: owColorMap)),
                  ),
                  CustomMenuCard(
                    colorMap: owColorMap,
                    name: 'Message',
                    onFunction: () => AppUtil.mainNavigator(
                      context,
                      const MessagesScreen(colorMap: owColorMap),
                    ),
                  ),
                  CustomMenuCard(
                    colorMap: owColorMap,
                    name: 'Ask Oppy',
                    onFunction: () => AppUtil.mainNavigator(
                      context,
                      const OppyScreen(
                        mainColor: OWColorScheme.mainColor,
                        buttonColor: OWColorScheme.buttonColor,
                        textColor: OWColorScheme.textColor,
                      ),
                    ),
                  ),
                  CustomMenuCard(
                    colorMap: owColorMap,
                    name: 'Profile & Settings',
                    enableDivider: false,
                    onFunction: () => AppUtil.mainNavigator(
                      context,
                      ProfileScreenOW(OWId: widget.OWId),
                    ),
                  ),
                ],
              );
            } else if (state is OpportunityOwnerError) {
              return Center(child: Text(state.errorMessage ?? ''));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}