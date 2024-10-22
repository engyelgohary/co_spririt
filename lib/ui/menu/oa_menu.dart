import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/menu_item.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:co_spirit/ui/messages/message_screen.dart';
import 'package:co_spirit/ui/notifications/oa_notifications.dart';
import 'package:co_spirit/ui/opportunities/oa_opportunities.dart';
import 'package:co_spirit/ui/oppy/oppy.dart';
import 'package:co_spirit/ui/profile/Cubit/oa_cubit.dart';
import 'package:co_spirit/ui/profile/oa_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';

class OAMenuScreen extends StatefulWidget {
  final String OAId;

  const OAMenuScreen({super.key, required this.OAId});

  @override
  State<OAMenuScreen> createState() => _OAMenuScreenState();
}

class _OAMenuScreenState extends State<OAMenuScreen> {
  late OpportunityAnalyzerCubit OACubit;

  @override
  void initState() {
    super.initState();
    OACubit = OpportunityAnalyzerCubit(
        opportunityAnalyzerRepository: OpportunityAnalyzerRepositoryRemote(
      apiManager: ApiManager.getInstance(),
    ));
    OACubit.fetchOADetails(widget.OAId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => OACubit,
      child: Scaffold(
        appBar: customAppBar(
          title: "Menu",
          context: context,
          backArrowColor: OAColorScheme.buttonColor,
          textColor: OAColorScheme.mainColor,
        ),
        body: BlocBuilder<OpportunityAnalyzerCubit, OpportunityAnalyzerState>(
          builder: (context, state) {
            if (state is OpportunityAnalyzerLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: OAColorScheme.buttonColor));
            } else if (state is OpportunityAnalyzerDetailsSuccess) {
              final OA = state.opportunityAnalyzerData;
              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: width / 20,
                          right: 20,
                        ),
                        child: ODPhoto(OA.pictureLocation, 75, 75),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            OA.firstName ?? "N/A",
                            style: const TextStyle(color: OAColorScheme.mainColor, fontSize: 18),
                          ),
                          Text(
                            "Opportunity Analyzer",
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
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Home',
                    onFunction: () => Navigator.of(context).pop(),
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Opportunities',
                    onFunction: () => AppUtil.mainNavigator(context, const OpportunitiesPageOA()),
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Notifications',
                    onFunction: () {
                      AppUtil.mainNavigator(context, const OANotificationScreen());
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Message',
                    onFunction: () {
                      AppUtil.mainNavigator(
                          context,
                          const MessagesScreen(
                            mainColor: OAColorScheme.mainColor,
                            buttonColor: OAColorScheme.buttonColor,
                            textColor: OAColorScheme.textColor,
                          ));
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Ask Oppy',
                    onFunction: () {
                      AppUtil.mainNavigator(
                        context,
                        OppyScreen(
                          mainColor: OAColorScheme.mainColor,
                          buttonColor: OAColorScheme.buttonColor,
                          textColor: OAColorScheme.textColor,
                        ),
                      );
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Profile & Settings',
                    enableDivider: false,
                    onFunction: () {
                      AppUtil.mainNavigator(
                        context,
                        OAProfileScreen(
                          OAId: widget.OAId,
                        ),
                      );
                    },
                  ),
                ],
              );
            } else if (state is OpportunityAnalyzerError) {
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
