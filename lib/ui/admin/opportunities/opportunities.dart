import 'package:co_spririt/ui/admin/opportunities/cubit/opportunities_admin_cubit.dart';
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/dip.dart';
import '../../../utils/components/appbar.dart';

class OpportunitiesScreenAdmin extends StatefulWidget {
  const OpportunitiesScreenAdmin({super.key});

  @override
  State<OpportunitiesScreenAdmin> createState() => _OpportunitiesScreenAdminState();
}

class _OpportunitiesScreenAdminState extends State<OpportunitiesScreenAdmin> {
  late OpportunitiesAdminCubit opportunitiesCubit;

  @override
  void initState() {
    super.initState();
    opportunitiesCubit = OpportunitiesAdminCubit(
      opportunitiesRepository: injectOpportunitiesRepository(),
      clientRepository: injectClientRepository(),
      collaboratorRepository: injectCollaboratorRepository(),
    );
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
        leading: const AppBarCustom(),
      ),
      body: BlocBuilder<OpportunitiesAdminCubit, OpportunitiesAdminState>(
        bloc: opportunitiesCubit,
        builder: (context, state) {
          if (state is OpportunityLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.secondColor),
            );
          } else if (state is OpportunityLoaded) {
            if (state.getOpportunities.isEmpty) {
              return const Center(child: Text("No Opportunities found"));
            }
            return ListView.builder(
              itemCount: state.getOpportunities.length,
              itemBuilder: (context, index) {
                final opportunity = state.getOpportunities[index];
                final url = "http://10.10.99.13:3090${opportunity.descriptionLocation}";

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColor.secondColor,
                              radius: 20,
                              child: Text(
                                '${opportunity.collaboratorFirstName?.substring(0, 1) ?? ''}${opportunity.collaboratorLastName?.substring(0, 1) ?? ''}',
                                style: const TextStyle(color: AppColor.whiteColor),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${opportunity.collaboratorFirstName} ${opportunity.collaboratorLastName}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                            "Client Name: ${opportunity.clientFirstName} ${opportunity.clientLastName}",
                            style: const TextStyle(fontSize: 18.0)),
                        const SizedBox(height: 8.0),
                        Text(opportunity.title ?? '', style: const TextStyle(fontSize: 18.0)),
                        const SizedBox(height: 8.0),
                        Text(opportunity.description ?? ''),
                        const SizedBox(height: 8.0),
                        if (opportunity.descriptionLocation != null)
                          InkWell(
                            onTap: () => _launchURL(url),
                            child: const Row(
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
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is OpportunityFailure) {
            return Center(child: Text('Failed to load opportunities: ${state.error}'));
          } else {
            return const Center(child: Text('No opportunities found'));
          }
        },
      ),
    );
  }
}
