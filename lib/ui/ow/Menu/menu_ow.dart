import 'package:co_spirit/data/repository/repository/repository_impl.dart';
import 'package:co_spirit/ui/ow/Message/Message_ow.dart';
import 'package:co_spirit/ui/ow/Message/oppy_ow.dart';
import 'package:co_spirit/ui/ow/Notifactions/notifictions_ow.dart';
import 'package:co_spirit/ui/ow/Profile/Cubit/ow_cubit.dart';
import 'package:co_spirit/ui/ow/Profile/profile_ow.dart';
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
  late OpportunityOwnerCubit OWCubit;

  @override
  void initState() {
    super.initState();
    OWCubit = OpportunityOwnerCubit(
        opportunityOwnerRepository: OpportunityOwnerRepositoryImpl(
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
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    name: 'Home',
                    onFunction: () => Navigator.of(context).pop(),
                  ),
                  CustomMenuCard(
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    name: 'Opportunities',
                    onFunction: () => AppUtil.mainNavigator(context, const OpportunitiesPageOW()),
                  ),
                  CustomMenuCard(
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    name: 'Notifications',
                    onFunction: () => AppUtil.mainNavigator(context, const NotificationScreenOW()),
                  ),
                  CustomMenuCard(
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    name: 'Message',
                    onFunction: () => AppUtil.mainNavigator(context, const MessagesScreenOW()),
                  ),
/*                  CustomMenuCard(
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
                    name: 'Ask Oppy',
                    onFunction: () => AppUtil.mainNavigator(context, OppyOW()),
                  ),*/
                  CustomMenuCard(
                    iconColor: OWColorScheme.buttonColor,
                    textColor: OWColorScheme.mainColor,
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

  ImageProvider<Object> _getImageProvider(String? pictureLocation) {
    if (pictureLocation != null && pictureLocation.isNotEmpty) {
      return NetworkImage('http://${ApiConstants.baseUrl}$pictureLocation');
    } else {
      return const AssetImage('assets/images/Rectangle 5.png');
    }
  }
}
