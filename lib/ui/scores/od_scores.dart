import 'package:co_spirit/core/app_ui.dart';
import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/model/Collaborator.dart';
import 'package:co_spirit/data/model/opportunity.dart';
import 'package:co_spirit/ui/opportunities/opportunity_view.dart';
import 'package:flutter/material.dart';

import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';

class ScoresPageOD extends StatefulWidget {
  const ScoresPageOD({super.key});

  @override
  State<ScoresPageOD> createState() => _ScoresPageODState();
}

class _ScoresPageODState extends State<ScoresPageOD> {
  final LoadingStateNotifier<dynamic> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return Scaffold(
      appBar: customAppBar(
        title: "Scores",
        context: context,
        backArrowColor: ODColorScheme.buttonColor,
        textColor: ODColorScheme.mainColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loadingNotifier.change();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 25),
          child: ListenableBuilder(
            listenable: loadingNotifier,
            builder: (context, child) {
              if (loadingNotifier.loading) {
                scoreList(apiManager, loadingNotifier);
                return const Center(
                    child: CircularProgressIndicator(color: ODColorScheme.buttonColor));
              } else if (loadingNotifier.response == null) {
                return Center(
                  child: buildErrorIndicator(
                    "Some error occurred, Please try again.",
                    () => loadingNotifier.change(),
                  ),
                );
              } else if (loadingNotifier.response!.isEmpty) {
                return const Center(
                  child: SelectableText("Nothing to show."),
                );
              }

              final Collaborator odData = loadingNotifier.response![0];
              final List<Opportunity> data = loadingNotifier.response![1];

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text("Total Score:  ${odData.score ?? 0}",
                        style: const TextStyle(
                            color: ODColorScheme.buttonColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: AppColor.whiteColor,
                          thickness: 2,
                        );
                      },
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final opportunity = data[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: ODColorScheme.mainColor,
                            radius: 25,
                            child: Center(
                              child: Icon(
                                Icons.circle,
                                color: Colors.white,
                                // size: 30,
                              ),
                            ),
                          ),
                          title: Text(
                            opportunity.title ?? "N/A",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              color: ODColorScheme.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                opportunity.description ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ODColorScheme.textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "score: ${opportunity.score?.round() ?? 0}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ODColorScheme.buttonColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          trailing: GestureDetector(
                            onTap: () => AppUtil.mainNavigator(
                                context,
                                OpportunityView(
                                  opportunity: opportunity,
                                  userType: 2,
                                  colorMap: odColorMap,
                                )),
                            child: const CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18,
                              child: Icon(
                                Icons.info_outline,
                                color: ODColorScheme.buttonColor,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
