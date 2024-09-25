import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/ui/om/OAForSuperAdmin/Cubit/OA_cubit.dart';
import 'package:co_spririt/ui/om/OAForSuperAdmin/add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../utils/components/appbar.dart';
import '../../../../utils/theme/appColors.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/OA.dart';
import '../../../data/repository/repository/repository_impl.dart';
import '../../../utils/helper_functions.dart';
import 'info_oa.dart';

class OpportunityAnalyzersScreen extends StatefulWidget {
  const OpportunityAnalyzersScreen({super.key});

  @override
  State<OpportunityAnalyzersScreen> createState() => _OpportunityAnalyzersScreenState();
}

class _OpportunityAnalyzersScreenState extends State<OpportunityAnalyzersScreen> {
  late OpportunityAnalyzerCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = OpportunityAnalyzerCubit(
      opportunityAnalyzerRepository: OpportunityAnalyzerRepositoryImpl(
        apiManager: ApiManager.getInstance(),
      ),
    );
  }

  @override
  void dispose() {
    viewModel.pagingController.dispose();
    super.dispose();
  }

  void onOpportunityAdded() {
    viewModel.pagingController.refresh();
  }

  Widget buildErrorIndicator(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(viewModel.pagingController.error.toString()),
          ElevatedButton(
            onPressed: () {
              viewModel.pagingController.refresh();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          title: "Opportunity Analyzers",
          context: context,
          textColor: OMColorScheme.textColor,
          backArrowColor: OMColorScheme.mainColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: const Icon(Icons.person_add_alt_outlined, color: OMColorScheme.buttonColor),
                onPressed: () {
                  showAddBottomSheet();
                },
              ),
            )
          ]),
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<OpportunityAnalyzerCubit, OpportunityAnalyzerState>(
          bloc: viewModel,
          builder: (context, state) {
            return PagedListView<int, OA>.separated(
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<OA>(
                itemBuilder: (context, item, index) {
                  final oaImage = 'http://${ApiConstants.baseUrl}${item.pictureLocation}';
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: oaImage,
                      placeholder: (context, url) => const CircularProgressIndicator(
                        color: AppColor.secondColor,
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: AppColor.SkyColor,
                        radius: 20.r,
                        child:
                            const Icon(Icons.error_outline, color: AppColor.secondColor, size: 20),
                      ),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                    ),
                    title: Text(
                      '${item.firstName} ${item.lastName}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      item.email ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        showOADetailsBottomSheet(item.id.toString());
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColor.SkyColor,
                        radius: 18.r,
                        child: const Icon(
                          Icons.info_outline,
                          color: AppColor.secondColor,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: buildErrorIndicator,
                noItemsFoundIndicatorBuilder: (context) =>
                    const Center(child: Text("No Analyzers found")),
                newPageProgressIndicatorBuilder: (_) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.secondColor),
                  ),
                ),
                firstPageProgressIndicatorBuilder: (_) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.secondColor),
                  ),
                ),
              ),
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 0,
                  color: AppColor.whiteColor,
                  thickness: 1,
                );
              },
            );
          },
        ),
      ),
    );
  }

  void showAddBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: viewModel,
          child: AddOA(
            onOpportunityAdded: onOpportunityAdded,
          ),
        );
      },
    );
  }

  void showOADetailsBottomSheet(String id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        viewModel.fetchOADetails(id);

        return BlocBuilder<OpportunityAnalyzerCubit, OpportunityAnalyzerState>(
          bloc: viewModel,
          builder: (context, state) {
            if (state is OpportunityAnalyzerLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.secondColor,
                ),
              );
            } else if (state is OpportunityAnalyzerDetailsSuccess) {
              return InfoOA(state.opportunityAnalyzerData);
            } else if (state is OpportunityAnalyzerError) {
              return Center(child: Text(state.errorMessage ?? "Error fetching details"));
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.secondColor,
                ),
              );
            }
          },
        );
      },
    );
  }
}
