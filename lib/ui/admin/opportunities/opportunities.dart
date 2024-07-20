import 'package:co_spririt/ui/admin/opportunities/cubit/opportunites_admin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/dip.dart';
import '../../../utils/components/appbar.dart';

class OpportunitiesScreenAdmin extends StatefulWidget {
  const OpportunitiesScreenAdmin({super.key});

  @override
  State<OpportunitiesScreenAdmin> createState() => _OpportunitiesScreenAdminState();
}

class _OpportunitiesScreenAdminState extends State<OpportunitiesScreenAdmin> {
  late OpportunitesAdminCubit opportunitiesCubit;

  @override
  void initState() {
    super.initState();
    opportunitiesCubit = OpportunitesAdminCubit(opportunitiesRepository: injectOpportunitiesRepository(),clientRepository: injectClientRepository(),collaboratorRepository: injectCollaboratorRepository());
    opportunitiesCubit.fetchOpportunityData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opportunities",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),),
        leading: AppBarCustom(),
      ),
      body: BlocBuilder<OpportunitesAdminCubit, OpportunitesAdminState>(
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
                                  '${opportunity.collaboratorFirstName?.substring(0, 1) ?? ''}${opportunity.collaboratorLastName?.substring(0, 1) ?? ""}'),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '${opportunity.collaboratorFirstName} ${opportunity.collaboratorLastName}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(" Client Name : ${opportunity.clientFirstName} ${opportunity.clientLastName}", style: TextStyle(fontSize: 18.0)),
                        SizedBox(height: 8.0),
                        Text(opportunity.title ?? '', style: TextStyle(fontSize: 18.0)),
                        SizedBox(height: 8.0),
                        Text(opportunity.description ?? ''),
                        SizedBox(height: 8.0),
                        Text("http://10.10.99.13:3090${opportunity.descriptionLocation}")
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
}
