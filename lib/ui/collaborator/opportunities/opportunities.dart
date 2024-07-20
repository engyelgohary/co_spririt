import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            return Center(child: CircularProgressIndicator());
          } else if (state is OpportunityLoaded) {
            return ListView.builder(
              itemCount: state.getOpportunites.length,
              itemBuilder: (context, index) {
                final opportunity = state.getOpportunites[index];
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
                              child: Text(
                                  '${opportunity.clientFirstName?.substring(0, 1) ?? ''}${opportunity.clientLastName?.substring(0, 1) ?? ""}'),
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
                        Text(opportunity.descriptionLocation??"")
                      ],
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
