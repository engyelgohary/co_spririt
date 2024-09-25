import 'package:co_spirit/ui/oa/Message/Message_oa.dart';
import 'package:co_spirit/ui/oa/Message/oppy_oa.dart';
import 'package:co_spirit/ui/oa/Notifactions/notifictions_oa.dart';
import 'package:co_spirit/ui/oa/Profile/profile_oa.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/repository/repository/repository_impl.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';
import '../../od/requests/request_collaborator.dart';
import '../Profile/Cubit/oa_cubit.dart';
import '../opportunities/opportunities_oa.dart';

class MenuScreenOA extends StatefulWidget {
  static const String routeName = 'Menu Screen Opportunity Analyzer';
  final String OAId;

  const MenuScreenOA({super.key, required this.OAId});

  @override
  State<MenuScreenOA> createState() => _MenuScreenOAState();
}

class _MenuScreenOAState extends State<MenuScreenOA> {
  late OpportunityAnalyzerCubit OACubit;

  @override
  void initState() {
    super.initState();
    OACubit = OpportunityAnalyzerCubit(
        opportunityAnalyzerRepository: OpportunityAnalyzerRepositoryImpl(
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
                        child: ODPhoto(OA!.pictureLocation, 75, 75),
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
                      AppUtil.mainNavigator(context, const NotificationScreenOA());
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Message',
                    onFunction: () {
                      AppUtil.mainNavigator(context, const MessagesScreenOA());
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Ask Oppy',
                    onFunction: () {
                      AppUtil.mainNavigator(context, OppyOA());
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
                        ProfileScreenOA(
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
