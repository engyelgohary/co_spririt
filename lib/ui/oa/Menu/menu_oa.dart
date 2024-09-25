import 'package:co_spirit/ui/oa/Message/Message_oa.dart';
import 'package:co_spirit/ui/oa/Notifactions/notifictions_oa.dart';
import 'package:co_spirit/ui/oa/Profile/profile_oa.dart';
import 'package:co_spirit/ui/od/Message/Message_od.dart';
import 'package:co_spirit/ui/od/Notifactions/notifictions_od.dart';
import 'package:co_spirit/ui/om/OAForSuperAdmin/Cubit/OA_cubit.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/repository/repository/repository_impl.dart';
import '../../../utils/components/MenuItem.dart';
import '../../../utils/theme/appColors.dart';
import '../../od/requests/request_collaborator.dart';
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
              return const Center(child: CircularProgressIndicator());
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
                    name: 'Profile',
                    onFunction: () {
                      AppUtil.mainNavigator(
                        context,
                        ProfileScreenOA(
                          OAId: widget.OAId,
                        ),
                      );
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Notifications',
                    onFunction: () {
                      Navigator.pushNamed(context, NotificationScreenOA.routName);
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
                    name: 'Requests',
                    onFunction: () {
                      Navigator.pushNamed(context, RequestCollaborator.routeName);
                    },
                  ),
                  CustomMenuCard(
                    iconColor: OAColorScheme.buttonColor,
                    textColor: OAColorScheme.mainColor,
                    name: 'Opportunities',
                    enableDivider: false,
                    onFunction: () => AppUtil.mainNavigator(context, const OpportunitiesPageOA()),
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
