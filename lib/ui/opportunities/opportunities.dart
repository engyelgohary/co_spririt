import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/model/opportunity.dart';
import 'package:co_spirit/ui/opportunities/od_add_opportunity.dart';
import 'package:co_spirit/ui/opportunities/opportunity_view.dart';
import 'package:flutter/material.dart';

import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';

class OpportunitiesPage extends StatefulWidget {
  final int userType;
  final Map colorMap;
  const OpportunitiesPage({super.key, required this.userType, required this.colorMap});

  @override
  State<OpportunitiesPage> createState() => _ODOpportunitiesPageState();
}

class _ODOpportunitiesPageState extends State<OpportunitiesPage> {
  final LoadingStateNotifier<Opportunity> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = AppUtil.responsiveHeight(context);
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      appBar: customAppBar(
        title: "Opportunities",
        context: context,
        backArrowColor: widget.colorMap["buttonColor"],
        textColor: widget.colorMap["mainColor"],
        actions: [
          if (widget.userType == 2)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                onPressed: () => showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  constraints: BoxConstraints(maxHeight: height * 0.9),
                  context: context,
                  builder: (context) => const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Icon(Icons.horizontal_rule_rounded),
                      ),
                      Flexible(child: AddOpportunity()),
                    ],
                  ),
                ),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loadingNotifier.change();
        },
        child: ListenableBuilder(
          listenable: loadingNotifier,
          builder: (context, child) {
            if (loadingNotifier.loading) {
              opportunitiesList(apiManager, loadingNotifier, userType: widget.userType);
              return Center(
                  child: CircularProgressIndicator(color: widget.colorMap["buttonColor"]));
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

            final data = loadingNotifier.response;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 25),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: AppColor.whiteColor,
                    thickness: 2,
                  );
                },
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  final opportunity = data[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: widget.colorMap["mainColor"],
                      radius: 25,
                      child: const Center(
                        child: Icon(
                          Icons.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      opportunity.title ?? "N/A",
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.colorMap["textColor"],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opportunity.industry ?? "N/A",
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.colorMap["textColor"],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          opportunity.status ?? "N/A",
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.colorMap["buttonColor"],
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
                            userType: widget.userType,
                            colorMap: widget.colorMap),
                      ),
                      child: CircleAvatar(
                        backgroundColor: AppColor.SkyColor,
                        radius: 18,
                        child: Icon(
                          Icons.info_outline,
                          color: widget.colorMap["buttonColor"],
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
