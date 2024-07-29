import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/dip.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';
import 'addoportunities.dart';
import 'cubit/opportunities_cubit.dart';

class OpportunitiesScreenColla extends StatefulWidget {
  const OpportunitiesScreenColla({super.key});

  @override
  State<OpportunitiesScreenColla> createState() => _OpportunitiesScreenCollaState();
}

class _OpportunitiesScreenCollaState extends State<OpportunitiesScreenColla> {
  late OpportunitiesCubit opportunitiesCubit;

  @override
  void initState() {
    super.initState();
    opportunitiesCubit = OpportunitiesCubit(opportunitiesRepository: injectOpportunitiesRepository());
    opportunitiesCubit.fetchOpportunityData();
  }

  void onOpportunityAdded() {
    opportunitiesCubit.fetchOpportunityData();
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Opportunities",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _showAddOpportunityDialog();
              },
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColor.secondColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<OpportunitiesCubit, OpportunitiesState>(
        bloc: opportunitiesCubit,
        builder: (context, state) {
          if (state is OpportunityLoading) {
            return Center(child: CircularProgressIndicator(color: AppColor.secondColor,));
          } else if (state is OpportunityLoaded) {
            return ListView.builder(
              itemCount: state.getOpportunites.length,
              itemBuilder: (context, index) {
                final opportunity = state.getOpportunites[index];
                final url = "http://10.10.99.13:3090${opportunity.descriptionLocation}";
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColor.secondColor,
                              child: Text(
                                  '${opportunity.clientFirstName?.substring(0, 1) ?? ''}${opportunity.clientLastName?.substring(0, 1) ?? ""}',style: TextStyle(color: AppColor.whiteColor),),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '${opportunity.clientFirstName} ${opportunity.clientLastName}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                opportunitiesCubit.deleteOpportunity(opportunity.id!);
                              },
                              child: Icon(Icons.delete, color: AppColor.errorColor),
                            )
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(opportunity.title ?? '', style: TextStyle(fontSize: 18.0)),
                        SizedBox(height: 8.0),
                        Text(opportunity.description ?? ''),
                        SizedBox(height: 8.0),
                        if (opportunity.descriptionLocation != null)
                          InkWell(
                            onTap: () => _launchURL(url),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Attached File',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.basicColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.arrow_right_sharp, size: 40, color: AppColor.secondColor)
                              ],
                            ),
                          ),                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is OpportunityFailure) {
            return Center(child: Text('Failed to load opportunities: ${state.error}'));
          } else {
            return Center(child: Text('No opportunities found'));
          }
        },
      ),
    );
  }

  void _showAddOpportunityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => OpportunitiesCubit(opportunitiesRepository: injectOpportunitiesRepository()),
          child: AddOpportunities(onOpportunityAdded: onOpportunityAdded),
        );
      },
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error opening dialog: $error')));
    });
  }


}
